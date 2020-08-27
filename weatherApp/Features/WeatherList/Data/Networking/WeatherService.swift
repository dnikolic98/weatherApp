//
//  WeatherService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

class WeatherService: WeatherServiceProtocol {
    
    private let apiKey = "bfac26f5e35c596e0656c5847c49d349"
    private let baseUrlString = "https://api.openweathermap.org/data/2.5/"
    
    //MARK: - Fetching
    
    func fetchForcastWeather(coord: Coordinates, completion: @escaping ((ForecastedWeather?) -> Void)) {
        let resourceStringUrl = "\(baseUrlString)onecall?exclude=current,minutely&lat=\(coord.latitude)&lon=\(coord.longitude)&units=\(LocalizedStrings.units)&appid=\(apiKey)"
        
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
                let forecastedWeather = try JSONDecoder().decode(ForecastedWeather.self, from: data)
                completion(forecastedWeather)
            } catch {
                completion(nil)
            }
        }
        dataTask.resume()
    }
    
    func fetchSeveralCurrentWeather(id: [Int], completion: @escaping (([CurrentWeather]) -> Void)) {
        let severalIds = id.map { String($0) }.joined(separator:",")
        let resourceStringUrl = "\(baseUrlString)group?id=\(severalIds)&units=\(LocalizedStrings.units)&APPID=\(apiKey)"
        
        guard let url = URL(string: resourceStringUrl) else {
            completion([])
            return
        }
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let multipleWeather = try JSONDecoder().decode(MultipleCurrentWeather.self, from: data)
                completion(multipleWeather.list)
            } catch {
                completion([])
            }
             
        }
        dataTask.resume()
    }
    
}

