//
//  UIView+.swift
//  BaseProduct
//
//  Created by admin on 9/5/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
extension UIView {
    @IBInspectable
    var connerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor {
        get {
            guard let shadowColor = layer.shadowColor else {
                return .clear
            }
            return UIColor(cgColor: shadowColor)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var shadowOpacity: CGFloat {
        get {
            return CGFloat(layer.shadowOpacity)
        }
        set {
            layer.shadowOpacity = Float(newValue)
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.connerRadius).cgPath
            layer.shadowOffset = newValue
        }
    }
}
