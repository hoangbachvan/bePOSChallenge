//
//  BPStockListVC.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RxSwift
import JGProgressHUD

class BPStockListVC: BaseVC {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var retryBtn: UIButton!
    
    let stockListVM = BPStockListVM()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.ControllerTitle.stockList
        tableView.keyboardDismissMode = .onDrag
        tableView.registNibTableViewCell(of: BPStockTableViewCell.self)
        addObserver()
        subscribeRealmData()
        fetchListStock()
        
    }
    
    override func appearanceConfig() {
        super.appearanceConfig()
        retryBtn.backgroundColor = ThemeWrapper.instance.currentTheme.buttonColor
    }
    // MARK: - View model Configuration
    func subscribeRealmData() {
        stockListVM.subscribeRealmData()
    }
    
    func addObserver() {
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = "Loading"
        
        stockListVM.isLoading.observeOn(MainScheduler.instance).asObservable().subscribe(onNext: { (isLoading) in
            if (isLoading) {
                hud.show(in: self.view)
            } else {
                hud.dismiss()
            }
        }).disposed(by: disposeBag)
        
        stockListVM.publishedStockList
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView
                .rx
                .items(cellIdentifier: BPStockTableViewCell.identifier() , cellType: BPStockTableViewCell.self)) { index, model, cell in
                    cell.fillData(stock: model, indexPath: index)
                    cell.delegate = self
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (index) in
            self.searchTxtField.resignFirstResponder()
            self.tableView.deselectRow(at: index, animated: true)
            self.navigateToDetailVC(index: index.row)
        }).disposed(by: disposeBag)
        
        stockListVM.errorHandle.asObservable().subscribe(onNext: { (message) in
            self.showErrorAlert(message: message)
            self.retryBtn.isHidden = false
        }).disposed(by: disposeBag)
        
        searchTxtField.rx.text
            .orEmpty
            .observeOn(MainScheduler.instance)
            .bind(to: stockListVM.searchText)
            .disposed(by: disposeBag)
        
        searchTxtField.rx.controlEvent([.editingChanged]).observeOn(MainScheduler.instance).subscribe(onNext: { () in
            self.stockListVM.onSearchData()
        }).disposed(by: disposeBag)
    }
    
    func fetchListStock() {
        stockListVM.fetchListStock()
    }
    
    // MARK: - Navigate
    func navigateToDetailVC(index: Int) {
        let detailVC = instantiateViewController(of: BPStockDetailVC.self, storyboard: .stock)
        let detailStockVM = BPStockDetailVM()
        let currentStock = stockListVM.originalStockList[index]
        detailStockVM.stockSymbol = currentStock.symbol
        detailStockVM.stock = currentStock
        detailVC.stockDetailVM = detailStockVM
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func filterSementValueChange(_ sender: Any) {
    }
    
    @IBAction func retryBtnPressed(_ sender: Any) {
        fetchListStock()
        self.retryBtn.isHidden = true
    }
}

// MARK: - BPStockTableViewCellDelegate
extension BPStockListVC: BPStockTableViewCellDelegate {
    func favoriteButtonPressed(index: Int, isFavorite: Bool) {
        stockListVM.onChangeFavoriteStatus(index: index, isFavorite: isFavorite)
    }
}

extension BPStockListVC: UITextFieldDelegate {
    
}
