//
//  UIFont+.swift
//  BaseProduct
//
//  Created by admin on 9/5/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit

extension UIFont {
    var largeBoldFont: UIFont {
        return UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    var mediumLightFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .light)
    }
    
    var smallLightFont: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .light)
    }
    
    var smallItalicFont: UIFont {
        return UIFont.italicSystemFont(ofSize: 14)
    }
}
