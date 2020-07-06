//
//  StartAppMenuTableView.swift
//  Escort
//
//  Created by Володя Зверев on 04.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer

extension StartAppMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return (screenWidth)/1.415
        } else if indexPath.row == 1 {
            return (screenWidth+18)/2.092
        } else if indexPath.row == 2 {
            return (screenWidth)/1.956
        } else if indexPath.row == 3 {
            return isNight ? (screenWidth)/2.011 : (screenWidth - 28)/2.011
        } else {
            return (screenWidth)/2
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    fileprivate func transitionSettingsApp() {
        self.generator.impactOccurred()
        let viewController = MenuController()
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        self.present(viewController, animated: true)
    }
    
    fileprivate func transitionToMapSetAndCheckToLanguage() {
        if code != "ru" {
            self.showToast(message: "Available only in Russian".localized(code), seconds: 1.0)
        } else {
            self.generator.impactOccurred()
            let imgData = UserDefaults.standard.string(forKey: "FioMap")
            if imgData == nil {
                self.navigationController?.pushViewController(SetupMap(), animated: true)
            } else {
                self.navigationController?.pushViewController(SetupMapNewOrDowl(), animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSettingDUT", for: indexPath) as! CellSettingDUT
            cell.backgroundColor = .black
            cell.mainSettingsLabel.text = "Menu".localized(code)
            cell.labelSettingDut.text = "Sensor settings".localized(code)
            cell.labelSettingDutInfo.text = "Escort Configurator".localized(code)
            cell.labelSettingDut.textColor = UIColor(rgb: 0xFF0000)
            cell.labelSettingDutInfo.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x0C005A)
            cell.mainSettingsLabel.textColor = UIColor(rgb: isNight ? 0x000000 : 0xFFFFFF)
            cell.mainSettings.image = isNight ? #imageLiteral(resourceName: "шьфпурвы") : #imageLiteral(resourceName: "Group 41")
            cell.addTapGesture {
                self.navigationController?.pushViewController(DeviceSelectController(), animated: true)
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellMapSet", for: indexPath) as! CellMapSet
            cell.backgroundColor = UIColor(rgb: 0x005CDF)
            cell.labelSettingDut.text = "Installation report".localized(code)
            cell.labelSettingDutInfo.text = "Installation is now much simpler!".localized(code)
            cell.labelSettingDut.textColor = UIColor(rgb: 0xFF0000)
            cell.labelSettingDutInfo.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x0C005A)
            cell.mainSettings.image = isNight ? #imageLiteral(resourceName: "imagesthree") : #imageLiteral(resourceName: "Group 43")
            cell.addTapGesture {
                self.transitionToMapSetAndCheckToLanguage()
            }
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellCalc", for: indexPath) as! CellCalc
            cell.backgroundColor = UIColor(rgb: 0x005CDF)
            cell.labelSettingDut.text = "Wealth Builder".localized(code)
            cell.labelSettingDutInfo.text = "Profitability Calculator".localized(code)
            cell.labelSettingDut.textColor = UIColor(rgb: 0xFF0000)
            cell.labelSettingDutInfo.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x0C005A)
            cell.mainSettings.image = isNight ? #imageLiteral(resourceName: "Group 62") : #imageLiteral(resourceName: "Group 46")
            cell.addTapGesture {
                self.showToast(message: "In development".localized(code), seconds: 1.0)
            }
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSupport", for: indexPath) as! CellSupport
            cell.backgroundColor = UIColor(rgb: 0x005CDF)
            cell.labelSettingDut.text = "Tech Support".localized(code)
            cell.labelSettingDutInfo.text = "Online 24/7".localized(code)
            cell.labelSettingDut.textColor = UIColor(rgb: 0xFF0000)
            cell.labelSettingDutInfo.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x0C005A)
            cell.mainSettings.image = isNight ? #imageLiteral(resourceName: "Group 63") : #imageLiteral(resourceName: "Group 53")
            cell.addTapGesture {
                self.openSupportMenu()
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSettings", for: indexPath) as! CellSettings
            cell.backgroundColor = UIColor(rgb: 0x005CDF)
            cell.labelSettingDut.text = "App settings".localized(code)
            cell.labelSettingDut.textColor = UIColor(rgb: 0xFF0000)
            cell.mainSettings.image = isNight ? #imageLiteral(resourceName: "Group 64") : #imageLiteral(resourceName: "imagesqw")
            cell.addTapGesture {
                self.transitionSettingsApp()
            }

            return cell
        }
    }

    fileprivate func openSupportMenu() {

        let alert = UIAlertController(title: "Tech support".localized(code), message: "Social network".localized(code), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Viber", style: .default, handler: { (_) in
            if let url = URL(string:"viber://chat?number=+79600464665") {
                UIApplication.shared.open(url) { success in
                    if success {
                        print("success")
                    } else {
                        self.showToast(message: "Viber " + "app is not installed on this device".localized(code), seconds: 1)
                    }
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "Telegram", style: .default, handler: { (_) in
            if let url = URL(string:"https://telegram.me/EscortSupport") {
                UIApplication.shared.open(url) { success in
                    if success {
                        print("success")
                    } else {
                        self.showToast(message: "Telegram " + "app is not installed on this device".localized(code), seconds: 1)
                    }
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "WhatsApp", style: .default, handler: { (_) in
            if let url = URL(string:"https://api.whatsapp.com/send?phone=+79600464665") {
                UIApplication.shared.open(url) { success in
                    if success {
                        print("success")
                    } else {
                        self.showToast(message: "WhatsApp " + "app is not installed on this device".localized(code), seconds: 1)
                    }
                }
            }
        }))

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in
            print("Назад")
        }))
        
        self.present(alert, animated: true)
    }
    
    func registerTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(CellSettingDUT.self, forCellReuseIdentifier: "CellSettingDUT")
        self.tableView.register(CellMapSet.self, forCellReuseIdentifier: "CellMapSet")
        self.tableView.register(CellCalc.self, forCellReuseIdentifier: "CellCalc")
        self.tableView.register(CellSupport.self, forCellReuseIdentifier: "CellSupport")
        self.tableView.register(CellSettings.self, forCellReuseIdentifier: "CellSettings")
    }
}

extension StartAppMenuController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark, topGap: screenHeight/3, modalWidth: 0, cornerRadius: 20)
    }
}

