//
//  WeatherDataModel.swift
//  weather1
//
//  Created by Hyunju Kim on 4/6/24.
//

import Foundation
struct WeatherDataModel {
    let city: String
    
    let lat: Double
    let lon: Double
    
    let temperature: Double
    var tempString: String {
        return String(format: "%.1f", temperature)
    }
    
    let description: String
    
    let conditionID: Int
    var conditionImage: String {
        get {
            switch conditionID {
            case 200...232:
                return "cloud.bolt.rain"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "smoke"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud"
            default:
                return "zzz"
            }
        }
    }
}

