//
//  BPStockFavoriteVC.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
//class BPFavoriteStockVC: BaseVC {

class BPStockFavoriteVC: BaseVC {
    let favoriteStockVM = BPStockFavoriteVM()
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        self.title = Constants.ControllerTitle.favoriteStock
        super.viewDidLoad()
        tableView.registNibTableViewCell(of: BPStockTableViewCell.self)
        addObserver()
        loadRealmData()
        subscribeRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteStockVM.fetchRealTimePrice()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        favoriteStockVM.invalidateTimer()
    }
    
    // MARK: - View model Configuration
    func addObserver() {
        favoriteStockVM.publisedFavoriteStock.asObserver().bind(to: tableView.rx.items(cellIdentifier: BPStockTableViewCell.identifier(), cellType: BPStockTableViewCell.self)) { row, model, cell in
            print("UPDATE TABLE:\(model.price)")
            cell.fillData(stock: model, indexPath: row, isFromFavoriteVC: true)
            cell.delegate = self
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (index) in
            self.tableView.deselectRow(at: index, animated: true)
            self.navigateToDetailVC(index: index.row)
        }).disposed(by: disposeBag)
        
        favoriteStockVM.errorHandle.asObservable().subscribe(onNext: { (message) in
           self.showErrorAlert(message: message)
        }).disposed(by: disposeBag)
    }
    
    func subscribeRealm() {
        favoriteStockVM.subscribeRealmData()
    }
    
    func loadRealmData() {
        favoriteStockVM.loadRealmData()
    }
    
    // MARK: - Navigate
    func navigateToDetailVC(index: Int) {
        let detailVC = instantiateViewController(of: BPStockDetailVC.self, storyboard: .stock)
        let detailStockVM = BPStockDetailVM()
        let currentStock = favoriteStockVM.originalFavoriteStock[index]
        detailStockVM.stockSymbol = currentStock.symbol
        detailStockVM.stock = currentStock
        detailVC.stockDetailVM = detailStockVM
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - BPStockTableViewCellDelegate
extension BPStockFavoriteVC: BPStockTableViewCellDelegate {
    func favoriteButtonPressed(index: Int, isFavorite: Bool) {
        favoriteStockVM.onChangeFavoriteStatus(index: index, isFavorite: isFavorite)
    }
}
