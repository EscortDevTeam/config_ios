//
//  NavigationControllerBar.swift
//  Escort
//
//  Created by Володя Зверев on 09.04.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class NavigationControllerBar: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
    }
}
