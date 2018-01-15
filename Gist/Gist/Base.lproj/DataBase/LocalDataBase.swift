//
//  LocalDataBase.swift
//  Gist
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2018 Vinicius Minozzi. All rights reserved.
//

import Foundation

class LocalDataBase {
    
    private let userDefault = UserDefaults.standard
    
    func save<T: Mappable>(object: T) {
        let key = "Gist.\(String(describing: T.self))"
        
        var array = [T]()
        if let data = userDefault.data(forKey: key), let decoded = try? JSONDecoder().decode([T].self, from: data) {
            array = decoded
        }
        array.append(object)
        let encoded = try? JSONEncoder().encode(array)
        userDefault.set(encoded, forKey: key)
    }
    
    func remove<T: Mappable>(object: T) {
        let key = "Gist.\(String(describing: T.self))"
        guard let data = userDefault.data(forKey: key), let decoded = try? JSONDecoder().decode([T].self, from: data) else {
            return
        }
        
        let array = decoded.filter { $0 != object }
        let encoded = try? JSONEncoder().encode(array)
        userDefault.set(encoded, forKey: key)
    }
    
    func load<T: Mappable>(object: T.Type) -> [T]? {
        let key = "Gist.\(String(describing: T.self))"
        guard let data = userDefault.data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode([T].self, from: data)
    }
}
