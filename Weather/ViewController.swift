//
//  ViewController.swift
//  Weather
//
//  Created by IO on 21/08/2019.
//  Copyright © 2019 mukh.io. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation
import Foundation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
//    Redudent label in my option but somehow crashs the whole app when removed.
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var locatLabel: UILabel!
    
    let gradientLayer = CAGradientLayer()
    
    let apiKey = "REPLACE WITH YOUR OPENWEATHERMAP API KEY"
//    var lat = 11.344533
//    var lon = 104.33322
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        
        let indicatorSize: CGFloat = 70;
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize/2), y: (view.frame.height-indicatorSize/2), width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
//        Pop up notification requesting privliages to use location services.
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.locatLabel.text = jsonResponse["name"].stringValue
//                Debugging Remove Later
//                print("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric")
                self.conditionImageView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from: date)
                
                let suffix = iconName.suffix(1)
                if (suffix == "n") {
                    self.setGreyGradientBackground()
                } else {
                    self.setBlueGradientBackground()
                }
            }
        }
        self.locationManager.stopUpdatingLocation()
        
    }

    func setBlueGradientBackground(){
        let topColour = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColour = UIColor(red:72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha:1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColour, bottomColour]
    }
    
    func setGreyGradientBackground() {
        let topColour = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0, alpha: 1.0).cgColor
        let bottomColour = UIColor(red:72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha:1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColour, bottomColour]
    }
}

