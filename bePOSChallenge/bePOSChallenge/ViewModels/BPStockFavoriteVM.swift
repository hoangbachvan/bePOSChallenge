//
//  BPStockFavoriteVM.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import RealmSwift

class BPStockFavoriteVM: BaseViewModel {
    var realTimeTimer = Timer()
    var publisedFavoriteStock = PublishSubject<[BPStock]>()
    var originalFavoriteStock = [BPStock]()
    let errorHandle = PublishSubject<String>()
    
    // MARK: - Get realm data
    func loadRealmData() {
        originalFavoriteStock = BPRealmWrapper.instance.realmStocks.toArray(ofType: BPRealmFavoriteStock.self).map({ $0.convertToStock() })
        publisedFavoriteStock.onNext(originalFavoriteStock)
    }
    
    func subscribeRealmData() {
        BPRealmWrapper.instance.publishedRealmStocks.subscribe(onNext: { [weak self] (realmStocks) in
            guard let self = self else { return }
            self.originalFavoriteStock = realmStocks.map({ $0.convertToStock() })
            self.publisedFavoriteStock.onNext(self.originalFavoriteStock)
        }).disposed(by: disposeBag)
        
        BPRealmWrapper.instance.publishedUpdateInfo.subscribe(onNext: { [weak self] (_, symbol) in
            guard let self = self else { return }
            if let _ = UIApplication.topViewController() as? BPStockFavoriteVC {
                self.invalidateTimer()
                self.fetchRealTimePrice()
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Get realtime price data
    func invalidateTimer() {
        if (realTimeTimer.isValid) {
            realTimeTimer.invalidate()
        }
    }
    
    func fetchRealTimePrice() {
        realTimeTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { (_) in
            var compositionSymbolString = ""
            BPRealmWrapper.instance.realmStocks.toArray(ofType: BPRealmFavoriteStock.self).forEach({
                compositionSymbolString += "\($0.symbol),"
            })
            print(compositionSymbolString)
            BPService().fetchStockRealTime(symbol: compositionSymbolString).asObservable().subscribe(onNext: { [weak self] (response) in
                guard let self = self else { return }
                switch (response) {
                case .success(let json):
                    self.onGetPriceAPISuccess(json: json)
                case .failure(let apiError):
                    self.onGetPriceAPIError(apiError: apiError)
                }
                }, onError: {[weak self] (error) in
                    guard let self = self else { return }
                    self.onGetPriceServerError(apiError: error)
            }).disposed(by: self.disposeBag)
        }
        
    }
    
    private func onGetPriceAPISuccess(json: JSON) {
        if let arrayPrice = json.array {
            for i in 0..<arrayPrice.count {
                let currentJson = arrayPrice[i]
                let symbol = currentJson["symbol"].stringValue
                let price = currentJson["price"].stringValue
                BPRealmWrapper.instance.updateStockPrice(symbol: symbol, price: price)
                BPRealmWrapper.instance.updateStockProfilePrice(symbol: symbol, price: price)
            }
        }
    }
    
    private func onGetPriceAPIError(apiError: ServerError) {
        errorHandle.onNext(apiError.message)
    }
    
    private func onGetPriceServerError(apiError: Error) {
        errorHandle.onNext(apiError.localizedDescription)
    }
    // MARK: - Change favorite status
    func onChangeFavoriteStatus(index: Int, isFavorite: Bool) {
        if (isFavorite) {
            BPRealmWrapper.instance.addStock(stock: originalFavoriteStock[index])
        } else {
            BPRealmWrapper.instance.removeStock(stock: originalFavoriteStock[index])
        }
    }
}
