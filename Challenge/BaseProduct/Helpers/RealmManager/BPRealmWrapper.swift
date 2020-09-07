//
//  BPRealmWrapper.swift
//  BaseProduct
//
//  Created by admin on 9/5/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift


extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}

class BPRealmWrapper: NSObject {
    static let instance = BPRealmWrapper()
    
    let realm = try! Realm()
    lazy var realmStocks: Results<BPRealmFavoriteStock> =  {self.realm.objects(BPRealmFavoriteStock.self)}()
    lazy var realmStockProfiles: Results<BPRealmStockProfile> = {self.realm.objects(BPRealmStockProfile.self)}()
    var publishedRealmStocks = PublishSubject<[BPRealmFavoriteStock]>()
    var publishedUpdateInfo = PublishSubject<(Bool, String)>()
    
    var realmStockArray: [BPRealmFavoriteStock] {
        return realmStocks.toArray(ofType: BPRealmFavoriteStock.self)
    }
    
    func changeStockFavorite(stock: BPStock) {
        let predicate = NSPredicate(format: "symbol = %@", stock.symbol)
        let querryObject = realmStocks.filter(predicate)
        
        if (querryObject.isEmpty) {
            addStock(stock: stock)
        } else {
            removeStock(stockSymbol: stock.symbol)
        }
    }
    
    // CRUD
    func addStock(stock: BPStock) {
        try! self.realm.write({
            let realmStock = stock.convertToRealmStocks()
            if let stockProfile = stock.profile {
                realmStock.profile = stockProfile.convertToRealmProfile()
            }
            self.realm.add(realmStock)
        })
        
        publishedUpdateInfo.onNext((true, stock.symbol))
        publishedRealmStocks.onNext(realmStockArray)
    }
    
    func updateStock(stock: BPRealmFavoriteStock) {
        let predicate = NSPredicate(format: "symbol = %@", stock.symbol);
        let querryObject = self.realmStocks.filter(predicate)
        if (!querryObject.isEmpty) {
            var currentStock = querryObject.first
            try! self.realm.write({
                currentStock = stock
            })
            publishedRealmStocks.onNext(realmStockArray)
        }
    }
    
    func removeStock(stockSymbol: String) {
        let dispatchGroup = DispatchGroup()
        let predicate = NSPredicate(format: "symbol = %@", stockSymbol);
        let querryObject = self.realmStocks.filter(predicate)
        if !querryObject.isEmpty {
            let querryProfileObject = self.realmStockProfiles.filter(predicate)
            try! self.realm.write({
                dispatchGroup.enter()
                self.realm.delete(querryProfileObject)
                dispatchGroup.leave()
                dispatchGroup.enter()
                self.realm.delete(querryObject)
                dispatchGroup.leave()
            })
        }
        publishedUpdateInfo.onNext((false, stockSymbol))
        publishedRealmStocks.onNext(realmStockArray)
    }
    
    func updateStockProfile(stockProfile: BPStockProfile) {
        let predicate = NSPredicate(format: "symbol = %@", stockProfile.symbol);
        let querryObject = self.realmStockProfiles.filter(predicate)
        if !querryObject.isEmpty {
            var currentStock = querryObject.first
            try! self.realm.write({
                currentStock = stockProfile.convertToRealmProfile()
            })
            publishedRealmStocks.onNext(realmStockArray)
        }
    }
    
    func updateStockProfile(stockProfile: BPRealmStockProfile) {
        let predicate = NSPredicate(format: "symbol = %@", stockProfile.symbol);
        let querryObject = self.realmStockProfiles.filter(predicate)
        if !querryObject.isEmpty {
            var currentStock = querryObject.first
            try! self.realm.write({
                currentStock = stockProfile
            })
            publishedRealmStocks.onNext(realmStockArray)
        }
    }
}
