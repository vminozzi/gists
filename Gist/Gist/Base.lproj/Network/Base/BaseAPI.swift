//
//  BaseAPI.swift
//  Gist
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2017 Vinicius Minozzi. All rights reserved.
//

import Foundation

protocol Requestable: class {
    associatedtype DataType
    func request(completion: @escaping (_ result: DataType?, _ error: CustomError?) -> Void)
}

struct BaseAPI {
    private var base = "https://api.github.com/"
    
    var gists: String {
        return base + "gists/public"
    }
}

precedencegroup ExponentiativePrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator <--> :ExponentiativePrecedence

func <--> <T: Mappable>(data: Data?, handle: (type: T.Type, error: Error?)) -> (model: T?, error: CustomError?) {
    
    if let error = handle.error {
        return (nil, CustomError(error: error))
    }
    
    guard let data = data else {
        return (nil, CustomError(error: handle.error))
    }
    
    guard let model = T(data: data) else {
        return (nil, CustomError())
    }
    
    return (model, nil)
}
