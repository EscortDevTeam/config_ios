//
//  referenceController.swift
//  Escort
//
//  Created by Володя Зверев on 04.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer
import RxSwift
import RxTheme

class ReferenceController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aboutInformation.sizeToFit()
        viewShow()
        setupTheme()
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-300, width: 201, height: 207)
        return img
    }()
    fileprivate lazy var textMain: UILabel = {
        let textMain = UILabel(frame: CGRect(x: screenWidth/6, y: 70, width: screenWidth-120, height: 30))
        textMain.textAlignment = .left
        textMain.text = "\(referenceMapMain)"
        textMain.font = UIFont(name:"FuturaPT-Medium", size: 24)
        return textMain
    }()
    
    fileprivate lazy var aboutInformation: UILabel = {
        let aboutApp = UILabel(frame: CGRect(x: screenWidth/6, y: 110, width: screenWidth - screenWidth/3, height: 500))
        aboutApp.textAlignment = .left
        aboutApp.text = "\(referenceMapInfo)"
        aboutApp.numberOfLines = 10
        
        aboutApp.font = UIFont(name:"FuturaPT-Light", size: 20.0)
        return aboutApp
    }()
    
    fileprivate lazy var aboutApp2: UILabel = {
        let aboutApp2 = UILabel(frame: CGRect(x: 0, y: 120, width: 300, height: 45))
        aboutApp2.center.x = view.center.x
        aboutApp2.textAlignment = .center
        aboutApp2.text = "Tech support".localized(code)
        aboutApp2.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp2.textColor = .white
        return aboutApp2
    }()
    fileprivate lazy var aboutApp4: UILabel = {
        let aboutApp4 = UILabel(frame: CGRect(x: 0, y: 170, width: 300, height: 45))
        aboutApp4.center.x = view.center.x
        aboutApp4.textAlignment = .center
        aboutApp4.text = "Reference".localized(code)
        aboutApp4.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp4.textColor = .white
        return aboutApp4
    }()
    
    private func viewShow() {
        
        view.addSubview(bgImage)
//        textMain.text = "Menu".localized(code)
        view.addSubview(textMain)
        view.addSubview(aboutInformation)

        let lineMain = UIView(frame: CGRect(x: 0, y: 15, width: screenWidth/6, height: 3))
        lineMain.backgroundColor = UIColor(rgb: 0xDEDEDE)
        lineMain.layer.cornerRadius = 1
        lineMain.center.x = view.center.x
        view.addSubview(lineMain)
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            textMain.theme.textColor = themed { $0.navigationTintColor }
            aboutInformation.theme.textColor = themed { $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            textMain.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            aboutInformation.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}


