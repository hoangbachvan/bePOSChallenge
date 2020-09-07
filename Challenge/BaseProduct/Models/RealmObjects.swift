//
//  BPRealmFavoriteStock.swift
//  BaseProduct
//
//  Created by admin on 9/5/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RealmSwift

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

class BPRealmStockProfile: Object {
    @objc dynamic var symbol: String = ""
        @objc dynamic var price: String = ""
    //    @objc dynamic var beta: String
    //    @objc dynamic var volAvg: Double
    //    @objc dynamic var mktCap: Double
    //    @objc dynamic var lastDiv: Double
    //    @objc dynamic var range: String
        @objc dynamic var changes: Double = 0
    //    @objc dynamic var companyName: String
    //    @objc dynamic var exchange: String
    //    @objc dynamic var exchangeShortName: String
    //    @objc dynamic var website: String
    //    @objc dynamic var description: String
    //    @objc dynamic var ceo: String
    //    @objc dynamic var sector: String
    //    @objc dynamic var country: String
    //    @objc dynamic var fullTimeEmployees: String
    //    @objc dynamic var phone: String
    //    @objc dynamic var address: String
    //    @objc dynamic var city: String
    //    @objc dynamic var state: String
    //    @objc dynamic var zip: String
    //    @objc dynamic var dcfDiff: Double
    //    @objc dynamic var dcf: Double
    @objc dynamic var image: String = ""
    
    override class func primaryKey() -> String? {
        return "symbol"
    }
}
