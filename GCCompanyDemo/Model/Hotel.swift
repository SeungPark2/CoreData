//
//  Hotel.swift
//  GCCompany
//
//  Created by 박승태 on 2022/03/05.
//

import Foundation

class Hotel {
    
    let id: Int
    let name: String
    
    let rate: Float
    let description: String
    let price: Int
    
    let thumbnailImagePath: String
    let originalImagePath: String
    
    var isFavorited: Bool = false
    var favoriteAddedTime: Date?
    
    init(id: Int,
         name: String,
         rate: Float,
         description: String,
         price: Int,
         thumbnailImagePath: String,
         originalImagePath: String) {
        
        self.id = id
        self.name = name
        self.rate = rate
        self.description = description
        self.price = price
        self.thumbnailImagePath = thumbnailImagePath
        self.originalImagePath = originalImagePath
    }
    
    init(id: Int,
         name: String,
         rate: Float,
         description: String,
         price: Int,
         thumbnailImagePath: String,
         originalImagePath: String,
         isFavorited: Bool,
         favoriteAddedTime: Date?) {
        
        self.id = id
        self.name = name
        self.rate = rate
        self.description = description
        self.price = price
        self.thumbnailImagePath = thumbnailImagePath
        self.originalImagePath = originalImagePath
        self.isFavorited = isFavorited
        self.favoriteAddedTime = favoriteAddedTime
    }
}

//struct HotelDescription: Codable {
//    
//    let originalImagePath: 
//}
