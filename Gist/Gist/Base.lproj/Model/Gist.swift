//
//  Gist.swift
//  Gist
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2017 Vinicius Minozzi. All rights reserved.
//

import Foundation

protocol Mappable: Codable, Equatable {
    init?(data: Data)
}

struct Gist: Mappable {
    
    var id = ""
    var owner: Owner?
    var files: FileMinozzi?
    
    init?(data: Data) {
        
    }
    
    static func == (lhs: Gist, rhs: Gist) -> Bool {
        return lhs.id == rhs.id && lhs.owner == rhs.owner && lhs.files == rhs.files
    }
}
