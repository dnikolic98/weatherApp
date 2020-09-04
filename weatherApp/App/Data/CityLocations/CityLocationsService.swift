//
//  CityLocationsService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxSwift

class CityLocationService: CityLocationServiceProtocol {
    
    public typealias CityLocationCompletion = () -> ()
    
    private let fileName: String = "city_list"
    private let fileType: String = "json"
    private let completion: CityLocationCompletion
    private var json: [City] = []
    
    private (set) var cityList: Observable<[City]>
    
    init(completion: @escaping CityLocationCompletion) {
        cityList = serializeJson()
    }
    
    private func serializeJson() -> Observable<[City]> {
        return Observable.create() { [weak self] observer in
            guard
                let self = self,
                let filePath = Bundle.main.path(forResource: self.fileName, ofType: self.fileType)
            else {
                return Disposables.create()
            }
            
            let fileURL = URL(fileURLWithPath: filePath)
            do {
                let jsonData = try Data(contentsOf: fileURL)
                let cityList = try JSONDecoder().decode([City].self, from: jsonData)
                observer.onNext(cityList)
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
//
//    [{
//    "id": 833,
//    "name": "Ḩeşār-e Sefīd",
//    "state": "",
//    "country": "IR",
//    "coord": {
//      "lon": 47.159401,
//      "lat": 34.330502
//    }]
//
}


