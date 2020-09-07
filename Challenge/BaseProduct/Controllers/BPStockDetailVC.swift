//
//  BPStockDetailVC.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit

class BPStockDetailVC: BaseVC {
    let stockDetailVM = BPStockDetailVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String(format: Constants.ControllerTitle.stockDetail, "stockDetailVM")
    }
}
