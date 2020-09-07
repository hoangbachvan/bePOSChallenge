//
//  BPRealmFavoriteStock.swift
//  BaseProduct
//
//  Created by admin on 9/5/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class BPRealmFavoriteStock: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var exchange: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var symbol: String = ""
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var profile: BPRealmStockProfile? = nil
    override class func primaryKey() -> String? {
        return "symbol"
    }
}

extension BPRealmFavoriteStock {
    func convertToStock() -> BPStock {
        var stock = BPStock()
        stock.name = name
        stock.exchange = exchange
        stock.price = price
        stock.symbol = symbol
        stock.isFavorite = isFavorite
        if let realmProfile = profile {
            stock.profile = realmProfile.convertToStockProfile()
        }
        return stock
    }
}

class BPRealmStockProfile: Object {
    @objc dynamic var symbol: String = ""
    @objc dynamic var price: String = ""
    @objc dynamic var beta: String = ""
    @objc dynamic var volAvg: Double = 0
    @objc dynamic var mktCap: Double = 0
    @objc dynamic var lastDiv: Double = 0
    @objc dynamic var range: String = ""
    @objc dynamic var changes: Double = 0
    @objc dynamic var companyName: String = ""
    @objc dynamic var exchange: String = ""
    @objc dynamic var exchangeShortName: String = ""
    @objc dynamic var website: String = ""
    @objc dynamic var descriptionStock: String = ""
    @objc dynamic var ceo: String = ""
    @objc dynamic var sector: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var fullTimeEmployees: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var state: String = ""
    @objc dynamic var zip: String = ""
    @objc dynamic var dcfDiff: Double = 0
    @objc dynamic var dcf: Double = 0
    @objc dynamic var image: String = ""
    @objc dynamic var currentJson: String = ""
    
    override class func primaryKey() -> String? {
        return "symbol"
    }
}

extension BPRealmStockProfile {
    func convertToStockProfile() -> BPStockProfile {
        var stockProfile = BPStockProfile()
        stockProfile.image = image
        stockProfile.symbol = symbol
        stockProfile.changes = changes
        stockProfile.price = price
        stockProfile.beta = beta
        stockProfile.volAvg = volAvg
        stockProfile.mktCap = mktCap
        stockProfile.lastDiv = lastDiv
        stockProfile.range = range
        stockProfile.companyName = companyName
        stockProfile.exchange = exchange
        stockProfile.exchangeShortName = exchangeShortName
        stockProfile.website = website
        stockProfile.descriptionStock = descriptionStock
        stockProfile.ceo = ceo
        stockProfile.sector = sector
        stockProfile.country = country
        stockProfile.fullTimeEmployees = fullTimeEmployees
        stockProfile.phone = phone
        stockProfile.address = address
        stockProfile.city = city
        stockProfile.state = state
        stockProfile.zip = zip
        stockProfile.dcfDiff = dcfDiff
        stockProfile.dcf = dcf
        stockProfile.currentJson = currentJson
        stockProfile.configTupleData(json: JSON(parseJSON: currentJson))
        return stockProfile
    }
}
