//
//  WeatherService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation


class WeatherService {
    private let apiKey = "bfac26f5e35c596e0656c5847c49d349"
    private let baseUrlString = "https://api.openweathermap.org/data/2.5/weather"
    
    //MARK: - Fetching
    
    // current weather fetching logic for fetching by the location id
    func fetchCurrentWeather(id: Int, completion: @escaping ((CurrentWeather?) -> Void)){
        let property = "id=\(id)"
        fetchCurrentWeather(property: property) { (currentWeather) in
            guard let currentWeather = currentWeather else {
                completion(nil)
                return
            }
            
            completion(currentWeather)
        }
    }
    
    // current weather fetching logic for fetching by the location name
    func fetchCurrentWeather(name: String, completion: @escaping ((CurrentWeather?) -> Void)){
        let property = "q=\(name)"
        fetchCurrentWeather(property: property) { (currentWeather) in
            guard let currentWeather = currentWeather else {
                completion(nil)
                return
            }
            
            completion(currentWeather)
        }
    }
    
    // main current weather fetching logic
    private func fetchCurrentWeather(property: String, completion: @escaping ((CurrentWeather?) -> Void)) {
        let resourceStringUrl = "\(baseUrlString)?\(property)&APPID=\(apiKey)"
        guard let url = URL(string: resourceStringUrl) else {
            completion(nil)
            return
        }
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard
                    let jsonDict = json as? [String: Any],
                    let weather = self.jsonToWeather(json: jsonDict["weather"] as! [Any]),
                    let forecast = self.jsonToForecast(json: jsonDict["main"] as Any),
                    let wind = self.jsonToWind(json: jsonDict["wind"] as Any),
                    let currentWeather = self.jsonToCurrentWeather(json: jsonDict, forecast: forecast, weather: weather, wind: wind) else {
                        completion(nil)
                        return
                }

                completion(currentWeather)
            } catch {
                completion(nil)
            }
        }
        dataTask.resume()
    }
    
    //MARK: - JSON to model
    
    private func jsonToWeather(json: [Any]) -> Weather? {
        guard
            let jsonDict = json[0] as? [String: Any],
            let description = jsonDict["description"] as? String,
            let icon = jsonDict["icon"] as? String,
            let id = jsonDict["id"] as? Int,
            let main = jsonDict["main"] as? String else { return nil }
        
        return Weather(description: description, icon: icon, id: id, main: main)
        
    }
    
    private func jsonToForecast(json: Any) -> Forecast? {
        guard
            let jsonDict = json as? [String: Any],
            let feelsLikeTemperature = jsonDict["feels_like"] as? Double,
            let humidity = jsonDict["humidity"] as? Int,
            let pressure = jsonDict["pressure"] as? Int,
            let temperature = jsonDict["temp"] as? Double,
            let maxTemperature = jsonDict["temp_max"] as? Double,
            let minTemperature = jsonDict["temp_min"] as? Double else { return nil }
        
        let feelsLike = Temperature(kelvin: feelsLikeTemperature)
        let temp = Temperature(kelvin: temperature)
        let maxTemp = Temperature(kelvin: maxTemperature)
        let minTemp = Temperature(kelvin: minTemperature)
        
        return Forecast(feelsLikeTemperature: feelsLike, humidity: humidity, pressure: pressure, temperature: temp, maxTemperature: maxTemp, minTemperature: minTemp)
        
    }
    
    private func jsonToWind(json: Any) -> Wind? {
        guard
            let jsonDict = json as? [String: Any],
            let speed = jsonDict["speed"] as? Double,
            let directionDegree = jsonDict["deg"] as? Int else { return nil }
        
        return Wind(speed: speed, directionDegree: directionDegree)
    }
    
    private func jsonToCurrentWeather(json: Any, forecast: Forecast, weather: Weather, wind: Wind) -> CurrentWeather? {
        guard
            let jsonDict = json as? [String: Any],
            let id = jsonDict["id"] as? Int,
            let name = jsonDict["name"] as? String,
            let timezone = jsonDict["timezone"] as? Int else { return nil }
        
        return CurrentWeather(id: id, forecast: forecast, name: name, timezone: timezone, weather: weather, wind: wind)
        
    }
    
}

