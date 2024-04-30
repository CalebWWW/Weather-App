//
//  WeatherForecastDataModel.swift
//  weather2
//
//  Created by Nathan Freeman on 4/17/24.
//

import Foundation

struct WeatherForecastDataModel {
    var forecast: [(String, String, String)]
}

struct WeatherForecastData: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ForecastListItem]
    let city: ForecastCity
}

struct ForecastListItem: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let dt_txt: String
}

struct ForecastMain: Codable {
    let temp: Double
}

struct ForecastWeather: Codable {
    let id: Int
    let description: String
}

struct ForecastCity: Codable {
    let id: Int
    let name: String
}

