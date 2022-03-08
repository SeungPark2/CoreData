//
//  Network.swift
//  GCCompany
//
//  Created by 박승태 on 2022/03/05.
//

import Foundation

struct APIRequest {
    
    let method: HTTPMethod
    let url: URL
}

extension APIRequest {
    
    func create() -> URLRequest {
        
        var request = URLRequest(url: self.url)
        request.httpMethod = method.rawValue
        
        //request.allHTTPHeaderFields
        
        return request
    }
}
