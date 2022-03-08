//
//  FavoriteHotelListVM.swift
//  GCCompanyDemo
//
//  Created by 박승태 on 2022/03/07.
//

import RxCocoa

protocol FavoriteHotelListVMProtocol {
    
    var errMsg: BehaviorRelay<String> { get }
    
    var updateIndex: BehaviorRelay<Int?> { get }
    
    var hotels: BehaviorRelay<[Hotel]> { get }
    var isEmptyHotel: BehaviorRelay<Bool> { get }
    
    func updateFavoriteHotelList(ascending: Bool)
    
    func addFavoriteHotel(hotel: Hotel, index: Int)
    func removeFavoriteHotel(hotel: Hotel, index: Int)
}

class FavoriteHotelListVM: FavoriteHotelListVMProtocol {
    
    var errMsg = BehaviorRelay<String>(value: "")
    
    var updateIndex = BehaviorRelay<Int?>(value: nil)
    
    var hotels   = BehaviorRelay<[Hotel]>(value: [])
    var isEmptyHotel = BehaviorRelay<Bool>(value: false)
    
    func updateFavoriteHotelList(ascending: Bool = false) {
        
        self.hotels.accept(HotelFavoriteManager.shared.getHotels(ascending: ascending))
        self.isEmptyHotel.accept(self.hotels.value.isEmpty)
    }
    
    func addFavoriteHotel(hotel: Hotel, index: Int) {
        
        HotelFavoriteManager.shared.saveHotel(hotel: hotel) {
            
            [weak self] isSucceed in
            
            if !isSucceed {
                             
                self?.errMsg.accept(ErrorMessage.failedAddFavorite)
                return
            }
            
            self?.updateIndex.accept(index)
        }
    }
    
    func removeFavoriteHotel(hotel: Hotel, index: Int) {
        
        HotelFavoriteManager.shared.deleteHotel(hotel: hotel) {
            
            [weak self] isSucceed in
            
            if !isSucceed {
                             
                self?.errMsg.accept(ErrorMessage.failedRemoveFavorite)
                return
            }
            
            self?.updateIndex.accept(index)
        }
    }
}
