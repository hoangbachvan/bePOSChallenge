//
//  BPSettingVC.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit

class BPSettingVC: BaseVC {
    
    @IBOutlet weak var lblTheme: UILabel!
    @IBOutlet weak var themeBtn: UIButton!
    @IBOutlet weak var appVersionView: UIView!
    @IBOutlet weak var themeChangeView: UIView!
    @IBOutlet weak var appVersionTitleLbl: UILabel!
    @IBOutlet weak var appVersionValueLbl: UILabel!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        self.title = Constants.ControllerTitle.setting
        super.viewDidLoad()
        configView()
    }
    
    // MARK: - Config View
    func configView() {
        appVersionValueLbl.text = UIApplication.appVersion ?? ""
    }
    
    override func applicationAppearance() {
        super.applicationAppearance()
        themeBtn.titleLabel?.textColor = ThemeWrapper.instance.currentTheme.labelColor
        themeBtn.backgroundColor = ThemeWrapper.instance.currentTheme.buttonColor
        lblTheme.textColor = ThemeWrapper.instance.currentTheme.labelColor
        appVersionTitleLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
        appVersionValueLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
        appVersionView.backgroundColor = ThemeWrapper.instance.currentTheme.appColor
        themeChangeView.backgroundColor = ThemeWrapper.instance.currentTheme.appColor
    }
    
    // MARK: - IBAction
    @IBAction func themeBtnPressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Themes", message: "Choose theme", preferredStyle: .actionSheet)
        for theme in ThemeColor.allValues {
            let titleAdded = theme == ThemeWrapper.instance.theme ? "Using " : ""
            actionSheet.addAction(UIAlertAction(title: titleAdded + theme.rawValue, style: .default, handler: { (action) in
                ThemeWrapper.instance.setTheme(theme: theme)
                NotificationCenter.default.post(name: NotificationName.CHANGE_THEME, object: nil)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            actionSheet.dismiss(animated: true, completion: nil)
        }))
        present(actionSheet, animated: true, completion: nil)
    }
}
