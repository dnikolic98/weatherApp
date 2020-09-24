//
//  PreloadingCoreDataStack.swift
//  weatherApp
//
//  Created by Dario Nikolic on 04/09/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

/// Manages adding premade persistence store to the apps persistence store.
///
/// Used for checking if persistence store already exists in apps documents folder.
/// If persistence store does not exist, premade persistence store is copied to the apps doucements folder.
class PresavedSQLiteManager {
    
    private lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    private lazy var url: String = {
        applicationDocumentsDirectory.path + "/weatherApp.sqlite"
    }()
    
    func checkIfDatabaseExists() {
        // Check if database exist
        guard !FileManager.default.fileExists(atPath: url) else { return print(url)}
        
        let sourceSqliteURLs = [
            Bundle.main.url(forResource: "weatherApp", withExtension: "sqlite")!,
            Bundle.main.url(forResource: "weatherApp", withExtension: "sqlite-wal")!,
            Bundle.main.url(forResource: "weatherApp", withExtension: "sqlite-shm")!
        ]
        
        let destSqliteURLs = [
            applicationDocumentsDirectory.appendingPathComponent("weatherApp.sqlite"),
            applicationDocumentsDirectory.appendingPathComponent("weatherApp.sqlite-wal"),
            applicationDocumentsDirectory.appendingPathComponent("weatherApp.sqlite-shm")
        ]
        
        // Copy files from resources to documents
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
