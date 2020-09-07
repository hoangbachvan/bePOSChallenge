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
    
    func addStock(stock: BPStock) {
        try! realm.write({
            let realmStock = stock.convertToRealmStocks()
            if let stockProfile = stock.profile {
                realmStock.profile = stockProfile.convertToRealmProfile()
            }
            self.realm.add(realmStock)
        })
        publishedUpdateInfo.onNext((true, stock.symbol))
        publishedRealmStocks.onNext(realmStocks.toArray(ofType: BPRealmFavoriteStock.self))
    }
    
    func removeStock(stock: BPStock) {
        let predicate = NSPredicate(format: "symbol = %@", stock.symbol)
        let querryObject = realmStocks.filter(predicate)
        guard let realmStock = querryObject.first else { return }
        try! realm.write({
            if let realmStockProfile = realmStockProfiles.filter(predicate).first {
                realm.delete(realmStockProfile)
            }
            realm.delete(realmStock)
        })
        publishedUpdateInfo.onNext((false, stock.symbol))
        publishedRealmStocks.onNext(realmStocks.toArray(ofType: BPRealmFavoriteStock.self))
    }
    
    func updateStockPrice(symbol: String, price: String) {
        let predicate = NSPredicate(format: "symbol = %@", symbol)
        let querryObject = realmStocks.filter(predicate)
        guard let realmStock = querryObject.first else { return }
        try! realm.write({
            realmStock.price = price
        })
        publishedRealmStocks.onNext(realmStocks.toArray(ofType: BPRealmFavoriteStock.self))
    }
    
    func updateStockProfile(stockProfile: BPStockProfile) {
        let predicate = NSPredicate(format: "symbol = %@", stockProfile.symbol)
        if let _ = realmStockProfiles.filter(predicate).first {
            return
        }
        
        let querryObject = realmStocks.filter(predicate)
        guard let realmStock = querryObject.first else { return }
        realm.writeAsync(obj: realmStock) { (realmBg, threadSafeStock) in
            guard let stockToUpdate = threadSafeStock else { return }
            // if there is already exist does not write again
            if let _ = realmBg.objects(BPRealmStockProfile.self).filter(predicate).first {
                return
            }
            stockToUpdate.profile = stockProfile.convertToRealmProfile()
        }
    }
    
    func updateStockProfilePrice(symbol: String ,price: String) {
        let predicate = NSPredicate(format: "symbol = %@", symbol)
        let querryObject = realmStockProfiles.filter(predicate)
        guard let realmStockProfile = querryObject.first else { return }
        try! realm.write({
            realmStockProfile.price = price
        })
        publishedRealmStocks.onNext(realmStocks.toArray(ofType: BPRealmFavoriteStock.self))
    }
}
