//
//  Dictionary+.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
extension Dictionary {
    static func += <K, V> (lhs: inout [K:V], rhs: [K:V]) {
        rhs.forEach({ lhs[$0] = $1})
    }
    
    static func + (lhs: [Key:Value], rhs: [Key:Value]) -> [Key:Value] {
        return lhs.merging(rhs){$1}
    }
}
