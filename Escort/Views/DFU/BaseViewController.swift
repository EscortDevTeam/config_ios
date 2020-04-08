//
//  BaseViewController.swift
//  Escort
//
//  Created by Володя Зверев on 07.04.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIAlertViewDelegate {
    
    func showAbout(message aMessage : String) {
        let alertView = UIAlertController(title: "About", message: aMessage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertView, animated: true)
    }
    
    func showError(message aMessage: String, title aTitle: String) {
        let alertView = UIAlertController(title: aTitle, message: aMessage, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertView, animated: true)
    }
}
