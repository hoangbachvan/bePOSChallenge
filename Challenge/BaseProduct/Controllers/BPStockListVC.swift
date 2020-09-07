//
//  BPStockListVC.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RxSwift

class BPStockListVC: BaseVC {
    
    @IBOutlet var tableView: UITableView!
    
    let stockListVM = BPStockListVM()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.ControllerTitle.stockList
        tableView.registNibTableViewCell(of: BPStockTableViewCell.self)
        addObserver()
        subscribeRealmData()
        fetchListStock()
    }
    
    // MARK: - View Configuration
    func subscribeRealmData() {
        stockListVM.subscribeRealmData()
    }
    
    func addObserver() {
        stockListVM.publishedStockList.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView
                .rx
                .items(cellIdentifier: BPStockTableViewCell.identifier() , cellType: BPStockTableViewCell.self)) { index, model, cell in
                    cell.fillData(stock: model, indexPath: index)
                    cell.delegate = self
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (index) in
            self.tableView.deselectRow(at: index, animated: true)
            // navigate to detail
        }).disposed(by: disposeBag)
    }
    
    func fetchListStock() {
        stockListVM.fetchListStock()
    }
}

extension BPStockListVC: BPStockTableViewCellDelegate {
    func favoriteButtonPressed(index: Int) {
        stockListVM.onChangeFavoriteStatus(index: index)
    }
}
