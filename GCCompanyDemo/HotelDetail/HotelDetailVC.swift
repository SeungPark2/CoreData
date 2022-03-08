//
//  HotelDetailVC.swift
//  GCCompanyDemo
//
//  Created by 박승태 on 2022/03/08.
//

import UIKit

import RxSwift

class HotelDetailVC: UIViewController {
    
    var hotel: Hotel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
        
        self.bindAction(with: self.viewModel)
        self.bindState(with: self.viewModel)
    }
    
    private func updateUI() {                
        
        guard let hotel = hotel else {
            
            return
        }

        self.hotelImageView?.downloadImage(with: hotel.originalImagePath)
        self.updateFavoriteButton()
        self.hotelNameLabel?.text = hotel.name
        self.hotelRateLabel?.text = "\(hotel.rate)"
        self.hotelPriceLabel?.text = "\(hotel.price.withComma)원"
        self.updateFavoriteTimeLabel()
        self.hotelDescriptionLabel?.text = hotel.description
    }
    
    private func updateFavoriteButton() {
        
        self.hotelFavoriteButton?.setImage(
            (self.hotel?.isFavorited ?? false) ?
            UIImage(systemName: "heart.fill") :
            UIImage(systemName: "heart"),
            for: .normal
        )
        
        self.hotelFavoriteButton?.tintColor = (self.hotel?.isFavorited ?? false) ?
                                              .yellow : .black
    }
    
    private func updateFavoriteTimeLabel() {
        
        self.hotelFavoriteTimeLabel?.text = self.hotel?.favoriteAddedTime == nil ?
                                            nil :
                                            self.hotel?.favoriteAddedTime?.convertToString() ?? ""
    }
    
    private func bindState(with viewModel: HotelDetailVMProtocol) {
        
        viewModel.errMsg
            .filter { $0 != "" }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                
                self?.showAlert(with: $0)
            }
            .disposed(by: self.disposeBag)
        
        viewModel.isUpdatedFavorite
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                
                self?.updateFavoriteButton()
                self?.updateFavoriteTimeLabel()
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindAction(with viewModel: HotelDetailVMProtocol) {
        
        self.hotelFavoriteButton?.rx.tap
            .bind { [weak self] in
                
                guard let `self` = self,
                      let hotel = self.hotel else { return }
                
                hotel.isFavorited ? viewModel.removeFavoriteHotel(hotel: hotel) :
                                    viewModel.addFavoriteHotel(hotel: hotel)
            }
            .disposed(by: self.disposeBag)
    }
    
    private let viewModel: HotelDetailVMProtocol = HotelDetailVM()
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var hotelImageView: UIImageView?
    @IBOutlet private weak var hotelFavoriteButton: UIButton?
    @IBOutlet private weak var hotelNameLabel: UILabel?
    @IBOutlet private weak var hotelRateLabel: UILabel?
    @IBOutlet private weak var hotelPriceLabel: UILabel?
    @IBOutlet private weak var hotelFavoriteTimeLabel: UILabel?
    @IBOutlet private weak var hotelDescriptionLabel: UILabel?
}
