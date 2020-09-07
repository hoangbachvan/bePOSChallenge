//
//  BPStockDetailVC.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Charts

class BPStockDetailVC: BaseVC {
    var stockDetailVM = BPStockDetailVM()
    var tableHeaderView = BPStockDetailHeaderView()
    var tableFooterView = BPStockDetailFooterView()
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String(format: Constants.ControllerTitle.stockDetail, stockDetailVM.stockSymbol)
        tableView.registNibTableViewCell(of: BPProfileTableViewCell.self)
        configTableHeaderView()
        configTableFooterView()
        addObserver()
        fetchStockProfile()
        subscribeRealmData()
        fetchHistoricalPrice(index: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stockDetailVM.fetchRealTimePrice()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stockDetailVM.invalidateTimer()
    }
    
    // MARK: - View model Configuration
    func addObserver() {
        stockDetailVM.publishedTupleProfile.bind(to: tableView.rx.items(cellIdentifier: BPProfileTableViewCell.identifier(), cellType: BPProfileTableViewCell.self)) { row, model, cell in
            cell.fillData(tuple: model)
        }.disposed(by: disposeBag)
        
        stockDetailVM.publishedProfile.asObserver().subscribe(onNext: { (stock) in
            self.tableHeaderView.setupInfoView(stock: stock)
        }).disposed(by: disposeBag)
        
        stockDetailVM.publishedChartDataSets.asObserver().subscribe(onNext: { (dataSets) in
            self.tableHeaderView.setupChartData(dataSet: dataSets.0, listDate: dataSets.1)
        }).disposed(by: disposeBag)
        
        stockDetailVM.publishedDescription.asObserver().subscribe(onNext: { (descriptionData) in
            self.tableFooterView.setupInfoView(profile: descriptionData)
        }).disposed(by: disposeBag)
        
        stockDetailVM.errorHandle.asObserver().subscribe(onNext: { (message) in
            self.showErrorAlert(message: message)
        }).disposed(by: disposeBag)
        
    }
    
    func fetchStockProfile() {
        stockDetailVM.fetchStockProfile()
    }
    
    func subscribeRealmData() {
        stockDetailVM.subscribeRealmData()
    }
    
    func fetchHistoricalPrice(index: Int) {
        stockDetailVM.fetchHistoricalData(index: index)
    }
    
    // MARK: - View Config
    func configTableHeaderView() {
        tableHeaderView = BPStockDetailHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: BPStockDetailHeaderView.getViewHeight()))
        tableHeaderView.delegate = self
        tableView.tableHeaderView = tableHeaderView
    }
    
    func configTableFooterView(height: CGFloat = 500) {
    }
}

// MARK: - BPStockDetailHeaderViewDelegate
extension BPStockDetailVC: BPStockDetailHeaderViewDelegate {
    func changeFavoriteStatus(isFavortie: Bool) {
        stockDetailVM.onChangeFavoriteStatus(isFavorite: isFavortie)
    }
    
    func changeSegmentValue(index: Int) {
        fetchHistoricalPrice(index: index)
    }
}
