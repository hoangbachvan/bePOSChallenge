//
//  BPAPIService+ListStock.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import Alamofire
import RxSwift
import RxCocoa
import UIKit
import SwiftyJSON

class BPStockAPI: BPBaseRouter {
    let keyDitionary = ["apikey": Constants.apiKey]
    enum EndPoint {
        case stockList
        case stockDetail(symbol: String)
        case stockHistory(symbol: String, from: String, to: String)
        case stockRealTime(symbol: String)
    }
    
    var endPoint: EndPoint
    
    
    init(endPoint: EndPoint) {
        self.endPoint = endPoint
    }
    
    override var path: String {
        switch endPoint {
        case .stockList:
            return Address.Path.stock
        case .stockDetail(let symbol):
            return Address.Path.stockDetail + "/\(symbol)"
        case .stockHistory(symbol: let symbol,from: _, to: _):
            return Address.Path.stockHistory + "/\(symbol)"
        case .stockRealTime(let symbol):
            return Address.Path.stockRealTime + "/\(symbol)"
        }
    }
    
    override var parameters: [String : Any] {
        switch endPoint {
        case .stockList:
            return keyDitionary
        case .stockDetail(symbol: _):
            return keyDitionary
        case .stockHistory(symbol: _ ,from: let from, to: let to):
            return ["from": from, "to": to] + keyDitionary
        case .stockRealTime(_):
            return keyDitionary
        }
    }
    
    override var method: HTTPMethod {
        switch endPoint {
        default:
            return .get
        }
    }
    
    override var requestTimeout: TimeInterval {
        switch endPoint {
        case .stockDetail(symbol: _):
            return 9999
        default:
            return Constants.ApiServices.timeoutInterval
        }
    }
}

extension BPService {
    func fetchListStock() -> Observable<BPAPIResponse<JSON, ServerError>> {
        return request(BPStockAPI(endPoint: .stockList))
    }
    
    func fetchStockHistory(symbol: String, from: String, to: String) -> Observable<BPAPIResponse<JSON, ServerError>> {
        return request(BPStockAPI(endPoint: .stockHistory(symbol: symbol, from: from, to: to)))
    }
    
    func fetchStockProfile(symbol: String) -> Observable<BPAPIResponse<JSON, ServerError>> {
        return request(BPStockAPI(endPoint: .stockDetail(symbol: symbol)))
    }
    
    func fetchStockRealTime(symbol: String) -> Observable<BPAPIResponse<JSON, ServerError>> {
        return request(BPStockAPI(endPoint: .stockRealTime(symbol: symbol)))
    }
}
