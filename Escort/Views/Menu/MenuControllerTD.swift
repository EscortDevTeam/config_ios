//
//  MenuControllerTD.swift
//  Escort
//
//  Created by Володя Зверев on 28.07.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer
import RxSwift
import RxTheme

class MenuControllerTD: UIViewController {
    
    
    weak var delegate: MainDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
        setupTheme()
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
        let textMain = UILabel(frame: CGRect(x: 20, y: 20, width: screenWidth-40, height: 20))
        textMain.center.x = view.center.x
        textMain.textAlignment = .center
        textMain.text = "Menu".localized(code)
        textMain.font = UIFont(name:"FuturaPT-Medium", size: 20)
        textMain.frame.origin.x = 20
        return textMain
    }()

    fileprivate lazy var aboutApp: UILabel = {
        let aboutApp3 = UILabel(frame: CGRect(x: 0, y: 70, width: 300, height: 45))
        aboutApp3.center.x = view.center.x
        aboutApp3.textAlignment = .center
        aboutApp3.text = "Логирование".localized(code)
        aboutApp3.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        aboutApp3.textColor = .white
        return aboutApp3
    }()
    
    private func viewShow() {
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        view.addSubview(bgImage)
        view.addSubview(textMain)
        let lineMain = UIView(frame: CGRect(x: 20, y: 50, width: 142, height: 1))
        lineMain.backgroundColor = UIColor(rgb: 0xCF2121)
        lineMain.center.x = view.center.x
        view.addSubview(lineMain)
        
        let aboutAppView = UIView(frame: CGRect(x: 0, y: 70, width: 300, height: 45))
        aboutAppView.backgroundColor = .clear
        aboutAppView.center.x = view.center.x

        view.addSubview(aboutApp)
        view.addSubview(aboutAppView)
        aboutAppView.addTapGesture {
            self.dismiss(animated: true, completion: {
                print("1442412")
                self.delegate?.buttonT()
            })
        }
    }
    
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            textMain.theme.textColor = themed { $0.navigationTintColor }
            aboutApp.theme.textColor = themed { $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            textMain.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            aboutApp.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}
extension MenuControllerTD: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
