//
//  ViewController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 30.06.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class StartScreenController: UIViewController {
    
    var a1 = ""
    let LanguageVC = LanguageSelectController()
    let ConnectionSelectC = ConnectionSelectController()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
    }
    let image = startScreens[Int(arc4random_uniform(UInt32(startScreens.count)))]
    
    fileprivate lazy var backImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: image.image)!)
        imageView.frame = UIScreen.main.bounds
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    fileprivate lazy var logoImage: UIImageView = {
        let imageLogo = UIImageView(image: UIImage(named: "logo.png")!)
        imageLogo.frame = CGRect(x: image.x, y: image.y, width: image.width, height: image.height)
        return imageLogo
    }()
    
    fileprivate lazy var configText: UILabel = {
        let textConfig = UILabel(frame: CGRect(x: image.x, y: image.y + image.height - 10, width: image.width+30, height: 60))
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if let version = appVersion {
            textConfig.text =  "Configurator".localized(code) + version
            textConfig.textColor = image.color
            textConfig.font = UIFont(name:"FuturaPT-Medium", size: 21.0)
        }
        return textConfig
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activity.center = view.center
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    private func move() {
        self.activityIndicator.stopAnimating()
        navigationController?.pushViewController(ConnectionSelectC, animated: true)
        //        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        //        if launchedBefore  {
        //            print("Not first launch.")
        //            navigationController?.pushViewController(ConnectionSelectC, animated: true)
        //        } else {
        //            print("First launch, setting UserDefault.")
        //            self.navigationController?.pushViewController(LanguageVC, animated: false)
        //            UserDefaults.standard.set(true, forKey: "launchedBefore")
        //        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    private func viewShow() {
        view.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.move()
        }
        view.addSubview(backImage)
        view.addSubview(logoImage)
        view.addSubview(configText)
        view.addSubview(activityIndicator)
    }
    var dataOk: [String : AnyObject] = [:]
    
}
