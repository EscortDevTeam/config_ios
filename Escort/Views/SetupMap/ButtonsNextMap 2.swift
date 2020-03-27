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
                    self.generator.impactOccurred()
//                    self.mapHelpButton.isEnabled = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self.mapHelpThree.frame.origin.x = screenWidth
                        self.viewGrayLines.center.y = screenHeight/2 - 96 - (hasNotch ? 0 : 30) + 15 + (iphone5s ? 15 : 0)
                        self.viewGrayLines.frame.size.width = screenWidth/1.4
                        self.viewGrayLines.center.x = screenWidth/2-20
                        self.viewGrayLinesSecond.frame.size.width = screenWidth/1.4
                        self.viewGrayLinesSecond.center.x = screenWidth/2-20
                        self.viewGrayLinesSecond.center.y = screenHeight/2 + 15 + (iphone5s ? 15 : 0)
//                        self.successGreenSecond.alpha = 0.0
                        if self.setupMapTextField.text == "" {
                            self.successGreen.alpha = 0.0
                            self.mapHelpButton.isEnabled = false
                        } else {
                            self.successGreen.alpha = 1.0
                            self.mapHelpButton.isEnabled = true
                        }
                        if self.setupMapTextFieldSecond.text == "" {
                            self.successGreenSecond.alpha = 0.0
                            self.mapHelpButton.isEnabled = false
                        } else {
                            self.successGreenSecond.alpha = 1.0
                            self.mapHelpButton.isEnabled = true
                        }
                        self.mapHelpTwo.frame.origin.x = -screenWidth
                        self.viewRedLines.alpha = 0.0
                        self.mapHelp.text = "Установщик/Заказчик"
                        self.referenceImageFIO.isHidden = false
                        self.referenceImageZakaz.isHidden = false
                        self.mapHelp.frame = CGRect(x: 30, y: (hasNotch ? 0 : 50) + 130, width: screenWidth-30, height: 30)
                        self.mapHelp.textAlignment = .left
                        self.mapHelpButton.center.y = screenHeight - 60
                        self.mapHelpButton.setTitle("Далее".localized(code), for: .normal)
                        self.mapHelpButton.frame.size.width = screenWidth/2
                        self.mapHelpButton.center.x = screenWidth/2
                        self.setupMapTextField.center.x = screenWidth/2-20
//                        self.setupMapTextField.text = ""

