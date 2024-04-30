//
//  WeatherData.swift
//  weather1
//
//  Created by Hyunju Kim on 4/4/24.
//

import Foundation
import CoreLocation

protocol WeatherDataDelegate {
    func weatherDataDidUpdate(_ weatherData: WeatherData, weather: WeatherDataModel)
    func weatherDataDidFailWithError(error: Error)
    func weatherDataForecastDidUpdate(_ weatherData: WeatherData, weatherForecast: WeatherForecastDataModel)
}

struct WeatherData {
    
    var delegate: WeatherDataDelegate?
    
    let url = "https://api.openweathermap.org/data/2.5/weather?&appid=ff1d8b120f757cbddbb130031e0f9d28&units=imperial"
    
    let foreUrl = "https://api.openweathermap.org/data/2.5/forecast?lat=41.8661&lon=-88.1066&appid=ff1d8b120f757cbddbb130031e0f9d28&cnt=6&units=imperial"
    
    
    func getWeather(city: String) {
        let urlString = "\(url)&q=\(city)"
        performRequest(urlString: urlString, forecast: false)
        //print(urlString)
    }
    
    func getWeather(lat: CLLocationDegrees, lon:CLLocationDegrees) {
        let urlString = "\(url)&lat=\(lat)&lon=\(lon)"
        //print(urlString)
        performRequest(urlString: urlString, forecast: false)
    }
    
    func getWeatherForecast(lat: Double, lon: Double) {
        let urlString = "\(foreUrl)&lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString, forecast: true)
    }
    
    func performRequest(urlString: String, forecast: Bool) {
        if forecast {
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url, completionHandler: handleCompletionForecast( data:response:error:) )
                task.resume()
            }
        } else {
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url, completionHandler: handleCompletion( data:response:error:) )
                task.resume()
            }
        }
    }
    
    func handleCompletionForecast(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            //print(error!)
            self.delegate?.weatherDataDidFailWithError(error: error!)
            return
        }
        guard let data = data else {
            self.delegate?.weatherDataDidFailWithError(error: error!)
            //print(error.debugDescription)
            return
        }
        
//        if let dataString = String(data: data, encoding: .utf8) {
//            print(dataString)
//        }
        //let weather = parseData(weatherData: data)
        if let weather = parseForecastData(weatherData: data) {
            self.delegate?.weatherDataForecastDidUpdate(self, weatherForecast: weather)
        }
    }
    
    func handleCompletion(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            //print(error!)
            self.delegate?.weatherDataDidFailWithError(error: error!)
            return
        }
        guard let data = data else {
            self.delegate?.weatherDataDidFailWithError(error: error!)
            //print(error.debugDescription)
            return
        }
        
//        if let dataString = String(data: data, encoding: .utf8) {
//            print(dataString)
//        }
        //let weather = parseData(weatherData: data)
        if let weather = parseData(weatherData: data) {
            self.delegate?.weatherDataDidUpdate(self, weather: weather)
        }
    }
    
    func parseData(weatherData: Data) -> WeatherDataModel? {
        do {
            let parsedWeather = try JSONDecoder().decode(WeatherDataStructure.self, from: weatherData)
            
            let name = parsedWeather.name
            let temp = parsedWeather.main.temp
            let description = parsedWeather.weather[0].description
            let id = parsedWeather.weather[0].id
            let lat = parsedWeather.coord.lat
            let lon = parsedWeather.coord.lon
            
            let weather = WeatherDataModel(city: name, lat: lat, lon: lon, temperature: temp, description: description, conditionID: id)
            return weather
            
//            print(weather.city)
//            print(weather.description)
//            print(weather.tempString)
//            print(weather.conditionID)
//            print(weather.conditionImage)
        } catch {
            self.delegate?.weatherDataDidFailWithError(error: error)
            //print(error.localizedDescription)
            return nil
        }
    }
    
    func parseForecastData(weatherData: Data) -> WeatherForecastDataModel? {
        do {
            let parsedWeather = try JSONDecoder().decode(WeatherForecastDataStructure.self, from: weatherData)
            
            var weatherForecast: [(String, String, String)] = []
            
            for listItem in parsedWeather.list {
                let id = String(listItem.weather.id)
                let temp = String(listItem.main.temp)
                let dt_txt = listItem.dt_text
                
                weatherForecast.append((id, temp, dt_txt))
            }
            
            let weather = WeatherForecastDataModel(forecast: weatherForecast)
            return weather
            
        } catch {
            self.delegate?.weatherDataDidFailWithError(error: error)
            //print(error.localizedDescription)
            return nil
        }
    }
}
