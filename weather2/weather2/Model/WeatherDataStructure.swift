//
//  WeatherDataStructure.swift
//  weather1
//
//  Created by Hyunju Kim on 4/4/24.
//

import Foundation
struct WeatherDataStructure: Codable {
    let coord: Coord
    
    let name: String
    let main: Main
    let weather: [Weather]
}

struct WeatherForecastDataStructure: Codable {
    let list: [List]
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct List: Codable {
    let main: Main
    let weather: Weather
    let dt_text: String
}
