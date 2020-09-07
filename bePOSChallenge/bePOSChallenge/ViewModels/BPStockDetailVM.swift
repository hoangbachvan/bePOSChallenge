//
//  BPStockDetailVM.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON

enum PreviousMonth: Int {
    case months3 = 3
    case months6 = 6
    case year = 12
    case years3 = 36
    
    static let allValues: [PreviousMonth] = [.months3, .months6, .year, .years3]
}

class BPStockDetailVM: BaseViewModel {
    var stockSymbol: String = ""
    var stock: BPStock?
    var realTimeTimer = Timer()
    var publishedProfile = PublishSubject<BPStock>()
    
    var publishedTupleProfile = PublishSubject<[TupleProfileData]>()
    var errorHandle = PublishSubject<String>()
    
    var publishedChartDataSets = PublishSubject<([BPHistoryStock], [Date])>()
    var originalChartDataSets = [Int : [BPHistoryStock]]()
    
    var publishedDescription = PublishSubject<TupleProfileData>()
    
    private var currentSegmentIndex = -1
    
    // MARK: - Get stock profile
    func fetchStockProfile() {
        if let stock = stock,
            let stockProfile = stock.profile {
            publishedTupleProfile.onNext(stockProfile.datas)
            if let descriptionData = stockProfile.descriptionData {
                publishedDescription.onNext(descriptionData)
            }
            publishedProfile.onNext(stock)
        } else {
            BPService()
                .fetchStockProfile(symbol: stockSymbol)
                .asObservable()
                .subscribe(onNext: { [weak self] (response) in
                    guard let self = self else { return }
                    switch (response) {
                    case .success(let json):
                        self.onGetProfileAPISuccess(json: json)
                    case .failure(let apiError):
                        self.onGetProfileAPIError(apiError: apiError)
                    }
                    }, onError:  { [weak self] error in
                        guard let self = self else { return }
                        self.onGetProfileServerError(apiError: error)
                }).disposed(by: disposeBag)
        }
    }
    
    func onGetProfileAPISuccess(json: JSON) {
        if let arrayData = json.array,
            let profileJSON = arrayData.first {
            let stockProfile = BPStockProfile(json: profileJSON)
            if let currentStock = stock {
                stock?.profile = stockProfile
                publishedProfile.onNext(currentStock)
            }
        }
    }
    
    func onGetProfileAPIError(apiError: ServerError) {
        errorHandle.onNext(apiError.message)
    }
    
    func onGetProfileServerError(apiError: Error) {
        errorHandle.onNext(apiError.localizedDescription)
    }
    
    // MARK: - Get historical data
    func fetchHistoricalData(index: Int) {
        currentSegmentIndex = index
        if let currentDataSet = originalChartDataSets[index] {
            publishedChartDataSets.onNext((currentDataSet, currentDataSet.map{ $0.date.toDate() }.reversed()))
        } else {
            let previousMonths = Date().getPreviousMonth(month: -PreviousMonth.allValues[index].rawValue)
            BPService().fetchStockHistory(symbol: stockSymbol, from: previousMonths.toString(), to: Date().toString()).subscribe(onNext: { [weak self] (response) in
                guard let weakSelf = self else { return }
                switch (response) {
                case .success(let json):
                    weakSelf.onGetHistoricalAPISuccess(json: json, index: index)
                case .failure(let apiError):
                    weakSelf.onGetStockHistoricalError(apiError: apiError)
                }
                }, onError: { error in
                    
            }).disposed(by: disposeBag)
        }
    }
    
    func onGetHistoricalAPISuccess(json: JSON, index: Int) {
        if let arrayData = json["historical"].array {
            let dataSet = arrayData.map({ BPHistoryStock(json: $0) })
            originalChartDataSets[index] = dataSet
            if (currentSegmentIndex == index) {
                publishedChartDataSets.onNext((dataSet, dataSet.map({ $0.date.toDate() }).reversed()))
            }
        }
    }
    
    func onGetStockHistoricalError(apiError: ServerError) {
        errorHandle.onNext(apiError.message)
    }
    
    private func onGetStockHistoricalError(apiError: Error) {
        errorHandle.onNext(apiError.localizedDescription)
    }
    
    // MARK: - Get realtime price data
    func invalidateTimer() {
        if (realTimeTimer.isValid) {
            realTimeTimer.invalidate()
        }
    }
    
    func fetchRealTimePrice() {
        realTimeTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { (_) in
            if let stock = self.stock {
                BPService().fetchStockRealTime(symbol: stock.symbol)
                    .asObservable()
                    .subscribe(onNext: { [weak self] (response) in
                        guard let self = self else { return }
                        switch (response) {
                        case .success(let json):
                            self.onGetPriceAPISuccess(json: json)
                        case .failure(let apiError):
                            self.onGetPriceAPIError(apiError: apiError)
                        }
                        }, onError: {[weak self] error in
                            guard let self = self else { return }
                            self.onGetPriceServerError(apiError: error)
                    }).disposed(by: self.disposeBag)
            }
        }
    }
    
    private func onGetPriceAPISuccess(json: JSON) {
        if let arrayPrice = json.array {
            for i in 0..<arrayPrice.count {
                let currentJson = arrayPrice[i]
                let symbol = currentJson["symbol"].stringValue
                let price = currentJson["price"].stringValue
                BPRealmWrapper.instance.updateStockProfilePrice(symbol: symbol, price: price)
                BPRealmWrapper.instance.updateStockPrice(symbol: symbol, price: price)
            }
        }
    }
    
    private func onGetPriceAPIError(apiError: ServerError) {
//        errorHandle.onNext(apiError.message)
    }
    
    private func onGetPriceServerError(apiError: Error) {
//        errorHandle.onNext(apiError.localizedDescription)
    }
    
    // MARK: - Realm
    func subscribeRealmData() {
        BPRealmWrapper.instance.publishedUpdateInfo.subscribe(onNext: { [weak self] (isFavorite, symbol) in
            guard let self = self else { return }
            self.stock?.isFavorite = isFavorite
            guard let stock = self.stock else { return }
            self.publishedProfile.onNext(stock)
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Change favorite status
    func onChangeFavoriteStatus(isFavorite: Bool) {
        if let stock = stock {
            if (isFavorite) {
                BPRealmWrapper.instance.addStock(stock: stock)
            } else {
                BPRealmWrapper.instance.removeStock(stock: stock)
            }
        }
    }
}
