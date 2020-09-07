//
//  BPStockDetailFooterView.swift
//  BaseProduct
//
//  Created by admin on 9/6/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit

protocol BPStockDetailFooterViewDelegate {
    func expandDescription(height: CGFloat)
}

class BPStockDetailFooterView: UIView {
    var delegate: BPStockDetailFooterViewDelegate?
    
    @IBOutlet weak var heightContraint: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var companyDescriptionLbl: UILabel!
    @IBOutlet weak var descriptionValueLbl: UILabel!
    @IBOutlet weak var loadMoreBtn: UIButton!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("BPStockDetailFooterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configFont()
        appearanceConfig()
        NotificationCenter.default.addObserver(self, selector: #selector(appearanceConfig), name: NotificationName.CHANGE_THEME, object: nil)
    }
    
    func configFont() {
        companyDescriptionLbl.font = UIFont().mediumMediumFont
        descriptionValueLbl.font = UIFont().smallLightFont
    }
    
    @objc private func appearanceConfig() {
        companyDescriptionLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
        descriptionValueLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
    }
    
    func setupInfoView(profile: TupleProfileData) {
        descriptionValueLbl.text = profile.1 as? String
    }
    
    @IBAction func moreBtnPressed(_ sender: Any) {
        // expand full
        guard let delegate = delegate else { return }
        let labelHeight = descriptionValueLbl.textHeight(withWidth: descriptionValueLbl.frame.size.width)
        heightContraint.constant = labelHeight
        delegate.expandDescription(height: labelHeight)
    }
}
