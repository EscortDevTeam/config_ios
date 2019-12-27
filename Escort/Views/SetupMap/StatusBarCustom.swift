//
//  StatusBarCustom.swift
//  Escort
//
//  Created by Володя Зверев on 26.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

extension SetupMap {
    
    func mapProgressBar() {

        backView.addTapGesture{
            UIView.animate(withDuration: 0.3, animations: {
                switch self.backStatus {
                case 1:
                    self.navigationController?.popViewController(animated: true)
                case 2:
                    self.statusBarRedOne.frame.size.width = 0
                    self.progresViewAll.frame.origin.x = -screenWidth
                    self.progresViewAll.alpha = 0.0
                    self.mapHelpThree.frame.origin.x = 0
                    
                    self.viewGrayLines.center.y = screenHeight/2 - 53 - (hasNotch ? 0 : 15)
                    self.viewGrayLines.frame.size.width = 230
                    self.viewGrayLines.center.x = screenWidth/2+6

                    self.viewGrayLinesSecond.center.y = screenHeight/2 - 53 - (hasNotch ? 0 : 15)
                    self.viewGrayLinesSecond.frame.size.width = 230
                    self.viewGrayLinesSecond.center.x = screenWidth/2+6

                    self.mapHelpTwo.frame.origin.x = 0
                    self.viewRedLines.alpha = 1.0
                    self.mapHelp.alpha = 1.0
                    self.mapHelpButton.center.y = screenHeight / 4 * 3 + 50
                    self.mapHelpLabel.center.y = screenHeight / 4 * 3 - 20
                    self.mapHelpButton.setTitle("Start".localized(code), for: .normal)
                    self.mapHelpButton.frame.size.width = screenWidth/2.5
                    self.mapHelpButton.center.x = screenWidth/2
                    self.mapHelpButton.isEnabled = true
                    self.successGreenSecond.alpha = 0.0
                    self.successGreen.alpha = 0.0

                    self.mapHelp.textAlignment = .center
                    self.mapHelp.frame = CGRect(x: 0, y: (hasNotch ? 0 : 50) + 100, width: 205, height: 80)
                    self.mapHelp.text = "Карта установщика позволит вам:".localized(code)
                    self.mapHelp.center.x = screenWidth/2
                    self.setupMapTextField.frame.origin.x = screenWidth
                    self.setupMapTextFieldSecond.frame.origin.x = -screenWidth
                    self.setupMapTextFieldSecond.alpha = 0.0
                    
                    self.setupMapText.frame.origin.x = screenWidth
                    self.setupMapTextSecond.frame.origin.x = -screenWidth
                    self.setupMapTextSecond.alpha = 0.0
                    self.backStatus = 1
                    self.nextStatus = 1
                case 3:
                    UIView.animate(withDuration: 0.5, animations: {
                        self.mapHelp.text = "Установщик/Заказчик:".localized(code)
                    })
                    self.setupMapTextField.center.x = screenWidth/2-20
                     self.setupMapTextFieldSecond.center.x = screenWidth/2-20
                     self.setupMapText.center.x = screenWidth/2-10
                     self.setupMapTextSecond.center.x = screenWidth/2-10
                     self.viewGrayLines.alpha = 1.0
                     self.viewGrayLinesSecond.alpha = 1.0
                     self.successGreen.alpha = 1.0
                     self.successGreenSecond.alpha = 1.0
                    
                    self.statusBarRedTwo.frame.size.width = 0
                    self.backStatus = 2
                    self.nextStatus = 3
                case 4:
                    UIView.animate(withDuration: 0.5, animations: {
                        self.mapHelp.text = "Модель ТС:".localized(code)
                    })
                    self.statusBarRedThree.frame.size.width = 0
                    self.backStatus = 3
                    self.nextStatus = 4
                case 5:
                    UIView.animate(withDuration: 0.5, animations: {
                        self.mapHelp.text = "Трекер:".localized(code)
                    })
                    self.statusBarRedFour.frame.size.width = 0
                    self.backStatus = 4
                    self.nextStatus = 5
                case 6:
                    UIView.animate(withDuration: 0.5, animations: {
                        self.mapHelp.text = "Датчик уровня топлива:".localized(code)
                    })
                    self.statusBarRedFive.frame.size.width = 0
                    self.backStatus = 5
                    self.nextStatus = 6
                case 7:
                    self.mapHelp.text = "Дополнительные сведения:".localized(code)
                    self.mapHelpButton.setTitle("Далее".localized(code), for: .normal)

                    self.statusBarRedSix.frame.size.width = 0
                    self.backStatus = 6
                    self.nextStatus = 7
                default:
                    return
                }
                
            })
        }
    }
}
