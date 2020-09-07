//
//  BPStockListVM.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class BPStockListVM: BaseViewModel {
    var publishedStockList = PublishSubject<[BPStock]>()
    var originalStockList = [BPStock]()
    let isLoading = PublishSubject<Bool>()
    let errorHandle = PublishSubject<String>()
    
    // MARK: - List Stock Logic
    func subscribeRealmData() {
        BPRealmWrapper.instance.publishedUpdateInfo.asObserver().subscribe(onNext: { (isFavorite, symbol) in
            var modifiedIndex = -1
            for i in 0..<self.originalStockList.count {
                if(self.originalStockList[i].symbol == symbol) {
                    modifiedIndex = i
                    break
                }
            }
            
            self.originalStockList[modifiedIndex].isFavorite = isFavorite
            self.publishedStockList.onNext(self.originalStockList)
        }).disposed(by: disposeBag)
    }
    
    func fetchListStock() {
        isLoading.onNext(true)
        BPService().fetchListStock().asObservable().subscribe(onNext: { [weak self] (response) in
            self?.isLoading.onNext(false)
            guard let weakSelf = self else {
                return
            }
            switch (response) {
            case .success(let json):
                weakSelf.onGetListStockSuccess(json: json)
            case .failure(let apiError):
                weakSelf.onGetListStockError(apiError: apiError)
            }
            }, onError: { [weak self] (error) in
                self?.isLoading.onNext(false)
                guard let weakSelf = self else { return }
                weakSelf.onGetListStockServerError(error: error)
        }).disposed(by: disposeBag)
    }
    
    /// parse list stock JSON
    /// - Parameter json: input  SwiftyJSON JSON
    private func onGetListStockSuccess(json: JSON) {
        if let listData = json.array {
            originalStockList = listData.compactMap({ BPStock(json: $0) })
            lookupFavoriteStatus()
            
            (0...1).forEach({
                let currentStock = originalStockList[$0]
                fetchStockProfile(symbol: currentStock.symbol, at: $0)
            })
        }
    }
    
    func lookupFavoriteStatus() {
        var counterForBreak = BPRealmWrapper.instance.realmStocks.count
        outerLoop: for index in 0..<originalStockList.count {
            originalStockList[index].isFavorite = false
            let stock = originalStockList[index]
            for favoriteStock in BPRealmWrapper.instance.realmStocks {
                if (stock.symbol == favoriteStock.symbol) {
                    originalStockList[index].isFavorite = true
                    counterForBreak -= 1
                    if (counterForBreak == 0) {
                        break outerLoop
                    }
                }
            }
        }
        publishedStockList.onNext(originalStockList)
    }
    
    /// Handler request Error
    /// - Parameter apiError: notify error
    private func onGetListStockError(apiError: ServerError) {
        errorHandle.onNext(apiError.message)
    }
    
    /// Handler API Error
    /// - Parameter error: Error
    private func onGetListStockServerError(error: Error) {
        errorHandle.onNext(error.localizedDescription)
    }
    
    // MARK: - Detail Stock Logic
    private func fetchStockProfile(symbol: String, at index: Int) {
        BPService().fetchStockProfile(symbol: symbol).drive(onNext: { [weak self] (response) in
            guard let weakSelf = self else { return }
            switch (response) {
            case .success(let json):
                weakSelf.onGetProfileAPISuccess(json: json, at: index)
            case .failure(let apiError):
                weakSelf.onGetStockProfileError(apiError: apiError)
            }
        }).disposed(by: disposeBag)
    }
    
    private func onGetProfileAPISuccess(json: JSON, at index: Int) {
        if let currentListProfile = json.array,
            let currentJSONProfile = currentListProfile.first {
            let currentProfile = BPStockProfile(json: currentJSONProfile)
            originalStockList[index].profile = currentProfile
            BPRealmWrapper.instance.updateStockProfile(stockProfile: currentProfile)
            publishedStockList.onNext(originalStockList)
        }
    }
    
    private func onGetStockProfileError(apiError: ServerError) {
        
    }
    
    private func onGetStockProfileServerError(error: Error) {
        
    }
    
    // MARK: - Change favorite status
    func onChangeFavoriteStatus(index: Int) {
        BPRealmWrapper.instance.changeStockFavorite(stock: originalStockList[index])
    }
}
