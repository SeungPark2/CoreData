//
//  HotelFavoriteManager.swift
//  GCCompanyDemo
//
//  Created by 박승태 on 2022/03/06.
//

import CoreData
import UIKit

class HotelFavoriteManager {
    
    static let shared: HotelFavoriteManager = HotelFavoriteManager()
    private init() { }
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "HotelData"
    
    func getHotels(ascending: Bool = false) -> [Hotel] {
        
        var models: [Hotel] = [Hotel]()
        
        if let context = context {
            
            let idSort: NSSortDescriptor = NSSortDescriptor(key: "favoriteAddedTime", ascending: ascending)
            let fetchRequest: NSFetchRequest<NSManagedObject>
            = NSFetchRequest<NSManagedObject>(entityName: modelName)
            fetchRequest.sortDescriptors = [idSort]
            
            do {
                
                if let fetchResult: [HotelData] = try context.fetch(fetchRequest) as? [HotelData] {
                    
                    for hotel in fetchResult {
                        
                        models.append(
                            Hotel(id: Int(hotel.id),
                                  name: hotel.name ?? "",
                                  rate: hotel.rate,
                                  description: hotel.subject ?? "",
                                  price: Int(hotel.price),
                                  thumbnailImagePath: hotel.thumbnailImagePath ?? "",
                                  originalImagePath: hotel.originalImagePath ?? "",
                                  isFavorited: hotel.isFavorited,
                                  favoriteAddedTime: hotel.favoriteAddedTime)
                        )
                    }
                }
                
            }
            catch let error as NSError {
                
                print("Could not fetch🥺: \(error), \(error.userInfo)")
            }
        }
        
        return models
    }
    
    func saveHotel(hotel: Hotel,
                   onSuccess: @escaping ((Bool) -> Void)) {
        
        if let context = context,
           let entity: NSEntityDescription
            = NSEntityDescription.entity(forEntityName: modelName, in: context) {
            
            if let hotelData: HotelData = NSManagedObject(entity: entity, insertInto: context) as? HotelData {
                
                let currentDate = Date()
                
                hotelData.id = Int64(hotel.id)
                hotelData.name = hotel.name
                hotelData.rate = hotel.rate
                hotelData.subject = hotel.description
                hotelData.price = Int64(hotel.price)
                hotelData.thumbnailImagePath = hotel.thumbnailImagePath
                hotelData.originalImagePath = hotel.originalImagePath
                hotelData.isFavorited = true
                hotelData.favoriteAddedTime = currentDate
                
                contextSave { success in
                    
                    if success {
                        
                        hotel.isFavorited = true
                        hotel.favoriteAddedTime = currentDate
                    }
                    
                    onSuccess(success)
                }
            }
        }
    }
    
    func deleteHotel(hotel: Hotel, onSuccess: @escaping ((Bool) -> Void)) {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: Int64(hotel.id))
        
        do {
            
            if let results: [HotelData] = try context?.fetch(fetchRequest) as? [HotelData] {
                
                if !results.isEmpty {
                    
                    context?.delete(results[0])
                }
            }
            
        }
        catch let error as NSError {
            
            print("Could not fatch🥺: \(error), \(error.userInfo)")
            onSuccess(false)
        }
        
        contextSave { success in
            
            if success {
                
                hotel.isFavorited = false
                hotel.favoriteAddedTime = nil
            }
            
            onSuccess(success)
        }
    }
    
//    func deleteAll() {
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
//        fetchRequest.returnsObjectsAsFaults = false
//        do {
//            let results = try context!.fetch(fetchRequest)
//            for object in results {
//                guard let objectData = object as? NSManagedObject else {continue}
//                context?.delete(objectData)
//            }
//        } catch let error {
//            print("Detele all data in error :", error)
//        }
//    }
}

extension HotelFavoriteManager {
    
    fileprivate func filteredRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        
        return fetchRequest
    }
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        
        do {
            
            try context?.save()
            onSuccess(true)
            
        }
        catch let error as NSError {
            
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
