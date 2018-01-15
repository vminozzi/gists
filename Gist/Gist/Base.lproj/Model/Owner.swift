//
//  Owner.swift
//  Gist
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2017 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct Owner: Mappable {
    
    var id = 0
    var login: String?
    var photo = ""
    
    init?(data: Data) {
        
    }
        
    fileprivate enum CodingKeys: String, CodingKey {
        case id
        case login
        case photo = "avatar_url"
    }
    
    static func == (lhs: Owner, rhs: Owner) -> Bool {
        return lhs.id == rhs.id && lhs.login == rhs.login && lhs.photo == rhs.photo
    }
}
