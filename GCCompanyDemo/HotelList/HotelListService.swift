//
//  HotelListService.swift
//  GCCompany
//
//  Created by 박승태 on 2022/03/05.
//

import Foundation

import RxSwift
import RxCocoa
import SwiftyJSON

protocol HotelListServiceProtocol {
    
    var isLastestPage: Bool { get }
    
    func resetPage()
    func requestHotel() -> Observable<[Hotel]>
}

class HotelListServie: HotelListServiceProtocol {
    
    var isLastestPage: Bool = false
    
    func requestHotel() -> Observable<[Hotel]> {
        
        guard let url = URL(string: Server.base + Root.app + Root.json +
                                    "/\(self.page)" + EndPoint.json) else {
            
            return .error(APIError.failed(errCode: 0, message: ""))
        }
        
        let request = APIRequest(method: .get, url: url).create()
        
        return URLSession.shared.rx
                .response(request: request)
                .map { response, data -> [Hotel] in
                    
                    let json = JSON(data)
                    
                    self.printRequestInfo(url.description,
                                          .get,
                                          nil,
                                          json,
                                          response.statusCode)
                    
                    if 200...299 ~= response.statusCode {
                        
                        return self.createHotels(with: json)
                    }
                    
                    throw APIError.checkError(with: response.statusCode)
                }
    }
    
    func resetPage() {
        
        self.page = 1
        self.isLastestPage = false        
    }
    
    private func createHotels(with json: JSON) -> [Hotel] {
        
        var hotels: [Hotel] = [Hotel]()
        
        for (_, item) in json["data"]["product"].arrayValue.enumerated() {
            
            hotels.append(
                Hotel(
                    id: item["id"].intValue,
                    name: item["name"].stringValue,
                    rate: item["rate"].floatValue,
                    description: item["description"]["subject"].stringValue,
                    price: item["description"]["price"].intValue,
                    thumbnailImagePath: item["thumbnail"].stringValue,
                    originalImagePath: item["description"]["imagePath"].stringValue
                )
            )
        }
        
        if json["data"]["totalCount"].intValue > (20 * self.page) {
            
            self.page += 1            
        }
        else {
            
            self.isLastestPage = true
        }
        
        return hotels
    }
    
    private var page: Int = 1
}

extension HotelListServie {
    
    // MARK: -- Log
    
    private func printRequestInfo(_ url: String?,
                                  _ method: HTTPMethod,
                                  _ params: [String: Any]?,
                                  _ json: JSON,
                                  _ statusCode: Int) {
        
        var message: String = "\n\n"
        message += "/*————————————————-————————————————-————————————————-"
        message += "\n|                    HTTP REQUEST                    |"
        message += "\n—————————————————————————————————-————————————————---*/"
        message += "\n"
        message += "* METHOD : \(method.rawValue)"
        message += "\n"
        message += "* URL : \(url ?? "")"
        message += "\n"
        message += "* PARAM : \(params?.description ?? "")"
        message += "\n"
        message += "* STATUS CODE : \(statusCode)"
        message += "\n"
        message += "* RESPONSE : \n\(json)"
        message += "\n"
        message += "/*————————————————-————————————————-————————————————-"
        message += "\n|                    RESPONSE END                     |"
        message += "\n—————————————————————————————————-————————————————---*/"
        println(message)
    }
    
    // MARK: - Log
    private func println<T>(_ object: T,
                            _ file: String = #file,
                            _ function: String = #function, _ line: Int = #line){
#if DEBUG
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss:SSS"
        let process = ProcessInfo.processInfo
        
        var tid:UInt64 = 0;
        pthread_threadid_np(nil, &tid);
        let threadId = tid
        
        Swift.print("\(dateFormatter.string(from: NSDate() as Date)) \(process.processName))[\(process.processIdentifier):\(threadId)] \((file as NSString).lastPathComponent)(\(line)) \(function):\t\(object)")
#else
#endif
    }
}
