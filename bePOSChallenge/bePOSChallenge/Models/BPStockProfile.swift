//
//  BPStockProfile.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias TupleProfileData = (String, Any)

struct BPStockProfile {
    var symbol: String = ""
    var price: String = ""
    var beta: String = ""
    var volAvg: Double = 0
    var mktCap: Double = 0
    var lastDiv: Double = 0
    var range: String = ""
    var changes: Double = 0
    var companyName: String = ""
    var exchange: String = ""
    var exchangeShortName: String = ""
    var website: String = ""
    var descriptionStock: String = ""
    var ceo: String = ""
    var sector: String = ""
    var country: String = ""
    var fullTimeEmployees: String = ""
    var phone: String = ""
    var address: String = ""
    var city: String = ""
    var state: String = ""
    var zip: String = ""
    var dcfDiff: Double = 0
    var dcf: Double = 0
    var image: String = ""
    var currentJson: String = ""
    
    var datas = [TupleProfileData]()
    var descriptionData: TupleProfileData?
    
    init() {
        
    }
    
    init(json: JSON) {
        symbol = json["symbol"].stringValue
        changes = json["changes"].doubleValue
        price = json["price"].stringValue
        beta = json["beta"].stringValue
        volAvg = json["volAvg"].doubleValue
        mktCap = json["mktCap"].doubleValue
        lastDiv = json["lasDiv"].doubleValue
        range = json["range"].stringValue
        companyName = json["companyName"].stringValue
        exchange = json["exchange"].stringValue
        exchangeShortName = json["exchangeShortName"].stringValue
        website = json["website"].stringValue
        descriptionStock = json["description"].stringValue
        ceo = json["ceo"].stringValue
        sector = json["sector"].stringValue
        country = json["country"].stringValue
        fullTimeEmployees = json["fullTimeEmployees"].stringValue
        phone = json["phone"].stringValue
        address = json["address"].stringValue
        city = json["city"].stringValue
        state = json["state"].stringValue
        zip = json["zip"].stringValue
        dcfDiff = json["dcfDiff"].doubleValue
        dcf = json["dcf"].doubleValue
        image = json["image"].stringValue
        currentJson = json.rawString() ?? ""
        
        self.configTupleData(json: json)
    }
    
    mutating func configTupleData(json: JSON) {
        if let dictionary = json.dictionaryObject {
            for (k, v) in dictionary {
                let tuple = TupleProfileData(k, v)
                switch k {
                case "description":
                     descriptionData = TupleProfileData(k,v)
                case "image", "companyName", "price", "symbol":
                    break
                default:
                    if let value = v as? String,
                        !value.isEmpty {
                        datas.append(tuple)
                    }
                }
            }
        }
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
        realmStockProfile.beta = beta
        realmStockProfile.volAvg = volAvg
        realmStockProfile.mktCap = mktCap
        realmStockProfile.lastDiv = lastDiv
        realmStockProfile.range = range
        realmStockProfile.companyName = companyName
        realmStockProfile.exchange = exchange
        realmStockProfile.exchangeShortName = exchangeShortName
        realmStockProfile.website = website
        realmStockProfile.descriptionStock = descriptionStock
        realmStockProfile.ceo = ceo
        realmStockProfile.sector = sector
        realmStockProfile.country = country
        realmStockProfile.fullTimeEmployees = fullTimeEmployees
        realmStockProfile.phone = phone
        realmStockProfile.address = address
        realmStockProfile.city = city
        realmStockProfile.state = state
        realmStockProfile.zip = zip
        realmStockProfile.dcfDiff = dcfDiff
        realmStockProfile.dcf = dcf
        realmStockProfile.currentJson = currentJson
        return realmStockProfile
    }
}
