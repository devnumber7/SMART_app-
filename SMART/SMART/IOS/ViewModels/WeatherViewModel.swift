//
//  WeatherViewModel.swift
//  SMART
//
//  Created by Anson Jiang on 11/29/24.
//

import Foundation

class WeatherViewModel: ObservableObject {
    
    @Published var weather: String = "Loading..."
    @Published var temp: String = "Loading..."
    @Published var windSpeed: String = "Loading..."
    @Published var humidity: String = "Loading..."
    
    private let weatherService = WeatherService()
    
    func fetchService(lat: Double, lon: Double) {
        Task {
            do {
                let service = try await self.weatherService.getWeather(lat: lat, lon: lon)
                
                // Update the values and @Published properties on the main thread
                DispatchQueue.main.async {
                    self.temp = "\(Double(service.list[0].main.temp))°C"
                    self.windSpeed = "\(Double(service.list[3].wind.speed)) m/s"
                    self.humidity = "\(Double(service.list[0].main.humidity))"
                    self.weather = "\(service.list[1].weather[0].main)"
                }
            } catch {
                print("Error fetching weather: \(error)")
            }
        }
    }
}
