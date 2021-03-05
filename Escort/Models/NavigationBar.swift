//
//  NavigationBar.swift
//  Escort
//
//  Created by Володя Зверев on 25.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

func navigationCusmotizing(nav: UINavigationController, navItem: UINavigationItem, title: String?) {
    let backButton = BackBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    navItem.backBarButtonItem = backButton
    nav.navigationBar.backItem?.title = ""
    navItem.backBarButtonItem?.title = ""
    nav.navigationBar.isHidden = false
    nav.navigationBar.isTranslucent = false
    nav.navigationBar.barTintColor  = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
    nav.navigationBar.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
    nav.view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)

    nav.navigationBar.tintColor = isNight ? UIColor.white : UIColor.black
    let title = title ?? ""
    navItem.title = "\(title)".localized(code)
    let textAttributes = [NSAttributedString.Key.font: UIFont(name: "FuturaPT-Medium", size: (iphone5s ? 24 : 20))!, NSAttributedString.Key.foregroundColor: isNight ? UIColor.white : UIColor.black]
    navItem.leftItemsSupplementBackButton = true
    navItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "FuturaPT-Medium", size: (iphone5s ? 17.0 : 19.0))!], for: UIControl.State.normal)
    nav.navigationBar.titleTextAttributes = textAttributes
    nav.navigationBar.layer.shadowColor = UIColor.black.cgColor
    nav.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
    nav.navigationBar.layer.shadowRadius = 3.0
    nav.navigationBar.layer.shadowOpacity = 0.2
    if #available(iOS 14.0, *) {
        navItem.backBarButtonItem?.menu = nil
    }
//    let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(popTo))
//    navigationItem.leftBarButtonItem = backButton

}
class BackBarButtonItem: UIBarButtonItem {
  @available(iOS 14.0, *)
  override var menu: UIMenu? {
    set {
      /* Don't set the menu here */
      /* super.menu = menu */
    }
    get {
      return super.menu
    }
  }
}
