//
//  HotelCell.swift
//  GCCompany
//
//  Created by 박승태 on 2022/03/06.
//

import UIKit

import Kingfisher

protocol HotelCellDelegate: AnyObject {
    
    func didSelectFavorite(hotel: Hotel, index: Int)
}

class HotelCell: UITableViewCell {
    
    static let identifier: String = "HotelCell"
    weak var hotelCellDelegate: HotelCellDelegate?
    
    func updateUI(hotel: Hotel, index: Int, isFavoirteList: Bool) {
                
        self.hotelImageView?.downloadImage(with: hotel.thumbnailImagePath)
        self.hotelNameLabel?.text = hotel.name
        self.hotelRateLabel?.text = "\(hotel.rate)"
        self.hotelPriceLabel?.text = "\(hotel.price.withComma)원"
        self.hotelDescriptionLabel?.text = isFavoirteList ?
                                           hotel.favoriteAddedTime?.convertToString() ?? "" :
                                           hotel.description
        
        self.hotelFavoriteButton?.setImage(hotel.isFavorited ?
                                           UIImage(systemName: "heart.fill") :
                                           UIImage(systemName: "heart"),
                                           for: .normal)
        self.hotelFavoriteButton?.tintColor = hotel.isFavorited ? .yellow : .white
        
        self.hotel = hotel
        self.index = index
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentRoundView?.layer.cornerRadius = 16
        
        self.hotelImageView?.layer.masksToBounds = true
        self.hotelImageView?.layer.cornerRadius = 16
        self.hotelImageView?.layer.cornerCurve = .continuous
        self.hotelImageView?.layer.maskedCorners = [.layerMinXMinYCorner,
                                                    .layerMaxXMinYCorner]
    }
    
    @IBAction private func didTapFavorite(_ sender: UIButton) {
    
        guard let hotel = self.hotel,
              let index = self.index else { return }
        
        self.hotelCellDelegate?.didSelectFavorite(hotel: hotel,
                                                  index: index)
    }
    
    private var hotel: Hotel?
    private var index: Int?
    
    @IBOutlet private weak var contentRoundView: UIView?
    
    @IBOutlet private weak var hotelImageView: UIImageView?
    @IBOutlet private weak var hotelFavoriteButton: UIButton?
    @IBOutlet private weak var hotelNameLabel: UILabel?
    @IBOutlet private weak var hotelRateLabel: UILabel?
    @IBOutlet private weak var hotelPriceLabel: UILabel?
    @IBOutlet private weak var hotelDescriptionLabel: UILabel?
}
