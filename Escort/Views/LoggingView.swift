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
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        MainLabel.text = "Логирование".localized(code)
        
        view.addSubview(MainLabel)
        view.addSubview(backView)
        backView.addTapGesture{
            let alert = UIAlertController(title: "Close?".localized(code), message: "Вы точно хотите завершить логирование?".localized(code), preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No".localized(code), style: .default, handler: { _ in
                //Cancel Action
            }))
            alert.addAction(UIAlertAction(title: "Yes".localized(code),
                                          style: .destructive,
                                          handler: {(_: UIAlertAction!) in
                                            let  vc =  self.navigationController?.viewControllers.filter({$0 is DeviceBleController}).first
                                            self.navigationController?.popToViewController(vc!, animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        cancelLabel.addTapGesture {
            self.cancelTap()
        }
    }
    
    func registgerPickerView() {
        picker.dataSource = self
        picker.delegate = self

        picker.frame.size = CGSize(width: screenWidth / 4 * 3, height: screenHeight / 3)
        picker.center.x = screenWidth / 2
        picker.center.y = screenHeight / 3
        view.addSubview(picker)
        
        view.addSubview(deleteAllButton)
        deleteAllButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        deleteAllButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        deleteAllButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        deleteAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        view.addSubview(getAllButton)
        getAllButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth / 2 + 10).isActive = true
        getAllButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        getAllButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        getAllButton.bottomAnchor.constraint(equalTo: deleteAllButton.topAnchor, constant: -20).isActive = true
        
        view.addSubview(getButton)
        getButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        getButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth / 2 - 10).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        getButton.bottomAnchor.constraint(equalTo: deleteAllButton.topAnchor, constant: -20).isActive = true

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
    func deleteLogger() {
        countPacket = "0"
        countPackets = "0"
        inverst = "0"
        
        viewAlphaLogger.removeFromSuperview()
        
        cancelButton.setTitle("Стоп", for: .normal)
        cancelButton.removeTarget(nil, action: nil, for: .allEvents)
        cancelButton.addTarget(self, action: #selector(stopButtonClick(_:)), for: UIControl.Event.touchUpInside)
        cancelButton.removeFromSuperview()
        
        cancelLabel.removeFromSuperview()
        viewLogger.removeFromSuperview()
        
        indicatorView.alpha = 1.0
        indicatorView.removeFromSuperview()
        
        interestLabel.text = "0%"
        interestLabel.font = UIFont(name:"FuturaPT-Medium", size: 35)
        interestLabel.numberOfLines = 0
        
        interestLabel.removeFromSuperview()
        blocksLabel.removeFromSuperview()
        
    }
    func createLogger() {
        timerStart()
        view.addSubview(viewAlphaLogger)
        view.addSubview(viewLogger)
        viewLogger.addSubview(cancelButton)

        viewLogger.addSubview(indicatorView)
        indicatorView.startAnimating()
        
        viewLogger.addSubview(interestLabel)
        viewLogger.addSubview(blocksLabel)
        
        interestLabel.centerXAnchor.constraint(equalTo: viewLogger.centerXAnchor).isActive = true
        interestLabel.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor).isActive = true
        interestLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        interestLabel.widthAnchor.constraint(equalToConstant: screenWidth - 70).isActive = true
        
        blocksLabel.trailingAnchor.constraint(equalTo: viewLogger.trailingAnchor, constant: -10).isActive = true
        blocksLabel.topAnchor.constraint(equalTo: viewLogger.topAnchor).isActive = true
        blocksLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        blocksLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        indicatorView.topAnchor.constraint(equalTo: viewLogger.topAnchor, constant: 20 ).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: viewLogger.centerXAnchor).isActive = true
        indicatorView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: 100).isActive = true

        cancelButton.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 20).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: viewLogger.bottomAnchor, constant: -20).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: viewLogger.centerXAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        viewLogger.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewLogger.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        viewLogger.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        viewLogger.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        viewLogger.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 20).isActive = true
        viewLogger.topAnchor.constraint(equalTo: indicatorView.topAnchor, constant: -20).isActive = true


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
