//
//  ConnectionSelectController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 02.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//
import UIKit
import UIDrawer
import MobileCoreServices
import RxSwift
import RxTheme

class ConnectionSelectController: UIViewController {

    let DeviceSelectCUSB = DeviceSelectControllerUSB()
    let DeviceSelectC = DeviceSelectController()
    let popUpVC = UIStoryboard(name: "MenuSelf", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopupTwoVC
    var timer = Timer()
    
    var menuVC: ContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewShow()
        setupTheme()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        rightCount = 0
        timer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            print("timerConnection")
            self.viewShow()
            if checkMenu == true {
                self.viewShow()
                checkMenu = false
            }
        }
        viewShow()
        boolBLE = false
        print("12")
    }
    lazy var btTitle1: UILabel = {
        let btTitle1 = UILabel(frame: CGRect(x: 120, y: 36, width: screenWidth, height: 36))
        btTitle1.text = "BLUETOOTH"
        btTitle1.textColor = UIColor(rgb: 0x1F1F1F)
        btTitle1.font = UIFont(name:"FuturaPT-Light", size: 32.0)
        return btTitle1
    }()
    
    lazy var btTitle2: UILabel = {
        let btTitle2 = UILabel(frame: CGRect(x: 160, y: 16, width: screenWidth, height: 36))
        btTitle2.text = "USB"
        btTitle2.textColor = UIColor(rgb: 0x1F1F1F)
        btTitle2.font = UIFont(name:"FuturaPT-Light", size: 32.0)
        return btTitle2
    }()

    
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy, width: Int(screenWidth-60), height: 40))
        text.text = "Select connection type".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: 19.0)
        return text
    }()
    fileprivate lazy var themeBackView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: (hasNotch ? 20 : 45), width: screenWidth, height: headerHeight-(hasNotch ? 35 : 67))
        v.layer.cornerRadius = 10
        return v
    }()
    fileprivate lazy var themeBackView2: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (hasNotch ? 35 : 55))
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return v
    }()
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .gray
        }
        activity.center = view.center
//        activity.color = .black
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()
    fileprivate lazy var separator: UIView = {
        let separator = UIView(frame: CGRect(x: 0, y: Int(headerHeight)  + Int((screenHeight - headerHeight) / 2), width: Int(screenWidth), height: 1))
        separator.alpha = 0.1
        return separator
    }()
    
    fileprivate lazy var hamburger: UIImageView = {
        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
        hamburger.image = hamburger.image!.withRenderingMode(.alwaysTemplate)

        return hamburger
    }()
    func viewShow() {
        
        view.subviews.forEach({ $0.removeFromSuperview() })
//        view.backgroundColor = .white
        view.addSubview(themeBackView3)

        MainLabel.text = "Select connection type".localized(code)
        view.addSubview(MainLabel)
//        view.addSubview(headerSet(title: "Select connection type".localized(code)))
        let hamburgerPlace = UIView()
        var yHamb = screenHeight/22
        if screenWidth == 414 {
            yHamb = screenHeight/20
        }
        if screenHeight >= 750{
            yHamb = screenHeight/16
            if screenWidth == 375 {
                yHamb = screenHeight/19
            }
        }
        hamburgerPlace.frame = CGRect(x: screenWidth-50, y: yHamb, width: 35, height: 35)
        hamburger.frame = CGRect(x: screenWidth-45, y: yHamb, width: 25, height: 25)
        view.addSubview(hamburger)
        view.addSubview(hamburgerPlace)
        hamburgerPlace.addTapGesture {
            
            let viewController = MenuController()
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = self
            self.present(viewController, animated: true)
//            self.popUpVC.view.frame = CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight)
//            self.addChild(self.popUpVC) // 2
//            self.popUpVC.view.frame = self.view.frame  // 3
//            self.view.addSubview(self.popUpVC.view) // 4
//            self.popUpVC.didMove(toParent: self)
//            print("Успешно")
            
            
        }
        let cellHeight = Int((screenHeight - headerHeight) / 2)
        let v1 = UIView()
        let btImage1 = UIImageView(image: #imageLiteral(resourceName: "bluetooth_image"))
        btImage1.frame = CGRect(x: 30, y: 0, width: 72, height: 110)
        btImage1.center.y = CGFloat(cellHeight/2)
        btTitle1.center.y = CGFloat(cellHeight/2)
        v1.addSubview(btImage1)
        v1.addSubview(btTitle1)        
//        v1.frame = CGRect(x:0, y: Int(headerHeight)+h, width: Int(screenWidth), height: Int(screenHeight))
        v1.frame = CGRect(x:0, y: Int(headerHeight), width: Int(screenWidth), height: cellHeight)
        v1.addTapGesture{
            self.timer.invalidate()
            boolBLE = true
            print("BLE")
            IsBLE = true
                self.navigationController?.pushViewController(DeviceSelectController(), animated: true)
        }
        view.addSubview(separator)
        
        // usb
        
        let v2 = UIView()
        let btImage2 = UIImageView(image: #imageLiteral(resourceName: "123"))
        btImage2.frame = CGRect(x: 30, y: -20, width: 120, height: 120)

        btImage2.center.y = CGFloat(cellHeight/2)
        btTitle2.center.y = CGFloat(cellHeight/2)
        v2.addSubview(btImage2)
        v2.addSubview(btTitle2)
        v2.frame = CGRect(x:0, y: Int(headerHeight) + cellHeight, width: Int(screenWidth), height: cellHeight)
                v2.addTapGesture{
                    self.timer.invalidate()
                    print("Тап")
                    self.navigationController?.pushViewController(SetupMap(), animated: true)

                }
        v2.alpha = 0.5
        view.addSubview(v1)
        view.addSubview(v2)

    }
    
    
    fileprivate func setupTheme() {
        view.theme.backgroundColor = themed { $0.backgroundColor }
        btTitle1.theme.textColor = themed{ $0.navigationTintColor }
        btTitle2.theme.textColor = themed{ $0.navigationTintColor }
        themeBackView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        MainLabel.theme.textColor = themed{ $0.navigationTintColor }
        separator.theme.backgroundColor = themed { $0.navigationTintColor }
        hamburger.theme.tintColor = themed{ $0.navigationTintColor }
    }
}
extension ConnectionSelectController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark)
    }
}
extension ConnectionSelectController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.absoluteString)
        print(sandboxFileURL.path)
        print(dir)
        print(selectedFileURL.absoluteString)
        sandboxFileURLPath = selectedFileURL.absoluteURL
//        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
//            print("Already exists! Do nothing")
//        }
//        else {
//
//            do {
//                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
//
//                print("Copied file!")
//            }
//            catch {
//                print("Error: \(error)")
//            }
//        }
    }
}
