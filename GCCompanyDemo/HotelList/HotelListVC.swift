//
//  HotelListVC.swift
//  GCCompany
//
//  Created by 박승태 on 2022/03/05.
//

import UIKit

import RxSwift

class HotelListVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNaviAndTabbar()
        
        self.bindState(with: self.viewModel)
        self.bindAction(with: self.viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.updateHotelList()
    }
    
    private func setNaviAndTabbar() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                                    for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .black
        
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.shadowImage = UIImage()
    }
    
    private func bindState(with viewModel: HotelListVMProtocol) {
        
        viewModel.isLoaded
            .bind { [weak self] in
                
                $0 ? self?.loadingIndicatorView?.stopAnimating() :
                     self?.loadingIndicatorView?.startAnimating()
                
                self?.loadingIndicatorView?.isHidden = $0
                
                if $0 {
                    
                    self?.hotelTableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            }
            .disposed(by: self.disposeBag)
        
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
                              isFavoirteList: false)
                cell.hotelCellDelegate = self
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindAction(with viewModel: HotelListVMProtocol) {
        
        self.hotelTableView.addSubview(self.refreshControl)
        
        self.hotelTableView.rx.itemSelected
            .map { $0.row }
            .bind { [weak self] in
                
                
            }
            .disposed(by: self.disposeBag)
        
        self.hotelTableView.rx.contentOffset
            .filter { [weak self] offset in
                
                guard let `self` = self else { return false }
                guard self.hotelTableView.isDragging else { return false }
                
                return offset.y + self.hotelTableView.frame.height >=
                       self.hotelTableView.contentSize.height + 50
            }
            .bind { _ in viewModel.requestHotelList() }
            .disposed(by: self.disposeBag)
        
        self.hotelTableView.rx.willEndDragging
            .map { $0.velocity.y }
            .filter { $0 != 0 }
            .bind { [weak self] in
                
//                self?.navigationController?.setNavigationBarHidden(
//                    $0 > 0,
//                    animated: true
//                )
                
                self?.tabBarController?.setTabBarHidden(
                    $0 > 0,
                    animated: true
                )
            }
            .disposed(by: self.disposeBag)
        
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
    }
    
    @objc
    func resetHotels() {
        
        self.viewModel.resetHotelList()
        self.loadingIndicatorView?.isHidden = true
    }
    
    private let viewModel: HotelListVMProtocol = HotelListVM(hotelListService: HotelListServie())
    private let disposeBag = DisposeBag()
    private lazy var refreshControl: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(self.resetHotels),
                                 for: .valueChanged)
        
        return refreshControl
    }()
    
    @IBOutlet private var hotelTableView: UITableView!
    
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView?
}

extension HotelListVC: HotelCellDelegate {
    
    func didSelectFavorite(hotel: Hotel, index: Int) {
        
        hotel.isFavorited ? self.viewModel.removeFavoriteHotel(hotel: hotel, index: index) :
                            self.viewModel.addFavoriteHotel(hotel: hotel, index: index)
    }
}
