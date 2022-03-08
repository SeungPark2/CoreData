//
//  HotelListVM.swift
//  GCCompany
//
//  Created by 박승태 on 2022/03/05.
//

import RxSwift
import RxCocoa

protocol HotelListVMProtocol {
    
    var isLoaded: BehaviorRelay<Bool> { get }
    var errMsg: BehaviorRelay<String> { get }
    
    var updateIndex: BehaviorRelay<Int?> { get }
    
    var hotels: BehaviorRelay<[Hotel]> { get }
    
    func resetHotelList()
    func updateHotelList()
    func requestHotelList()
    
    func addFavoriteHotel(hotel: Hotel, index: Int)
    func removeFavoriteHotel(hotel: Hotel, index: Int)
}

class HotelListVM: HotelListVMProtocol {
    
    init(hotelListService: HotelListServiceProtocol) {
        
        self.hotelListService = hotelListService
        
        self.requestHotelList()
    }
    
    var isLoaded = BehaviorRelay<Bool>(value: true)
    var errMsg   = BehaviorRelay<String>(value: "")
    
    var updateIndex = BehaviorRelay<Int?>(value: nil)
    
    var hotels   = BehaviorRelay<[Hotel]>(value: [])
    
    func resetHotelList() {
        
        self.hotelListService.resetPage()
        self.isLoaded.accept(true)
        self.requestHotelList()
        self.hotels.accept([])
    }
    
    func updateHotelList() {
        
        let hotelList = self.hotels.value
        
        for hotel in hotelList {
            
            if HotelFavoriteManager.shared.getHotels()
                .firstIndex(where: { $0.id == hotel.id }) != nil {
                
                hotel.isFavorited = true
            }
            else {
                
                hotel.isFavorited = false
            }
        }
        
        self.hotels.accept(hotelList)
    }
    
    func requestHotelList() {
        
        guard self.isLoaded.value,
              !self.hotelListService.isLastestPage else { return }
        
        self.isLoaded.accept(false)
        
        self.hotelListService.requestHotel()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] hotelList in
                    
                    for i in 0..<hotelList.count {
                        
                        if HotelFavoriteManager.shared.getHotels()
                            .firstIndex(where: { $0.id == hotelList[i].id }) != nil {
                            
                            hotelList[i].isFavorited = true
                        }
                    }
                    
                    self?.hotels.accept((self?.hotels.value ?? []) + hotelList)
                    self?.isLoaded.accept(true)
            },
                onError: { [weak self] in
                    
                    self?.errMsg.accept(
                        ($0 as? APIError)?.descripton ?? ""
                    )
                    self?.isLoaded.accept(true)
                }
            )
            .disposed(by: self.disposeBag)
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
    
    private let hotelListService: HotelListServiceProtocol
    private let disposeBag = DisposeBag()
}
