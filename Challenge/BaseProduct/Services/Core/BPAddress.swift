//
//  BPNetworkConfiguration.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

struct Address {
    static let BaseUrl = "https://financialmodelingprep.com/api/v3"
    
    struct Path {
        static let stock = "stock/list"
        static let stockDetail = "profile"
        static let stockHistory = "historical-price-full"
        static let stockRealTime = "quote-short"
    }
}
