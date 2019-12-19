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
typealias Atributes = [NSAttributedString.Key: Any]

protocol Theme {
    var backgroundColor: Color { get }
}

struct LightTheme: Theme {
    var backgroundColor: Color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
}

struct DarkTheme: Theme {
    var backgroundColor: Color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
}

enum ThemeType: ThemeProvider {
    case light, dark
    var associatedObject: Theme {
        switch self {
        case .light:
            return LightTheme()
        case.dark:
            return DarkTheme()
        }
    }
}

let themeService = ThemeType.service(initial: .light)
func themed<T>(_ mapper: @escaping ((Theme) -> T)) -> Observable<T> {
    return themeService.attrStream(mapper)
}
