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
    let ConnectionSelectC = StartAppMenuController()
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let textConfig = UILabel(frame: CGRect(x: image.x-10, y: image.y + image.height - 10, width: image.width+30, height: 60))
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if let version = appVersion {
            textConfig.text =  "Configurator".localized(code) + version
            textConfig.textColor = image.color
            textConfig.font = UIFont(name:"FuturaPT-Medium", size: 21.0)
        }
        return textConfig
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .white
        }
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()
    private func move() {
        self.activityIndicator.stopAnimating()
        navigationController?.pushViewController(ConnectionSelectC, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        viewShow()

    }
    fileprivate func moveOpenFile() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let dfuViewController = mainStoryboard.instantiateViewController(withIdentifier: "DFUViewController") as! DFUViewController
        self.navigationController?.pushViewController(dfuViewController, animated: true)
        dfuViewController.onFileImported(withURL: urlFile!)
    }
    
    private func viewShow() {
        view.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            move()
            if urlFile != nil {
                moveOpenFile()
            }
        }
        view.addSubview(backImage)
        if image.image != "4" && image.image != "5" {
            view.addSubview(logoImage)
            view.addSubview(configText)
        }
        view.addSubview(activityIndicator)
    }
    var dataOk: [String : AnyObject] = [:]
    
}
