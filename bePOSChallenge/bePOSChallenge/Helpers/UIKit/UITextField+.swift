//
//  UITextField+.swift
//  BaseProduct
//
//  Created by admin on 9/5/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
extension UITextField {
    @IBInspectable
    var leftViewWidth: CGFloat {
        get {
            return 0
        }
        set {
            self.leftViewMode = newValue == 0 ? .never : .always
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.bounds.height))
        }
    }
}
