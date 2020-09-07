//
//  BPRouter.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RxAlamofire
import Alamofire

class BPBaseRouter: URLRequestConvertible {
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String:Any] {
        return [String:Any]()
    }
    
    var requestTimeout: TimeInterval {
        return Constants.ApiServices.timeoutInterval
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Address.BaseUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = requestTimeout
        if (method == .post || method == .delete) {
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: self.parameters)
        } else {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: self.parameters)
        }
        
        print(urlRequest.url ?? "")
        return urlRequest
    }
}
