 //
 //  DeviceSelectController.swift
 //  Escort
 //
 //  Created by Pavel Vladimiroff on 02.07.2019.
 //  Copyright © 2019 pavit.design. All rights reserved.
 //
 
import UIKit
import CoreBluetooth
import UIDrawer
import RxSwift
import RxTheme

 class DeviceSelectController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, DfuModeDelegate {
    func dfuModeBack() {
        print("update")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DFUViewController") as! DFUViewController
        newViewController.modalPresentationStyle = .fullScreen
        let nav = self.navigationController
        nav?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        nav?.pushViewController(newViewController, animated: true)
    }
    
    var manager:CBCentralManager? = nil
    var peripherals = [CBPeripheral]()
    let generator = UIImpactFeedbackGenerator(style: .light)

    var deviceBLE: DeviceBleSettingsAddController?
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            print("ON Bluetooth.")
        }
        else {

        }
    }
    
    let DevicesListC = DevicesListControllerNew()
    let DevicesListTLC = DevicesTLListController()
    let sc = QRScannerViewController()
    let labelA = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager ( delegate : self , queue : nil , options : nil )
        viewShow()
        setupTheme()
        //        RateManager.showRatesController()
    }
    override func viewWillAppear(_ animated: Bool) {
        if checkUpdate == "Update" {
            checkUpdate = nil
            self.dfuModeBack()
        }
        deviceBLE?.delegate = self
        super.viewWillAppear(true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidAppear(_ animated: Bool) {
        QRCODE = ""
    }
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.removeFromSuperview()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .white
        }
        activity.center = view.center
        activity.color = .black
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()
    
    fileprivate lazy var themeBackView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: (hasNotch ? 20 : 45), width: screenWidth, height: headerHeight-(hasNotch ? 35 : 67) + (iphone5s ? 10 : 0))
        v.layer.cornerRadius = 10
        return v
    }()
    fileprivate lazy var themeBackView2: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (hasNotch ? 35 : 55) + (iphone5s ? 10 : 0))
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return v
    }()
    
    fileprivate lazy var imageTD: UIImageView = {
        let imageTD = UIImageView(image: #imageLiteral(resourceName: "bleImage"))
        imageTD.image = imageTD.image!.withRenderingMode(.alwaysTemplate)
        imageTD.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        return imageTD
    }()
    fileprivate lazy var labelTD: UILabel = {
        let labelTD = UILabel()
        labelTD.textColor = UIColor(rgb: 0x272727)
        labelTD.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        labelTD.textAlignment = .center
        labelTD.text = "TD BLE"
        labelTD.font = UIFont(name:"FuturaPT-Light", size: 24.0)
        return labelTD
    }()
    fileprivate lazy var imageQR: UIImageView = {
        let imageQR = UIImageView(image: #imageLiteral(resourceName: "qrcodeImage"))
        imageQR.image = imageQR.image!.withRenderingMode(.alwaysTemplate)
        imageQR.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        return imageQR
    }()
    fileprivate lazy var labelQR: UILabel = {
        let labelQR = UILabel()
        labelQR.textColor = UIColor(rgb: 0x272727)
        labelQR.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        labelQR.textAlignment = .center
        labelQR.text = "QR-code"
        labelQR.font = UIFont(name:"FuturaPT-Light", size: 24.0)
        return labelQR
    }()
    fileprivate lazy var imageTL: UIImageView = {
        let imageTL = UIImageView(image: #imageLiteral(resourceName: "TLImage"))
        imageTL.image = imageTL.image!.withRenderingMode(.alwaysTemplate)
        imageTL.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        return imageTL
    }()
    fileprivate lazy var labelTL: UILabel = {
        let labelTL = UILabel()
        labelTL.textColor = UIColor(rgb: 0x272727)
        labelTL.frame = CGRect(x: 0, y: 0, width: 150, height: 30)
        labelTL.textAlignment = .center
        labelTL.text = "TL BLE"
        labelTL.font = UIFont(name:"FuturaPT-Light", size: 24.0)
        return labelTL
    }()
    fileprivate lazy var imageUpdateDFU: UIImageView = {
        let imageTL = UIImageView(image: #imageLiteral(resourceName: "updateView"))
        imageTL.image = imageTL.image!.withRenderingMode(.alwaysTemplate)
        imageTL.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        return imageTL
    }()
    fileprivate lazy var labelUpdateDFU: UILabel = {
        let labelTL = UILabel()
        labelTL.textColor = UIColor(rgb: 0x272727)
        labelTL.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        labelTL.textAlignment = .center
        labelTL.text = "ОБНОВЛЕНИЕ"
        labelTL.font = UIFont(name:"FuturaPT-Light", size: 24.0)
        return labelTL
    }()
    fileprivate lazy var imageDU: UIImageView = {
        let imageDU = UIImageView(image: #imageLiteral(resourceName: "du_ble_72_Монтажная область 1_Монтажная область 1 1"))
        imageDU.image = imageDU.image!.withRenderingMode(.alwaysTemplate)
        imageDU.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        return imageDU
    }()
    fileprivate lazy var labelDU: UILabel = {
        let labelDU = UILabel()
        labelDU.textColor = UIColor(rgb: 0x272727)
        labelDU.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        labelDU.textAlignment = .center
        labelDU.text = "DU BLE"
        labelDU.font = UIFont(name:"FuturaPT-Light", size: 24.0)
        return labelDU
    }()
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-24), height: 40))
        text.text = "Type of bluetooth sensor".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
    }()
    
    fileprivate lazy var cellLabel: UILabel = {
    let title = UILabel()
    title.textColor = UIColor(rgb: 0x272727)
    title.font = UIFont(name:"FuturaPT-Light", size: 20.0)
    title.textAlignment = .center
    return title

    }()

    fileprivate lazy var hamburger: UIImageView = {
        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
        hamburger.image = hamburger.image!.withRenderingMode(.alwaysTemplate)

        return hamburger
    }()
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+30 : 40) - (iphone5s ? 10 : 0), width: 50, height: 40)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 8, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height/2
        backView.addSubview(back)
        return backView
    }()

    func viewShow() {
        view.addSubview(themeBackView3)

        MainLabel.text = "Type of bluetooth sensor".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        
        self.activityIndicator.stopAnimating()
        
        backView.addTapGesture{
            self.generator.impactOccurred()
            self.navigationController?.popViewController(animated: true)
        }
//        let hamburgerPlace = UIView()
//        var yHamb = screenHeight/22
//        if screenWidth == 414 {
//            yHamb = screenHeight/20
//        }
//        if screenHeight >= 750{
//            yHamb = screenHeight/16
//            if screenWidth == 375 {
//                yHamb = screenHeight/19
//            }
//        }
//        hamburgerPlace.frame = CGRect(x: screenWidth-50, y: yHamb, width: 35, height: 35)
//        self.hamburger.frame = CGRect(x: screenWidth-45, y: yHamb, width: 25, height: 25)
//        
//        self.view.addSubview(self.hamburger)
//        self.view.addSubview(hamburgerPlace)
//        
//        
//        hamburgerPlace.addTapGesture {
//            self.generator.impactOccurred()
//            let viewController = MenuControllerDontLanguage()
//            viewController.modalPresentationStyle = .custom
//            viewController.transitioningDelegate = self
//            self.present(viewController, animated: true)
//        }
        
        let cellHeight = 180
        let containerTD = UIView(frame: CGRect(x: 0, y: headerHeight, width: screenWidth/2, height: CGFloat(cellHeight)))
        imageTD.center.x = view.center.x/2
        imageTD.center.y = containerTD.bounds.height/2-20
        containerTD.addSubview(imageTD)
        labelTD.center.x = view.center.x/2
        labelTD.center.y = containerTD.bounds.height/2 + 50
        containerTD.addSubview(labelTD)
        view.addSubview(containerTD)
        
        containerTD.addTapGesture {
            print("TD")
            self.generator.impactOccurred()
            self.navigationController?.pushViewController(DevicesListControllerNew(), animated: true)
        }
        
        let containerQR = UIView(frame: CGRect(x: screenWidth/2, y: headerHeight, width: screenWidth/2, height: CGFloat(cellHeight)))
        imageQR.center.x = view.center.x/2
        imageQR.center.y = containerQR.bounds.height/2 - 20
        containerQR.addSubview(imageQR)
        labelQR.center.x = view.center.x/2
        labelQR.center.y = containerQR.bounds.height/2 + 50
        containerQR.addSubview(labelQR)
        view.addSubview(containerQR)
        
        containerQR.addTapGesture {
            print("QR")
            self.generator.impactOccurred()
            let storyboard = UIStoryboard(name: "StoryboardScanner", bundle: nil)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "StoryboardScanner")
            self.navigationController?.pushViewController(homeViewController, animated: true)
            
        }
        
        let separator = UIView(frame: CGRect(x: 15, y: Int(Float(headerHeight)+Float(cellHeight)), width: Int(screenWidth-30), height: 2))
        separator.backgroundColor = UIColor(named: "SeperatorColor")
        view.addSubview(separator)
        
        let containerTL = UIView(frame: CGRect(x: 0, y: Int(headerHeight)+Int(cellHeight), width: Int(screenWidth/2), height: Int(cellHeight)))
        imageTL.center.x = view.center.x/2
        imageTL.center.y = containerTL.bounds.height/2 - 20
        containerTL.addSubview(imageTL)
        labelTL.center.x = view.center.x/2
        
        labelTL.center.y = containerTL.bounds.height/2 + 50
        containerTL.addSubview(labelTL)
        view.addSubview(containerTL)
        
        containerTL.addTapGesture {
            print("TL")
            self.generator.impactOccurred()
            self.navigationController?.pushViewController(DevicesTLListController(), animated: true)
        }
        
        let containerDU = UIView(frame: CGRect(x: Int(screenWidth/2), y: Int(headerHeight)+Int(cellHeight), width: Int(screenWidth/2), height: Int(cellHeight)))
        imageDU.center.x = view.center.x/2
        imageDU.center.y = containerDU.bounds.height/2 - 20
        containerDU.addSubview(imageDU)
        labelDU.center.x = view.center.x/2
        
        labelDU.center.y = containerDU.bounds.height/2 + 50
        containerDU.addSubview(labelDU)
        view.addSubview(containerDU)
        
        containerDU.addTapGesture {
            print("DU")
            self.generator.impactOccurred()
            self.navigationController?.pushViewController(DevicesDUController(), animated: true)
        }
        
        let separatorTwo = UIView(frame: CGRect(x: 15, y: Int(Float(headerHeight)+Float(cellHeight*2)), width: Int(screenWidth-30), height: 2))
        separatorTwo.backgroundColor = UIColor(named: "SeperatorColor")
        view.addSubview(separatorTwo)
        
        let updateView = UIView(frame: CGRect(x: 0, y: Int(headerHeight)+Int(cellHeight*2), width: Int(screenWidth/2), height: Int(cellHeight)))
        imageUpdateDFU.center.x = view.center.x/2
        imageUpdateDFU.center.y = containerTL.bounds.height/2 - 20
        updateView.addSubview(imageUpdateDFU)
        labelUpdateDFU.center.x = view.center.x/2
        
        labelUpdateDFU.center.y = containerTL.bounds.height/2 + 50
        updateView.addSubview(labelUpdateDFU)
