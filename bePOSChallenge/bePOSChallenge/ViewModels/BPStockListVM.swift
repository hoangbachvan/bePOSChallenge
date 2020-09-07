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
    let threadSafeQueue = DispatchQueue(label: "queue.mapping.data", qos: .background, attributes: .concurrent)
    
    var publishedStockList = PublishSubject<[BPStock]>()
    var originalStockList = [BPStock]()
    var filteredList = [BPStock]()
    let isLoading = PublishSubject<Bool>()
    var errorHandle = PublishSubject<String>()
    var searchText = BehaviorRelay<String>(value: "")
    var isSearching = false
    
    func onSearchData() {
        filteredList = originalStockList.filter({ $0.symbol.lowercased().contains(searchText.value.lowercased()) || $0.name.lowercased().contains(searchText.value.lowercased()) })
        isSearching = !searchText.value.isEmpty
        if (searchText.value.isEmpty) {
            publishedStockList.onNext(originalStockList)
        } else {
            publishedStockList.onNext(filteredList)
        }
    }
    
    // MARK: - List Stock Logic
    func fetchListStock() {
        isLoading.onNext(true)
        BPService().fetchListStock().asObservable().subscribe(onNext: { [weak self] (response) in
            guard let self = self else {
                return
            }
            self.isLoading.onNext(false)
            switch (response) {
            case .success(let json):
                self.onGetListStockSuccess(json: json)
            case .failure(let apiError):
                self.onGetListStockError(apiError: apiError)
            }
            }, onError: { [weak self] (error) in
                guard let self = self else { return }
                self.isLoading.onNext(false)
                self.onGetListStockServerError(error: error)
        }).disposed(by: disposeBag)
    }
    
    private func onGetListStockSuccess(json: JSON) {
        if let listData = json.array {
            originalStockList = listData.compactMap({ BPStock(json: $0) })
            lookupFavoriteStatus()
            onPrepareFetchProfile()
        }
    }
    
    private func onGetListStockError(apiError: ServerError) {
        errorHandle.onNext(apiError.message)
    }
    
    private func onGetListStockServerError(error: Error) {
        errorHandle.onNext(error.localizedDescription)
    }
    
    private func onPrepareFetchProfile() {
        let thresHold = 200
        let maximumIndex = originalStockList.count
        for i in stride(from: 0, to: maximumIndex, by: thresHold) {
            var compositionSymbol = ""
            let endIndex = min(i + thresHold, maximumIndex)
            for j in i..<endIndex {
                compositionSymbol += originalStockList[j].symbol + ","
            }
            fetchStockProfile(symbol: compositionSymbol, startIndex: i, endIndex: endIndex)
        }
    }
    
    // MARK: - Stock Profile Logic
    private func fetchStockProfile(symbol: String, startIndex: Int, endIndex: Int) {
        BPService().fetchStockProfile(symbol: symbol)
            .asObservable()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[weak self] (response) in
                guard let self = self else { return }
                switch (response) {
                case .success(let json):
                    self.onGetProfileAPISuccess(json: json, startIndex: startIndex, endIndex: endIndex)
                case .failure(let apiError):
                    self.onGetStockProfileError(apiError: apiError)
                }
                }, onError: { [weak self] (error) in
                    guard let self = self else { return }
                    self.onGetStockProfileServerError(error: error)
            }).disposed(by: disposeBag)
    }
    
    private func onGetProfileAPISuccess(json: JSON, startIndex: Int, endIndex: Int) {
        if let currentListProfile = json.array {
            var countForOuterLoop = currentListProfile.count
            threadSafeQueue.async(flags: .barrier) {
                outerLoop: for i in startIndex..<endIndex {
                    for j in 0..<currentListProfile.count {
                        let currentJson = currentListProfile[j]
                        if (self.originalStockList[i].symbol == currentJson["symbol"].stringValue) {
                            self.originalStockList[i].profile = BPStockProfile(json: currentJson)
                            countForOuterLoop -= 1
                            if (countForOuterLoop == 0) {
                                break outerLoop
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.updateFavoriteProfileIfNeeded()
            }
            threadSafeQueue.sync {
                if (!isSearching) {
                    self.publishedStockList.onNext(self.originalStockList)
                }
            }
            
        }
    }
    
    private func onGetStockProfileError(apiError: ServerError) {
        
    }
    
    private func onGetStockProfileServerError(error: Error) {
        
    }
    
    // MARK: - Realm Logic
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
    
    private func lookupFavoriteStatus() {
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
    
    private func updateFavoriteProfileIfNeeded() {
        var counterForBreak = BPRealmWrapper.instance.realmStocks.count
        outerLoop: for index in 0..<originalStockList.count {
            let stock = originalStockList[index]
            for favoriteStock in BPRealmWrapper.instance.realmStocks {
                if (favoriteStock.symbol == stock.symbol) {
                    if let stockProfile = stock.profile {
                        BPRealmWrapper.instance.updateStockProfile(stockProfile: stockProfile)
                    }
                    
                    counterForBreak -= 1
                    if (counterForBreak == 0) {
                        break outerLoop
                    }
                }
            }
        }
    }
    
    // MARK: - Change favorite status
    func onChangeFavoriteStatus(index: Int, isFavorite: Bool) {
        if (isFavorite) {
            BPRealmWrapper.instance.addStock(stock: isSearching ? filteredList[index] : originalStockList[index])
        } else {
            BPRealmWrapper.instance.removeStock(stock: isSearching ? filteredList[index] : originalStockList[index])
        }
    }
}
