//
//  BPStockProfile.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import SwiftyJSON

class BPStockProfile: BaseModel {
    var symbol: String
        var price: String
    //    var beta: String
    //    var volAvg: Double
    //    var mktCap: Double
    //    var lastDiv: Double
    //    var range: String
    var changes: Double
    //    var companyName: String
    //    var exchange: String
    //    var exchangeShortName: String
    //    var website: String
    //    var description: String
    //    var ceo: String
    //    var sector: String
    //    var country: String
    //    var fullTimeEmployees: String
    //    var phone: String
    //    var address: String
    //    var city: String
    //    var state: String
    //    var zip: String
    //    var dcfDiff: Double
    //    var dcf: Double
    var image: String
    
    init(json: JSON) {
        image = json["image"].stringValue
        symbol = json["symbol"].stringValue
        changes = json["changes"].doubleValue
        price = json["price"].stringValue
    }
}

extension BPStockProfile {
    var urlImage: URL? {
        return URL(string: image)
    }
    
    func convertToRealmProfile() -> BPRealmStockProfile {
        let realmStockProfile = BPRealmStockProfile()
        realmStockProfile.image = image
        realmStockProfile.symbol = symbol
        realmStockProfile.changes = changes
        realmStockProfile.price = price
        return realmStockProfile
    }
}
