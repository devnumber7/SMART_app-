//
//  WeatherService.swift
//  SMART
//
//  Created by Anson Jiang on 11/29/24.
//
import Foundation

class WeatherService: ObservableObject {
    let baseUrl = "https://api.openweathermap.org/data/2.5/forecast"
    let apiKey = "73cdd663b039a28663145e3ac187c742"

    //api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=73cdd663b039a28663145e3ac187c742
    
    func getWeather(lat: Double, lon: Double) async throws -> WeatherModel {
        let urlString = "\(baseUrl)?lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else { throw WeatherError.invalidUrl}
                
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            
            if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw Response Data: \(jsonString)")
                } else {
                    print("Raw Response Data (binary): \(data)")
            }
            throw WeatherError.invalidUrl
            
            
        }
        
        
        do {
            let decoder = try JSONDecoder().decode(WeatherModel.self, from: data)
            print("Decoded WeatherModel: \(decoder)")
            return decoder
        }
        catch {
            throw WeatherError.invalidData
        }
        
    }
    
}
