//
//  BPHistoryStock.swift
//  BaseProduct
//
//  Created by admin on 9/6/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import SwiftyJSON

class BPHistoryStock: BaseModel {
    var date: String
    var open: Double
    var high: Double
    var low: Double
    var close: Double
    var adjClose: Double
    var volume: Double
    var unadjustedVolume: Double
    var change: Double
    var changePercent: Double
    var vwap: Double
    var label: String
    var changeOverTime: Double
    
    init(json: JSON) {
        date = json["date"].stringValue
        open = json["open"].doubleValue
        high = json["high"].doubleValue
        low = json["low"].doubleValue
        close = json["close"].doubleValue
        adjClose = json["adjClose"].doubleValue
        volume = json["volume"].doubleValue
        unadjustedVolume = json["unadjustedVolume"].doubleValue
        change = json["change"].doubleValue
        changePercent = json["changePercent"].doubleValue
        vwap = json["vwap"].doubleValue
        label = json["label"].stringValue
        changeOverTime = json["changeOverTime"].doubleValue
    }
}
