//
//  UserDefaultsPersistence.swift
//  TaskyApp
//
//  Created by Yuri Correa on 07/07/24.
//

import Foundation

protocol Persistence {
    func saveData(data: Data, key: String)
    func loadData(key: String) -> Data?
}


class UserDefaultsPersistence: Persistence {
    func saveData(data: Data, key: String) {
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func loadData(key: String) -> Data? {
        return UserDefaults.standard.data(forKey: key)
    }
    
    
}
