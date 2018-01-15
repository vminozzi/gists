//
//  Result.swift
//  Gist
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2017 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct Result: Mappable {
    
    var gists = [Gist]()
    
    init?(data: Data) {
        guard let gistsEncoded = try? JSONDecoder().decode([Gist].self, from: data) else {
            return nil
        }
        gists = gistsEncoded
    }
    
    static func ==(lhs: Result, rhs: Result) -> Bool {
        return lhs.gists == rhs.gists
    }
}
