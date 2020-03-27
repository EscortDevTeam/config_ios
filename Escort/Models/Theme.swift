//
//  Theme.swift
//  Escort
//
//  Created by Володя Зверев on 19.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import RxSwift
import RxTheme

typealias Color = UIColor
typealias ImageView = UIImageView
typealias Attributes = [NSAttributedString.Key: Any]

protocol Theme {
    var backgroundColor: Color { get }
    var backgroundNavigationColor: Color { get }
    var imageView: ImageView { get }

    var navigationBarTintColor: Color { get }
    var navigationTintColor: Color { get }
    var navigationBarTitleTextAttr: Attributes { get }
    var navigationBarTitleTextAttr2: UIActivityIndicatorView.Style { get }
    var imageColorMenu: Color { get }
    var infoColor: Color { get }


}

@available(iOS 13.0, *)
struct LightTheme: Theme {
    
    var infoColor: Color = #colorLiteral(red: 0.04705882353, green: 0, blue: 0.3529411765, alpha: 1)
    
    
//    var imageColorMenu: Color = #colorLiteral(red: 0.04705882353, green: 0, blue: 0.3529411765, alpha: 1)
    var imageColorMenu: Color = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)

    
    var navigationBarTitleTextAttr2: UIActivityIndicatorView.Style = .medium
    
    var backgroundColor: Color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var backgroundNavigationColor: Color = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
    var imageView: ImageView = UIImageView(image: #imageLiteral(resourceName: "Group-2"))
    
    var navigationBarTintColor: Color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var navigationTintColor: Color = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1)
    var navigationBarTitleTextAttr: Attributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1215686275, green: 0.1333333333, blue: 0.1333333333, alpha: 1) ]
    
}
//1F2222

@available(iOS 13.0, *)
struct DarkTheme: Theme {
    
    var infoColor: Color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    var imageColorMenu: Color = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
    
    var navigationBarTitleTextAttr2: UIActivityIndicatorView.Style = .large

    var backgroundColor: Color = #colorLiteral(red: 0.1215686275, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
    var backgroundNavigationColor: Color = #colorLiteral(red: 0.1529411765, green: 0.1529411765, blue: 0.1529411765, alpha: 1)
    var imageView: ImageView = UIImageView(image: #imageLiteral(resourceName: "copy"))

    var navigationBarTintColor: Color = #colorLiteral(red: 0.1215686275, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
    var navigationTintColor: Color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var navigationBarTitleTextAttr: Attributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) ]
}

@available(iOS 13.0, *)
enum ThemeType: ThemeProvider {
    case light, dark
    var associatedObject: Theme {
        switch self {
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        }
    }
}

@available(iOS 13.0, *)
let themeService = ThemeType.service(initial: isNight ? .dark : .light)
@available(iOS 13.0, *)
func themed<T>(_ mapper: @escaping ((Theme) -> T)) -> Observable<T> {
    return themeService.attrStream(mapper)
}
