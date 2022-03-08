//
//  APIError.swift
//  GCCompany
//
//  Created by 박승태 on 2022/03/06.
//

import Foundation

enum APIError: Error {
    
    case failed(errCode: Int, message: String)
    case serverNotConnected
}

extension APIError {
    
    var descripton: String {
        
        switch self {
            
            case .failed(_, _):
            
                return ErrorMessage.defaultAPIFailed
                
            case .serverNotConnected:
            
                return ErrorMessage.defaultAPIServer
        }
    }
    
    static func checkError(with statusCode: Int) -> APIError {
        
        if 500...599 ~= statusCode {
            
            return .serverNotConnected
        }
        
//        if statusCode == 401 {
//            
//            return
//        }
        
        return .failed(errCode: statusCode,
                       message: "")
    }
}
