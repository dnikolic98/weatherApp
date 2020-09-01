//
//  WeatherService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 03/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation
import RxSwift

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
    
    func fetchForecastWeather(coord: Coordinates) -> Observable<ForecastedWeather> {
        let resourceStringUrl = "\(baseUrlString)onecall?exclude=current,minutely&lat=\(coord.latitude)&lon=\(coord.longitude)&units=\(LocalizedStrings.units)&appid=\(apiKey)"
        
        return fetchData(resourceUrlString: resourceStringUrl)
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
    
    func fetchSeveralCurrentWeather(id: [Int]) -> Observable<[CurrentWeather]> {
        let severalIds = id.map { String($0) }.joined(separator:",")
        let resourceStringUrl = "\(baseUrlString)group?id=\(severalIds)&units=\(LocalizedStrings.units)&APPID=\(apiKey)"
        
        return fetchData(resourceUrlString: resourceStringUrl)
    }
    
    func fetchCurrentWeather(coord: Coordinates, completion: @escaping ((CurrentWeather?) -> Void)) {
        let resourceStringUrl = "\(baseUrlString)weather?lat=\(coord.latitude)&lon=\(coord.longitude)&units=\(LocalizedStrings.units)&appid=\(apiKey)"
        
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
                let currentWeather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                completion(currentWeather)
            } catch {
                completion(nil)
            }
             
        }
        dataTask.resume()
    }
    
    func fetchCurrentWeather(coord: Coordinates) -> Observable<CurrentWeather>{
        let resourceStringUrl = "\(baseUrlString)weather?lat=\(coord.latitude)&lon=\(coord.longitude)&units=\(LocalizedStrings.units)&appid=\(apiKey)"
        
        return fetchData(resourceUrlString: resourceStringUrl)
    }
    
    private func fetchData<T: Decodable>(resourceUrlString: String) -> Observable<T> {
        return Observable<T>.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            do {
                let request = try self.buildRequest(from: resourceUrlString)
                let dataTask = URLSession.shared.dataTask(with: request) { result in
                    switch result {
                    case .success(let (_, data)):
                        do {
                            let values = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(values)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            dataTask.resume()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    private func buildRequest(from urlString: String) throws -> URLRequest {
        guard let url = URL(string: urlString) else { throw NetworkError.badURL}
        return URLRequest(url: url)
    }
}
