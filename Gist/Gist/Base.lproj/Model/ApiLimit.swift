//
//  ApiLimit.swift
//  Gist
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2017 Vinicius Minozzi. All rights reserved.
//

import Foundation

struct ApiLimit: Mappable {
    
    var message: String?
    
    init?(data: Data) {
        
    }
    
    static func ==(lhs: ApiLimit, rhs: ApiLimit) -> Bool {
        return lhs.message == rhs.message
    }
}
