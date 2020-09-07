//
//  BaseVC.swift
//  BaseProduct
//
//  Created by Bach Hoang on 9/4/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
import RxSwift

class BaseVC: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appearanceConfig()
        // Do any additional setup after loading the view.
    }
    
    func appearanceConfig(){
        self.view.backgroundColor = ThemeWrapper.instance.theme?.appBackgroundColor
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
