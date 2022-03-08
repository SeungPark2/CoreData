//
//  HotelData+CoreDataProperties.swift
//  
//
//  Created by 박승태 on 2022/03/06.
//
//

import Foundation
import CoreData


extension HotelData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HotelData> {
        return NSFetchRequest<HotelData>(entityName: "HotelData")
    }

    @NSManaged public var favoriteAddedTime: Date?
    @NSManaged public var isFavorited: Bool
    @NSManaged public var originalImagePath: String?
    @NSManaged public var thumbnailImagePath: String?
    @NSManaged public var subject: String?
    @NSManaged public var price: Int64
    @NSManaged public var rate: Float
    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}
