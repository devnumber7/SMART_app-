//
//  WeatherModel.swift
//  SMART
//
//  Created by Anson Jiang on 11/29/24.
//


import Foundation

// Top-level weather response
struct WeatherModel: Codable {
    let list: [WeatherForecast]
    let city: City
    
    
    
    // Weather forecast details
    struct WeatherForecast: Codable {
        let dt: Int
        let main: MainWeather
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let pop: Double
        let rain: Rain?
        let sys: Sys
        let dtTxt: String

        enum CodingKeys: String, CodingKey {
            case dt
            case main
            case weather
            case clouds
            case wind
            case visibility
            case pop
            case rain
            case sys
            case dtTxt = "dt_txt"
        }
    }

    // Main weather details
    struct MainWeather: Codable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let seaLevel: Int
        let grndLevel: Int
        let humidity: Int
        let tempKf: Double

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
            case humidity
            case tempKf = "temp_kf"
        }
    }

    // Weather description
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    // Cloud details
    struct Clouds: Codable {
        let all: Int
    }

    // Wind details
    struct Wind: Codable {
        let speed: Double
        let deg: Int
        let gust: Double
    }

    // Rain details (optional)
    struct Rain: Codable {
        let threeHour: Double

        enum CodingKeys: String, CodingKey {
            case threeHour = "3h"
        }
    }

    // System details
    struct Sys: Codable {
        let pod: String
    }

    // City details
    struct City: Codable {
        let id: Int
        let name: String
        let coord: Coordinate
        let country: String
        let population: Int
        let timezone: Int
        let sunrise: Int
        let sunset: Int
    }

    // City coordinates
    struct Coordinate: Codable {
        let lat: Double
        let lon: Double
    }


    
}

enum WeatherError: Error {
    case invalidUrl
    case invalidData
}


