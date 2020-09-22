//
//  PreloadingCoreDataStack.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

class PresavedSQLiteManager {
    
    private let weatherApp = "weatherApp"
    lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    lazy var url: String = {
        applicationDocumentsDirectory.path + "/" + weatherApp + ".sqlite"
    }()
    
    func checkIfDatabaseExists() {
        if !FileManager.default.fileExists(atPath: url) {
            let sourceSqliteURLs = [
                Bundle.main.url(forResource: weatherApp, withExtension: "sqlite")!,
                Bundle.main.url(forResource: weatherApp, withExtension: "sqlite-wal")!,
                Bundle.main.url(forResource: weatherApp, withExtension: "sqlite-shm")!
            ]
            
            let destSqliteURLs = [
                applicationDocumentsDirectory.appendingPathComponent(weatherApp + ".sqlite"),
                applicationDocumentsDirectory.appendingPathComponent(weatherApp + ".sqlite-wal"),
                applicationDocumentsDirectory.appendingPathComponent(weatherApp + ".sqlite-shm")
            ]
            
            for  index in 0..<sourceSqliteURLs.count {
                do {
                    try FileManager.default.copyItem(at: sourceSqliteURLs[index], to: destSqliteURLs[index])
                }
                catch {
                    print("Couldnt copy presaved database")
                }
            }
        }
    }
    
}
