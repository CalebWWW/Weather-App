//
//  ViewController.swift
//  weather1
//
//  Created by Hyunju Kim on 4/4/24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var locationTF: UITextField!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    
    var weatherData = WeatherData()
    let locationManager = CLLocationManager()
    
    var times = ["04-15 12:00","04-15 15:00", "04-15 18:00", "04-15 21:00", "04-16 00:00", "04-16 12:00"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTF.delegate = self
        weatherData.delegate = self
       
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
    }

    @IBAction func getLocation(_ sender: UIButton) {
        locationTF.endEditing(true)
    }
    
    @IBAction func getCurrentLocWeather(_ sender: Any) {
        locationManager.requestLocation()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
   
}

// MARK: WeatherDataDelegate
extension WeatherViewController: WeatherDataDelegate {
    
    func weatherDataForecastDidUpdate(_ weatherData: WeatherData, weatherForecast: WeatherForecastDataModel) {
        <#code#>
    }
    
    func weatherDataDidUpdate(_ weatherData: WeatherData, weather: WeatherDataModel) {
        //print(weather.tempString)
        DispatchQueue.main.async {
            self.degreeLabel.text = weather.tempString
            self.locationLabel.text = weather.city
            self.conditionLabel.text = weather.description
            self.weatherImage.image = UIImage(systemName: weather.conditionImage)
        }
    }
    
    func weatherDataDidFailWithError(error: any Error) {
        print(error.localizedDescription)
    }
}

// MARK: DLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last { //multiple loc data
            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            //print(lat, lon)
            //weatherData.getWeather(lat: lat, long: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return times.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        if let aCell = cell as? WeatherCollectionViewCell {
            aCell.timeLabel.text = times[indexPath.item]
        }
        return cell
    }
    
    
}


// MARK: UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTF.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = locationTF.text {
            weatherData.getWeather(city: city.trimmingCharacters(in: .whitespaces))
            locationLabel.text = locationTF.text!
            locationTF.text = ""
        }
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if locationTF.text != "" {
            return true
        } else {
            locationTF.placeholder = "Type a location"
            return false
        }
    }
}
