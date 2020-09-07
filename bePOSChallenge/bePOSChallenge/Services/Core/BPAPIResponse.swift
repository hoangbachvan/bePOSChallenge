//
//  BPResponse.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import RxAlamofire
import RxSwift
import SwiftyJSON

enum BPAPIResponse<Value,Error> {
    case success(Value)
    case failure(Error)
    
    init(value: Value){
        self = .success(value)
    }
    
    init(error: Error){
        self = .failure(error)
    }
}

struct ServerError: Codable {
    var message: String
    init(_ message: String) {
        self.message = message
    }
}

