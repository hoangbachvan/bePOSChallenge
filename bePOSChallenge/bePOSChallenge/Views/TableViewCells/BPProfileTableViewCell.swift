//
//  BPProfileTableViewCell.swift
//  BaseProduct
//
//  Created by admin on 9/6/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit

class BPProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var propertyNameLbl: UILabel!
    @IBOutlet weak var propertyValueLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        appearanceConfig()
        NotificationCenter.default.addObserver(self, selector: #selector(appearanceConfig), name: NotificationName.CHANGE_THEME, object: nil)
    }
    
    @objc private func appearanceConfig() {
        propertyNameLbl.font = UIFont().mediumMediumFont
        propertyValueLbl.font = UIFont().smallLightFont
        propertyNameLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
        propertyValueLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
        self.backgroundColor = ThemeWrapper.instance.currentTheme.appColor
    }
    
    func fillData(tuple: TupleProfileData) {
        propertyNameLbl.text = tuple.0
        propertyValueLbl.text = tuple.1 as? String ?? ""
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
