//
//  BPStockDetailHeaderView.swift
//  BaseProduct
//
//  Created by admin on 9/6/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import Charts
import SDWebImage
import RealmSwift

protocol BPStockDetailHeaderViewDelegate {
    func changeSegmentValue(index: Int)
    func changeFavoriteStatus(isFavortie: Bool)
}

class BPStockDetailHeaderView: UIView {
    
    static func getViewHeight() -> CGFloat {
        let segmentTopSpace = CGFloat(8)
        let segmentHeight = CGFloat(40)
        let segmentBottomSpace = CGFloat(16)
        let chartViewHeight = UIScreen.main.bounds.width * 9/16
        let infoViewHeight = CGFloat(136)
        return segmentTopSpace
            + segmentHeight
            + segmentBottomSpace
            + chartViewHeight
            + infoViewHeight
    }
    
    var delegate: BPStockDetailHeaderViewDelegate?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var monthSegment: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var candleStickChartView: CandleStickChartView!
    @IBOutlet weak var thumbImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var symbolLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var infoView: UIView!
    
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
        Bundle.main.loadNibNamed("BPStockDetailHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupChartView()
        configFont()
        appearanceConfig()
        NotificationCenter.default.addObserver(self, selector: #selector(appearanceConfig), name: NotificationName.CHANGE_THEME, object: nil)
    }
    
    func configFont() {
        symbolLbl.font = UIFont().largeBoldFont
        nameLbl.font = UIFont().smallItalicFont
        priceLbl.font = UIFont().mediumLightFont
    }
    
    @objc private func appearanceConfig() {
        lineChartView.gridBackgroundColor = ThemeWrapper.instance.currentTheme.appColor
        symbolLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
        nameLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
        priceLbl.textColor = ThemeWrapper.instance.currentTheme.labelColor
        favoriteBtn.tintColor = ThemeWrapper.instance.currentTheme.favoriteBtnColor
        infoView.backgroundColor = ThemeWrapper.instance.currentTheme.appColor
    }
    
    // MARK: - View Config
    func setupInfoView(stock: BPStock) {
        self.nameLbl.text = stock.name
        self.priceLbl.text = stock.price.toCurrency()
        self.symbolLbl.text = stock.symbol
        let realm = try! Realm()
        let predicate = NSPredicate(format: "symbol = %@", stock.symbol)
        self.favoriteBtn.isSelected = !realm.objects(BPRealmFavoriteStock.self).filter(predicate).isEmpty
        if let profile = stock.profile {
            self.thumbImgView.sd_setImage(with: URL(string: profile.image), completed: nil)
        }
    }
    
    func setupChartView() {
        lineChartView.configChartView()
    }
    
    func setupChartData(dataSet: [BPHistoryStock], listDate: [Date]) {
        lineChartView.updateXAsixValue(listDate: listDate)
        lineChartView.setupData(stockData: dataSet)
    }
    
    // MARK: - IBAction
    @IBAction func segmentValueChange(_ sender: UISegmentedControl) {
        guard let delegate = delegate else { return }
        delegate.changeSegmentValue(index: sender.selectedSegmentIndex)
    }
    
    @IBAction func favoriteBtnPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let delegate = delegate else { return }
        delegate.changeFavoriteStatus(isFavortie: sender.isSelected)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