//        view.addSubview(updateView)
        
        updateView.addTapGesture {
            self.generator.impactOccurred()

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "DFUViewController") as! DFUViewController
            newViewController.modalPresentationStyle = .fullScreen
            let nav = self.navigationController
            nav?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
            nav?.pushViewController(newViewController, animated: true)
        }
    }
    
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            themeBackView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            cellLabel.theme.textColor = themed{ $0.navigationTintColor }
            imageQR.theme.tintColor = themed{ $0.navigationTintColor }
            imageTL.theme.tintColor = themed{ $0.navigationTintColor }
            imageTD.theme.tintColor = themed{ $0.navigationTintColor }
            labelQR.theme.textColor = themed{ $0.navigationTintColor }
            labelTD.theme.textColor = themed{ $0.navigationTintColor }
            labelTL.theme.textColor = themed{ $0.navigationTintColor }
            imageDU.theme.tintColor = themed{ $0.navigationTintColor }
            labelDU.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
            imageUpdateDFU.theme.tintColor = themed{ $0.navigationTintColor }
            labelUpdateDFU.theme.textColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            imageQR.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            imageTL.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            imageTD.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelQR.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelTD.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelTL.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            imageDU.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelDU.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            imageUpdateDFU.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelUpdateDFU.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)

        }
    }
 }
 extension DeviceSelectController: UIViewControllerTransitioningDelegate {
     func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark)
    }
 }

 
