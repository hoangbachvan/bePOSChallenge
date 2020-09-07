//
//  ThemeWrapper.swift
//  BaseProduct
//
//  Created by admin on 9/5/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

class ThemeWrapper {
    var theme: BPTheme?
    static let instance = ThemeWrapper()
    
    func setTheme(theme: BPTheme) {
        self.theme = theme
    }
}
