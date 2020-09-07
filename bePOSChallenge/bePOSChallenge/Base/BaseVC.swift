//
//  BaseVC.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseVC: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceConfig()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(appearanceConfig), name: NotificationName.CHANGE_THEME, object: nil)
    }
    
    @objc func appearanceConfig(){
        applicationAppearance()
        self.view.backgroundColor = ThemeWrapper.instance.currentTheme.appBackgroundColor
    }
    
    func applicationAppearance() {
        UISegmentedControl.appearance().tintColor = ThemeWrapper.instance.currentTheme.buttonColor
//        UISegmentedControl.appearance().backgroundColor
        UITabBar.appearance().barTintColor = ThemeWrapper.instance.currentTheme.tabbarColor
        UITabBar.appearance().tintColor = ThemeWrapper.instance.currentTheme.tabbarTintColor
        UINavigationBar.appearance().barTintColor = ThemeWrapper.instance.currentTheme.tabbarColor
        UINavigationBar.appearance().tintColor = ThemeWrapper.instance.currentTheme.tabbarTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : ThemeWrapper.instance.currentTheme.labelColor]
        UIApplication.shared.windows.forEach { window in
            window.subviews.forEach { view in
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
