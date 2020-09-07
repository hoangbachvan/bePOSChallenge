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

class BPStockFavoriteVM: BaseViewModel {
    var realTimeTimer = Timer()
    var publisedFavoriteStock = PublishSubject<[BPRealmFavoriteStock]>()
    var originalFavoriteStock = [BPRealmFavoriteStock]()
    
    func loadRealmData() {
        originalFavoriteStock = BPRealmWrapper.instance.realmStockArray
        publisedFavoriteStock.onNext(BPRealmWrapper.instance.realmStockArray)
        fetchRealTimePrice()
    }
    
    func subscribeRealmData() {
        BPRealmWrapper.instance.publishedRealmStocks.subscribe(onNext: { [weak self] (realmStocks) in
            guard let weakSelf = self else { return }
            weakSelf.publisedFavoriteStock.onNext(realmStocks)
            //            weakSelf.fetchRealTimePrice()
        }).disposed(by: disposeBag)
        
        BPRealmWrapper.instance.publishedUpdateInfo.subscribe(onNext: { (_, symbol) in
            self.invalidateTimer()
            self.fetchRealTimePrice()
        }).disposed(by: disposeBag)
    }
    
    func onChangeFavoriteStatus(index: Int) {
        BPRealmWrapper.instance.removeStock(stockSymbol: BPRealmWrapper.instance.realmStockArray[index].symbol)
    }
    
    func fetchRealTimePrice() {
        //        invalidateTimer()
        realTimeTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { (_) in
            var compositionSymbolString = ""
            BPRealmWrapper.instance.realmStockArray.forEach({
                compositionSymbolString += "\($0.symbol),"
            })
            print(compositionSymbolString)
            BPService().fetchStockRealTime(symbol: compositionSymbolString).drive(onNext: { [weak self] (response) in
                guard let weakSelf = self else { return }
                switch (response) {
                case .success(let json):
                    weakSelf.onGetPriceAPISuccess(json: json)
                case .failure(let apiError):
                    weakSelf.onGetPriceAPIError(apiError: apiError)
                }
            }).disposed(by: self.disposeBag)
        }
        
    }
    
    private func invalidateTimer() {
        if (realTimeTimer.isValid) {
            realTimeTimer.invalidate()
        }
    }
    
    private func onGetPriceAPISuccess(json: JSON) {
        if let arrayPrice = json.array {
            for i in 0..<arrayPrice.count {
                let currentJson = arrayPrice[i]
                if let currentStock = BPRealmWrapper.instance.realmStockArray.first(where: { $0.symbol == currentJson["symbol"].stringValue }) {
                    BPRealmWrapper.instance.updateStock(stock: currentStock)
                }
            }
        }
    }
    
    private func onGetPriceAPIError(apiError: ServerError) {
        
    }
}
