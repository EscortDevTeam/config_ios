//
//  UIViewController+Alert.swift
//  Escort
//
//  Created by Володя Зверев on 29.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    func showToast(message : String, seconds: Double = 2.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
        alert.view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        alert.view.layer.shadowColor = UIColor(rgb: 0xE80000).cgColor
        alert.view.layer.shadowRadius = 20.0
        alert.view.layer.shadowOpacity = 0.5
        alert.view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedString.Key.font : UIFont(name: "FuturaPT-Medium", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor(rgb: isNight ? 0xFFFFFF : 0x1F2222)]), forKey: "attributedMessage")
        
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
