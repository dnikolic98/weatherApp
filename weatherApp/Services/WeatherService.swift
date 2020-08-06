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
    
    func fetchCurrentWeather(id: Int, completion: @escaping ((CurrentWeather?) -> Void)){
        let property = "id=\(id)"
        fetchCurrentWeather(property: property) { (currentWeather) in
            if let currentWeather = currentWeather {
                completion(currentWeather)
            } else {
                completion(nil)
            }
        }
    }
    
    func fetchCurrentWeather(name: String, completion: @escaping ((CurrentWeather?) -> Void)){
        let property = "q=\(name)"
        fetchCurrentWeather(property: property) { (currentWeather) in
            if let currentWeather = currentWeather {
                completion(currentWeather)
            } else {
                completion(nil)
            }
        }
    }
    
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
                if let jsonDict = json as? [String: Any] {
                    let currentWeather = CurrentWeather(json: jsonDict)
                    completion(currentWeather)
                }
            } catch {
                completion(nil)
            }
        }
        dataTask.resume()
    }
    
}

