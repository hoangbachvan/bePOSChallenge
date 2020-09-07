//
//  BPStockTableViewCell.swift
//  BaseProduct
//
//  Created by admin on 9/5/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import SDWebImage

protocol BPStockTableViewCellDelegate: AnyObject {
    func favoriteButtonPressed(index: Int, isFavorite: Bool)
}

class BPStockTableViewCell: UITableViewCell {
    
    weak var delegate: BPStockTableViewCellDelegate?
    @IBOutlet var thumbImgView: UIImageView!
    @IBOutlet var symbolLbl: UILabel!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var favoriteBtn: UIButton!
    @IBOutlet var changeImgView: UIImageView!
    @IBOutlet var holderView: UIView!
    
    private var currentIndex = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(self, selector: #selector(appearanceConfig), name: NotificationName.CHANGE_THEME, object: nil)
        appearanceConfig()
        fontConfig()
    }
    
    func fontConfig()  {
        symbolLbl.font = UIFont().largeBoldFont
        nameLbl.font = UIFont().smallItalicFont
        priceLbl.font = UIFont().mediumLightFont
    }
    
    @objc private func appearanceConfig() {
        holderView.backgroundColor = ThemeWrapper.instance.currentTheme.appColor
        symbolLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
        nameLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
        priceLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
        favoriteBtn.tintColor = ThemeWrapper.instance.currentTheme.favoriteBtnColor
    }
    
    func fillData(stock: BPStock, indexPath: Int, isFromFavoriteVC: Bool = false) {
        self.currentIndex = indexPath
        nameLbl.text = stock.name
        priceLbl.text = stock.currencyPrice
        symbolLbl.text = stock.symbol
        
        favoriteBtn.isSelected = isFromFavoriteVC || stock.isFavorite
        
        thumbImgView.sd_setImage(with: stock.profile?.urlImage, completed: nil)
        changeImgView.isHidden = stock.profile == nil
        if let profile = stock.profile {
            changeImgView.backgroundColor = profile.changes >= 0 ? .green : .red
        }
    }
    
    func fillData(stock: BPRealmFavoriteStock, indexPath: Int) {
        self.currentIndex = indexPath
        nameLbl.text = stock.name
        priceLbl.text = stock.price.toCurrency()
        symbolLbl.text = stock.symbol
        
        if let profile = stock.profile {
            priceLbl.text = profile.price
        }
        
        favoriteBtn.isSelected = true
        thumbImgView.sd_setImage(with: URL(string: stock.profile?.image ?? ""), completed: nil)
        changeImgView.isHidden = true
    }
    
    @IBAction func favoriteBtnPressed(_ sender: UIButton) {
        guard let delegate = delegate else { return }
        sender.isSelected = !sender.isSelected
        delegate.favoriteButtonPressed(index: currentIndex, isFavorite: sender.isSelected)
    }
}
