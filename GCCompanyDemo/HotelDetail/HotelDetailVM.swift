//
//  HotelDetailVM.swift
//  GCCompanyDemo
//
//  Created by 박승태 on 2022/03/08.
//

import RxCocoa

protocol HotelDetailVMProtocol {
    
    var errMsg: BehaviorRelay<String> { get }
    var isUpdatedFavorite: BehaviorRelay<Bool> { get }
    
    func addFavoriteHotel(hotel: Hotel)
    func removeFavoriteHotel(hotel: Hotel)
}

class HotelDetailVM: HotelDetailVMProtocol {
    
    var errMsg = BehaviorRelay<String>(value: "")
    var isUpdatedFavorite = BehaviorRelay<Bool>(value: false)
    
    func addFavoriteHotel(hotel: Hotel) {
        
        HotelFavoriteManager.shared.saveHotel(hotel: hotel) {
            
            [weak self] isSucceed in
            
            if !isSucceed {
                             
                self?.errMsg.accept(ErrorMessage.failedAddFavorite)
                return
            }
            
            self?.isUpdatedFavorite.accept(true)
        }
    }
    
    func removeFavoriteHotel(hotel: Hotel) {
        
        HotelFavoriteManager.shared.deleteHotel(hotel: hotel) {
            
            [weak self] isSucceed in
            
            if !isSucceed {
                             
                self?.errMsg.accept(ErrorMessage.failedRemoveFavorite)
                return
            }
            
            self?.isUpdatedFavorite.accept(true)
        }
    }
}
