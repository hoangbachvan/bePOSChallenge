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
    
    override func viewDidLoad() {
        self.title = Constants.ControllerTitle.favoriteStock
        super.viewDidLoad()
        tableView.registNibTableViewCell(of: BPStockTableViewCell.self)
        addObserver()
        loadRealmData()
        subscribeRealm()
    }
    
    func addObserver() {
        favoriteStockVM.publisedFavoriteStock.asObserver().bind(to: tableView.rx.items(cellIdentifier: BPStockTableViewCell.identifier(), cellType: BPStockTableViewCell.self)) { row, model, cell in
            print("UPDATE TABLE:\(model.price)")
            cell.fillData(stock: model, indexPath: row)
            cell.delegate = self
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (index) in
            self.tableView.deselectRow(at: index, animated: true)
            // navigate to detail
        }).disposed(by: disposeBag)
    }
    
    func subscribeRealm() {
        favoriteStockVM.subscribeRealmData()
    }
    
    func loadRealmData() {
        favoriteStockVM.loadRealmData()
    }
}

extension BPStockFavoriteVC: BPStockTableViewCellDelegate {
    func favoriteButtonPressed(index: Int) {
        favoriteStockVM.onChangeFavoriteStatus(index: index)
    }
}
