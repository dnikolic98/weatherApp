//
//  CityLocationsService.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import RxSwift

class CityLocationService {
    
    public typealias CityLocationCompletion = () -> ()
    
    private let fileName: String = "city_list"
    private let fileType: String = "json"
    private let completion: CityLocationCompletion
    private var json: [City] = []
    
    init(completion: @escaping CityLocationCompletion) {
        self.completion = completion
        
        threadSerialization()
    }
    
    public func fetchCity(query: String) -> [City] {
        let filteredCities = json.filter { $0.name.range(of: query, options: [.caseInsensitive, .anchored]) != nil }
        
        return filteredCities
    }
    
    private func threadSerialization() {
        DispatchQueue.global(qos: .background).async {
            guard let data = self.serializeJson() else { return }
            self.json = data

            DispatchQueue.main.async {
                self.completion()
            }
        }
    }
    
    private func serializeJson() -> [City]? {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileType) else {
            fatalError("Failed to create path to cityList file")
        }
        let fileURL = URL(fileURLWithPath: filePath)

        do {
            let jsonData = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([City].self, from: jsonData)
        } catch {
            print(error)
            return nil
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


