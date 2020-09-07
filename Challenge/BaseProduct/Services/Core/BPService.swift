//
//  BPService.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import RxAlamofire
import SwiftyJSON
import RxCocoa

struct BPService {
    let sessionManager = Session.default
    /// request
    /// - Parameter urlRequest: using alamorefire URLRequestConvertible
    /// - Returns: the observerable of response with SwiftyJSON and APIError
    func request(_ urlRequest: URLRequestConvertible) -> Observable<BPAPIResponse<JSON, ServerError>> {
        return Observable<BPAPIResponse<JSON, ServerError>>.create({ observer in
            _ = self.sessionManager
                .rx
                .request(urlRequest: urlRequest)
                .responseData()
                .map({ httpResponse, data -> BPAPIResponse<JSON, ServerError> in
                    switch httpResponse.statusCode {
                    case 200...299:
                        let json = try JSON(data: data)
                        if (json["Error Message"].stringValue.isEmpty) {
                            return .success(json)
                        } else {
                            return .failure(ServerError(json["Error Message"].stringValue))
                        }
                    default:
                        return .failure(ServerError("Unknown error occur!"))
                    }
                })
                .subscribe(onNext: { (response) in
                    observer.onNext(response)
                    observer.onCompleted()
                }, onError: { (error) in
                    observer.onError(error)
                })
            return Disposables.create()
        })
    }
    
    func requestInCustomQueue(_ urlRequest: URLRequestConvertible) -> Driver<BPAPIResponse<JSON, ServerError>> {
        return sessionManager
            .rx
            .request(urlRequest: urlRequest)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .responseData()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ httpResponse, data -> BPAPIResponse<JSON, ServerError> in
                switch httpResponse.statusCode {
                case 200...299:
                    let json = try JSON(data: data)
                    if (json["Error Message"].stringValue.isEmpty) {
                        return .success(json)
                    } else {
                        return .failure(ServerError(json["Error Message"].stringValue))
                    }
                default:
                    return .failure(ServerError("Unknown Error Occur!"))
                }
            })
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: .failure(ServerError("Unknown Error Occur!")))
    }
}
