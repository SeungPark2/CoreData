//
//  FavoriteHotelListVC.swift
//  GCCompanyDemo
//
//  Created by 박승태 on 2022/03/07.
//

import UIKit

import RxSwift

class FavoriteHotelListVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNaviAndTabbar()
        
        self.bindState(with: self.viewModel)
        self.bindAction(with: self.viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.updateFavoriteHotelList(ascending: false)
    }
    
    private func setNaviAndTabbar() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                                    for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.shadowImage = UIImage()
    }
    
    private func bindState(with viewModel: FavoriteHotelListVMProtocol) {
        
        viewModel.errMsg
            .filter { $0 != "" }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                
                self?.showAlert(with: $0)
            }
            .disposed(by: self.disposeBag)
        
        viewModel.updateIndex
            .filter { $0 != nil }
            .map { $0! }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                
                self?.hotelTableView.reloadRows(
                    at: [IndexPath(item: $0,
                                   section: 0)],
                    with: .none)
            }
            .disposed(by: self.disposeBag)
        
        viewModel.hotels
            .bind(to: self.hotelTableView.rx.items(
                        cellIdentifier: HotelCell.identifier,
                        cellType: HotelCell.self)
            ) {
                
                index, hotel, cell in
                
                cell.updateUI(hotel: hotel,
                              index: index,
                              isFavoirteList: true)
                cell.hotelCellDelegate = self
            }
            .disposed(by: self.disposeBag)
        
        viewModel.isEmptyHotel
            .bind { [weak self] in
                
                self?.hotelEmptyLabel?.isHidden = !$0
                
                self?.navigationItem.rightBarButtonItem = $0 ? nil : self?.sortButton
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindAction(with viewModel: FavoriteHotelListVMProtocol) {
        
        self.hotelTableView.rx.itemSelected
            .map { $0.row }
            .bind { [weak self] in
                
                if let hotelDetailVC = self?.storyboard?.instantiateViewController(withIdentifier: "HotelDetailVC") as? HotelDetailVC {
                    
                    hotelDetailVC.hotel = viewModel.hotels.value[$0]
                    
                    self?.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(hotelDetailVC,
                                                                   animated: true)
                    
                    self?.hidesBottomBarWhenPushed = false
                }
            }
            .disposed(by: self.disposeBag)
        
        self.hotelTableView.rx.willEndDragging
            .map { $0.velocity.y }
            .filter { $0 != 0 && !self.viewModel.hotels.value.isEmpty }
            .bind { [weak self] in
                
                self?.tabBarController?.setTabBarHidden(
                    $0 > 0,
                    animated: true
                )
            }
            .disposed(by: self.disposeBag)
    }
    
    @objc
    private func didTapFilter() {
        
        self.showListSortActionSheet()
    }
    
    private func showListSortActionSheet() {
        
        let alertController = UIAlertController(title: nil,
                                                message: "정렬",
                                                preferredStyle: .actionSheet)
        
        let ascendingAction = UIAlertAction(title: "오름차순",
                                            style: .default,
                                            handler: { _ in
            
            self.viewModel.updateFavoriteHotelList(ascending: true)
        })
        
        let descendingAction = UIAlertAction(title: "내림차순",
                                             style: .default,
                                             handler: { _ in
            
            self.viewModel.updateFavoriteHotelList(ascending: false)
        })
        
        let closeAction = UIAlertAction(title: "닫기",
                                        style: .cancel,
                                        handler: nil)
        
        alertController.addAction(ascendingAction)
        alertController.addAction(descendingAction)
        alertController.addAction(closeAction)
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
    
    private let viewModel: FavoriteHotelListVMProtocol = FavoriteHotelListVM()
    private let disposeBag = DisposeBag()
    private lazy var sortButton: UIBarButtonItem = {
       
        let button = UIBarButtonItem(image: UIImage(named: "filter"),
                                     style: .done,
                                     target: self,
                                     action: #selector(self.didTapFilter))
        button.tintColor = .black
        
        return button
    }()
    
    @IBOutlet private var hotelTableView: UITableView!
    @IBOutlet private weak var hotelEmptyLabel: UILabel?
}

extension FavoriteHotelListVC: HotelCellDelegate {
    
    func didSelectFavorite(hotel: Hotel, index: Int) {
        
        hotel.isFavorited ? self.viewModel.removeFavoriteHotel(hotel: hotel, index: index) :
                            self.viewModel.addFavoriteHotel(hotel: hotel, index: index)
    }
}
