//
//  BPStock.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import SwiftyJSON

struct BPStock {
    var name: String
    var exchange: String
    var price: String
    var symbol: String
    var profile: BPStockProfile?
    var isFavorite: Bool = false
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.exchange = json["exchange"].stringValue
        self.price = json["price"].stringValue
        self.symbol = json["symbol"].stringValue
    }
    
    mutating func loadProfile(profile: BPStockProfile?) {
        self.profile = profile
    }
}

// MARK: - Display
extension BPStock {
    var currencyPrice: String {
        return price.toCurrency()
    }
}

// MARK: - Convert Realm object
extension BPStock {
    func convertToRealmStocks() -> BPRealmFavoriteStock {
        let realmStock = BPRealmFavoriteStock()
        realmStock.name = name
        realmStock.exchange = exchange
        realmStock.price = price
        realmStock.symbol = symbol
        realmStock.isFavorite = isFavorite
        return realmStock
    }
}
