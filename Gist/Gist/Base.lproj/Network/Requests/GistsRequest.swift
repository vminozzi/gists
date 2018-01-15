//
//  GistsRequest.swift
//  Gist
//
//  Created by Vinicius on 13/01/18.
//  Copyright © 2017 Vinicius Minozzi. All rights reserved.
//

import Foundation

typealias Response = (gists: [Gist]?, limitError: ApiLimit?)

class GistRequest: Requestable {
    
    private var page: Int
    
    init(page: Int) {
        self.page = page
    }
    
    func request(completion: @escaping (Response?, CustomError?) -> Void) {
        var urlComponents = URLComponents(string: BaseAPI().gists)
        urlComponents?.queryItems = [URLQueryItem(name: "page", value: String(page))]
        
        guard let url = urlComponents?.url else {
            completion(nil, CustomError())
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            let result = data <--> (Result.self, error)
            let limit = data <--> (ApiLimit.self, error)
            
            completion(Response(gists: result.model?.gists, limitError: limit.model), result.error)
            }.resume()
    }
}
