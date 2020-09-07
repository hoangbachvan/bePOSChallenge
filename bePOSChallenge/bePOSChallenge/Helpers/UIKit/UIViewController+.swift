//
//  UIViewController+.swift
//  BaseProduct
//
//  Created by admin on 9/5/20.
//  Copyright © 2020 Bach Van Hoang. All rights reserved.
//

import UIKit
enum StoryBoardName: String {
    case main = "Main"
    case stock = "Stock"
    case favoriteStock = "FavoriteStock"
    case setting = "Setting"
}

extension UIViewController {
    func showHUD() {
//        UIActivityViewController(activityItems: <#T##[Any]#>, applicationActivities: <#T##[UIActivity]?#>)
    }
    
    func dismissHUD() {
        
    }
    
    func instantiateViewController<T>(of type: T.Type, storyboard name: StoryBoardName) -> T {
        let storyboard = UIStoryboard(name: name.rawValue, bundle: nil)
        return storyboard.instantiateViewController(identifier: String(describing: type)) as! T
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
