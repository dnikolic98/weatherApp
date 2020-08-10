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
    private let baseUrlString = "https://api.openweathermap.org/data/2.5/"
    
    //MARK: - Fetching
    
    func fetchSeveralCurrentWeather(id: [Int], completion: @escaping (([CurrentWeather]?) -> Void)) {
        var currentWeatherList: [CurrentWeather] = []
        
        let severalIds = id.map { String($0) }.joined(separator:",")
        let resourceStringUrl = "\(baseUrlString)group?id=\(severalIds)&APPID=\(apiKey)"
        
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
                    let dataList = jsonDict["list"] as? [[String: Any]]
                else {
                    completion(nil)
                    return
                }
                
                for data in dataList {
                    guard
                        let currentWeather = self.jsonToCurrentWeather(json: data)
                    else {
                        completion(nil)
                        return
                    }

                    currentWeatherList.append(currentWeather)
                }

                completion(currentWeatherList)
            } catch {
                completion(nil)
            }
        }
        dataTask.resume()
    }
    
    // current weather fetching logic for fetching by the location id
       func fetchCurrentWeather(id: Int, completion: @escaping ((CurrentWeather?) -> Void)) {
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
       func fetchCurrentWeather(name: String, completion: @escaping ((CurrentWeather?) -> Void)) {
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
        let resourceStringUrl = "\(baseUrlString)weather?\(property)&APPID=\(apiKey)"
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
                    let currentWeather = self.jsonToCurrentWeather(json: jsonDict)
                else {
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
            let main = jsonDict["main"] as? String
        else {
            return nil
            
        }
        
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
            let minTemperature = jsonDict["temp_min"] as? Double
        else {
            return nil
            
        }
        
        let feelsLike = Temperature(kelvin: feelsLikeTemperature)
        let temp = Temperature(kelvin: temperature)
        let maxTemp = Temperature(kelvin: maxTemperature)
        let minTemp = Temperature(kelvin: minTemperature)
        
        return Forecast(feelsLikeTemperature: feelsLike, humidity: humidity, pressure: pressure, temperature: temp, maxTemperature: maxTemp, minTemperature: minTemp)
        
    }
    
    private func jsonToCurrentWeather(json: Any) -> CurrentWeather? {
        guard
            let jsonDict = json as? [String: Any],
            let id = jsonDict["id"] as? Int,
            let name = jsonDict["name"] as? String,
            let weather = self.jsonToWeather(json: jsonDict["weather"] as! [Any]),
            let forecast = self.jsonToForecast(json: jsonDict["main"] as Any)
        else {
            return nil
            
        }
        
        return CurrentWeather(id: id, forecast: forecast, name: name, weather: weather)
        
    }
    
}

