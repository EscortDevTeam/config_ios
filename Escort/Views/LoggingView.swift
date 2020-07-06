//
//  LoggingModel.swift
//  Escort
//
//  Created by Володя Зверев on 25.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import Foundation
import UIKit

extension LoggingController {
    
    func viewShow() {
        view.addSubview(themeBackView3)

        MainLabel.text = "Логирование".localized(code)
        
        view.addSubview(MainLabel)
        view.addSubview(backView)
        backView.addTapGesture{
            self.generator.impactOccurred()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func registgerPickerView() {
        picker.dataSource = self
        picker.delegate = self

        picker.frame.size = CGSize(width: screenWidth / 4 * 3, height: screenHeight / 3)
        picker.center.x = screenWidth / 2
        picker.center.y = screenHeight / 3
        view.addSubview(picker)
        getButton.center.x = screenWidth / 2
        getButton.center.y = screenHeight - 100
        view.addSubview(getButton)

    }
    
    func createLabelHoursOrDays(label: UILabel,name: String, centerX: CGFloat) {
        label.text = name
        label.frame.size = CGSize(width: 200, height: 40)
        label.font = UIFont(name:"FuturaPT-Light", size: 35)
        label.textColor = isNight ? UIColor.white : UIColor.black
        label.center.x = screenWidth / 3 * centerX
        label.center.y = screenHeight / 2
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}
