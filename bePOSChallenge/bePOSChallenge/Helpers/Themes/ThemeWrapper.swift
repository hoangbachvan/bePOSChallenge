//
//  ThemeWrapper.swift
//  BaseProduct
//
//  Created by admin on 9/5/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
enum ThemeColor: String {
    case light = "Light Theme"
    case dark = "Dark Theme"
    
    static let allValues: [ThemeColor] = [.light, .dark]
}

class ThemeWrapper {
    var theme: ThemeColor = .light
    
    var currentTheme: BPTheme {
        switch theme {
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        }
    }
    
    static let instance = ThemeWrapper()
    
    func setTheme(theme: ThemeColor) {
        self.theme = theme
    }
}
