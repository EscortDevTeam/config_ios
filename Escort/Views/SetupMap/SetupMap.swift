//
//  SetupMap.swift
//  Escort
//
//  Created by Володя Зверев on 26.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

extension SetupMap {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        viewShow()
        setupTheme()

    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let string = textField.text {
            let st1 = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if !st1.isEmpty { // Prints number of words.
                if st1.components(separatedBy: " ").count == 3 {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.successGreen.alpha = 1.0
                        if self.successGreenSecond.alpha == 1.0 {
                            self.mapHelpButton.isEnabled = true
                        }
                    })
                }else {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.successGreen.alpha = 0.0
                        self.mapHelpButton.isEnabled = false
                    })
                }
            }
            else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.successGreen.alpha = 0.0
                    self.mapHelpButton.isEnabled = false
                })
                
            }
        }
    }
    @objc func textFieldDidChangeSecond(_ textField: UITextField) {
        if let string = textField.text {
            let st1 = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if !st1.isEmpty { // Prints number of words.
                if st1.components(separatedBy: " ").count >= 1 {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.successGreenSecond.alpha = 1.0
                        if self.successGreen.alpha == 1.0 {
                            self.mapHelpButton.isEnabled = true
                        }
                    })
                }else {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.successGreenSecond.alpha = 0.0
                        self.mapHelpButton.isEnabled = false
                    })
                }
            }
            else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.successGreenSecond.alpha = 0.0
                    self.mapHelpButton.isEnabled = false
                })
                
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func viewShow() {
        view.addSubview(themeBackView3)

        MainLabel.text = "Карта установки".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        backView.addTapGesture {
            self.navigationController?.popViewController(animated: true)
        }
//---соты картинка
        view.addSubview(bgImage)
 // -- Status bar
        view.addSubview(progresViewAll)
        view.addSubview(statusBarRedOne)
        view.addSubview(statusBarRedTwo)
//        a = a + Int(screenWidth-CGFloat(x*2)-CGFloat(5*countStatus))/countStatus + 5
        view.addSubview(statusBarRedThree)
        view.addSubview(statusBarRedFour)
        view.addSubview(statusBarRedFive)
        view.addSubview(statusBarRedSix)
        
        view.addSubview(mapHelp)
        view.addSubview(viewRedLines)
        view.addSubview(mapHelpTwo)
        view.addSubview(viewGrayLines)
        view.addSubview(viewGrayLinesSecond)
        view.addSubview(mapHelpThree)
        view.addSubview(mapHelpLabel)
        view.addSubview(mapHelpButton)
        clickButtonNext()
//---Second View
        view.addSubview(setupMapTextField)
        view.addSubview(setupMapTextFieldSecond)
        view.addSubview(setupMapText)
        view.addSubview(setupMapTextSecond)
        view.addSubview(successGreen)
        view.addSubview(successGreenSecond)
        
        

    }
}

