//
//  ButtonsNextMap.swift
//  Escort
//
//  Created by Володя Зверев on 26.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

extension SetupMap {
    func clickButtonNext() {
        mapHelpButton.addTapGesture {
            UIView.animate(withDuration: 1.0, animations: {
                switch self.nextStatus {
                case 1:
                    self.view.isUserInteractionEnabled = false
//                    self.mapHelpButton.isEnabled = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self.mapHelpThree.frame.origin.x = screenWidth
                        self.viewGrayLines.center.y = screenHeight/2 - 96 - (hasNotch ? 0 : 30) + 15
                        self.viewGrayLines.frame.size.width = screenWidth/1.4
                        self.viewGrayLines.center.x = screenWidth/2-20
                        self.viewGrayLinesSecond.frame.size.width = screenWidth/1.4
                        self.viewGrayLinesSecond.center.x = screenWidth/2-20
                        self.viewGrayLinesSecond.center.y = screenHeight/2 + 15
                        self.successGreenSecond.alpha = 0.0
                        self.successGreen.alpha = 0.0
                        self.mapHelpTwo.frame.origin.x = -screenWidth
                        self.viewRedLines.alpha = 0.0
                        self.mapHelp.text = "Установщик/Заказчик"
                        self.mapHelp.frame = CGRect(x: 30, y: (hasNotch ? 0 : 50) + 130, width: screenWidth-60, height: 30)
                        self.mapHelp.textAlignment = .left
                        self.mapHelpButton.center.y = screenHeight / 4 * 3 + 90
                        self.mapHelpButton.setTitle("Далее".localized(code), for: .normal)
                        self.mapHelpButton.frame.size.width = screenWidth/2
                        self.mapHelpButton.center.x = screenWidth/2
                        self.setupMapTextField.center.x = screenWidth/2-20
                        self.setupMapTextField.text = ""

                        self.setupMapTextFieldSecond.text = ""
                        self.setupMapTextFieldSecond.alpha = 1.0
                        self.setupMapTextFieldSecond.center.x = screenWidth/2-20
                        
                        self.setupMapText.center.x = screenWidth/2-10
                        self.setupMapTextSecond.alpha = 1.0
                        self.setupMapTextSecond.center.x = screenWidth/2-10

                        self.mapHelpLabel.frame.origin.y = screenHeight
                        self.progresViewAll.frame.origin.x = 0
                        self.progresViewAll.alpha = 1.0
                        self.mapProgressBar()
                    }) { (true) in
                            UIView.animate(withDuration: 1.0, animations: {
                                self.statusBarRedOne.frame.size.width = (screenWidth-CGFloat(30*2)-CGFloat(5*6-1))/6
                            })
                            { (true) in
                                self.view.isUserInteractionEnabled = true
                            }
                        }
                    
                    self.nextStatus = 3
                    self.backStatus = 2
                case 2:
                    self.nextStatus = 3
                    self.backStatus = 2
                case 3:
                    self.view.isUserInteractionEnabled = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self.mapHelp.text = "Модель ТС"
                        self.setupMapTextField.frame.origin.x = -screenWidth
                        self.setupMapTextFieldSecond.frame.origin.x = screenWidth
                        self.setupMapText.frame.origin.x = -screenWidth
                        self.setupMapTextSecond.frame.origin.x = screenWidth
                        self.viewGrayLines.alpha = 0.0
                        self.viewGrayLinesSecond.alpha = 0.0
                        self.successGreen.alpha = 0.0
                        self.successGreenSecond.alpha = 0.0
                        self.statusBarRedTwo.frame.size.width = (screenWidth-CGFloat(30*2)-CGFloat(5*6-1))/6

                    }) { (true) in
                        self.view.isUserInteractionEnabled = true
                        self.nextStatus = 4
                        self.backStatus = 3
                    }
                case 4:
                    self.mapHelp.text = "Трекер"
                    self.statusBarRedThree.frame.size.width = (screenWidth-CGFloat(30*2)-CGFloat(5*6-1))/6
                    self.nextStatus = 5
                    self.backStatus = 4
                case 5:
                    self.mapHelp.text = "Датчик уровня топлива"
                    self.statusBarRedFour.frame.size.width = (screenWidth-CGFloat(30*2)-CGFloat(5*6-1))/6
                    self.nextStatus = 6
                    self.backStatus = 5
                case 6:
                    self.mapHelp.text = "Дополнительные сведения"
                    self.statusBarRedFive.frame.size.width = (screenWidth-CGFloat(30*2)-CGFloat(5*6-1))/6
                    self.nextStatus = 7
                    self.backStatus = 6
                case 7:
                    self.mapHelp.text = "Карта сформирована!"
                    self.mapHelpButton.setTitle("Посмотреть карту".localized(code), for: .normal)
                    self.statusBarRedSix.frame.size.width = (screenWidth-CGFloat(30*2)-CGFloat(5*6-1))/6
                    self.backStatus = 7
                default:
                    return
                }
            })
        }
    }
}