//                        self.setupMapTextFieldSecond.text = ""
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
                                self.referenceImageFIO.alpha = 1.0
                                self.referenceImageZakaz.alpha = 1.0

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
                    FIO = "\(String(describing: self.setupMapTextField.text!))"
                    UserDefaults.standard.set(FIO, forKey: "FioMap")
                    
                    zakazMap = "\(String(describing: self.setupMapTextFieldSecond.text!))"
                    UserDefaults.standard.set(zakazMap, forKey: "ZakazMap")
                    
                    self.view.isUserInteractionEnabled = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self.mapHelp.text = "Транспортное средство"
                        self.referenceImageFIO.alpha = 0.0
                        self.referenceImageZakaz.alpha = 0.0
                        self.setupMapTextField.frame.origin.x = -screenWidth
                        self.setupMapTextFieldSecond.frame.origin.x = screenWidth
                        self.setupMapText.frame.origin.x = -screenWidth
                        self.setupMapTextSecond.frame.origin.x = screenWidth
                        self.viewGrayLines.alpha = 0.0
                        self.viewGrayLinesSecond.alpha = 0.0
                        self.successGreen.alpha = 0.0
                        self.successGreenSecond.alpha = 0.0
                        self.statusBarRedTwo.frame.size.width = (screenWidth-CGFloat(30*2)-CGFloat(5*6-1))/6
                        self.tableView.isHidden = false
                    }) { (true) in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.referenceImageFIO.isHidden = true
                            self.referenceImageZakaz.isHidden = true
                            self.tableView.alpha = 1.0
                        })
                        self.view.isUserInteractionEnabled = true
                        self.nextStatus = 4
                        self.backStatus = 3
                    }
                case 4:
                    if modelTcText != "" && numberTcText != "" {
                        self.generator.impactOccurred()
                        self.view.isUserInteractionEnabled = false
                        self.tableViewTrack.isHidden = false
                        self.tableViewTrack.alpha = 1.0
                        UIView.animate(withDuration: 0.5, animations: {
                            self.mapHelp.text = "Трекер"
                            self.mapHelp.alpha = 0.0
                            self.statusBarRedThree.frame.size.width = (screenWidth-CGFloat(30*2)-CGFloat(5*6-1))/6
                            self.tableView.alpha = 0.0
                        })  { (true) in
                            UIView.animate(withDuration: 0.5, animations: {
                                self.tableView.isHidden = true
                                
                            })
                            self.view.isUserInteractionEnabled = true
                            self.nextStatus = 5
                            self.backStatus = 4
                        }
                    } else {
                        self.generatorLong.impactOccurred()
                        self.showToast(message: "Заполните данные на экране", seconds: 1.0)
                    }
                case 5:
                    if modelTrackText != "" && plombaTrackText != "" && photoALLTrack.count >= 2 && photoALLPlace.count >= 2 {
                        self.view.isUserInteractionEnabled = false
                        self.generator.impactOccurred()
                        UIView.animate(withDuration: 0.5, animations: {
                            self.mapHelp.alpha = 1.0
                            self.mapHelp.text = "Датчик уровня топлива"
                            self.tableViewTrack.isHidden = true
                            self.tableViewTrack.alpha = 0.0
                            self.tableViewLvlTop.isHidden = false
                            self.tableViewLvlTop.alpha = 1.0
                            self.statusBarRedFour.frame.size.width = (screenWidth-CGFloat(30*2)-CGFloat(5*6-1))/6
                        })  { (true) in
                            self.view.isUserInteractionEnabled = true
                        }
                        self.nextStatus = 6
                        self.backStatus = 5
                    } else {
                        self.generatorLong.impactOccurred()
                        self.showToast(message: "Заполните данные на экране", seconds: 1.0)
                    }
                case 6:
                    self.view.isUserInteractionEnabled = false
                    self.generator.impactOccurred()
                    UserDefaults.standard.set(photoALLNumberDutLabel[0], forKey: "DUT_0")
                    UserDefaults.standard.set(photoALLNumberDutLabel[1], forKey: "DUT_1")
                    UserDefaults.standard.set(photoALLNumberDutLabel[2], forKey: "DUT_2")
                    UserDefaults.standard.set(photoALLNumberDutLabel[3], forKey: "DUT_3")
                    
                    UserDefaults.standard.set(photoALLPlombaFirstTrackLabel[0], forKey: "DUTP_0")
                    UserDefaults.standard.set(photoALLPlombaFirstTrackLabel[1], forKey: "DUTP_1")
                    UserDefaults.standard.set(photoALLPlombaFirstTrackLabel[2], forKey: "DUTP_2")
                    UserDefaults.standard.set(photoALLPlombaFirstTrackLabel[3], forKey: "DUTP_3")
                    
                    UserDefaults.standard.set(photoALLPlombaSecondTrackLabel[0], forKey: "DUTP2_0")
                    UserDefaults.standard.set(photoALLPlombaSecondTrackLabel[1], forKey: "DUTP2_1")
                    UserDefaults.standard.set(photoALLPlombaSecondTrackLabel[2], forKey: "DUTP2_2")
                    UserDefaults.standard.set(photoALLPlombaSecondTrackLabel[3], forKey: "DUTP2_3")
                    
                    UserDefaults.standard.set(photoALLPlaceSetTrackLabel[0], forKey: "DUTDop_0")
                    UserDefaults.standard.set(photoALLPlaceSetTrackLabel[1], forKey: "DUTDop_1")
                    UserDefaults.standard.set(photoALLPlaceSetTrackLabel[2], forKey: "DUTDop_2")
                    UserDefaults.standard.set(photoALLPlaceSetTrackLabel[3], forKey: "DUTDop_3")
                    
                    UserDefaults.standard.set(numberOfRowLvlTopPreLast, forKey: "countDuts")


                    UIView.animate(withDuration: 0.5, animations: {
                        self.mapHelp.text = "Дополнительные сведения"
                        self.tableViewLvlTop.isHidden = true
                        self.tableViewLvlTop.alpha = 0.0
                        self.statusBarRedFive.frame.size.width = (screenWidth-CGFloat(30*2)-CGFloat(5*6-1))/6
                        self.tableViewOneMore.isHidden = false
                        self.tableViewOneMore.alpha = 1.0
                    })  { (true) in
                        self.view.isUserInteractionEnabled = true
                    }
                    self.nextStatus = 7
                    self.backStatus = 6
                case 7:
                    self.generator.impactOccurred()
//                    PDF().generateExamplePDF()
                    self.view.isUserInteractionEnabled = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self.mapHelp.text = "Карта сформирована!"
                        self.setupMapTextSuccess.alpha = 1.0
                        self.SupportTell.isHidden = false
                        self.SupportTell.alpha = 1.0
                        self.tableViewOneMore.isHidden = true
                        self.tableViewOneMore.alpha = 0.0
                        
                        self.mapHelpButton.setTitle("Посмотреть карту".localized(code), for: .normal)
                        self.statusBarRedSix.frame.size.width = (screenWidth-CGFloat(30*2)-CGFloat(5*6-1))/6
                    })  { (true) in
                        self.view.isUserInteractionEnabled = true
                    }
                    self.backStatus = 7
                    self.nextStatus = 8
                case 8:
                    self.generator.impactOccurred()
                    self.navigationController?.pushViewController(PDF(), animated: true)
                default:
                    return
                }
            })
        }
    }
}
