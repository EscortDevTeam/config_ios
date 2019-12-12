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

class ConnectionSelectController: UIViewController, SecondVCDelegate {
    func secondVC_BackClicked(data: String) {
        viewShow()
    }
    let DeviceSelectCUSB = DeviceSelectControllerUSB()
    let DeviceSelectC = DeviceSelectController()
    let popUpVC = UIStoryboard(name: "MenuSelf", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopupTwoVC
    var timer = Timer()
    
    var menuVC: ContainerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        popUpVC.delegate = self
        rightCount = 0
        timer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            print("timerConnection")
            if checkMenu == true {
                self.viewShow()
                checkMenu = false
            }
        }
        viewShow()
        boolBLE = false
        print("12")
    }
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .gray
        }
        activity.center = view.center
        activity.color = .black
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()
    func viewShow() {
        
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
        var h = 0

        view.addSubview(headerSet(title: "Select connection type".localized(code)))
        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
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
        var con = connections[0]
        let v1 = UIView()
        let btImage1 = UIImageView(image: UIImage(named: con.image)!)
        btImage1.frame = CGRect(x: 30, y: 0, width: 72, height: 110)
        let btTitle1 = UILabel(frame: CGRect(x: 120, y: 36, width: screenWidth, height: 36))
        btTitle1.text = con.name
        btTitle1.textColor = UIColor(rgb: 0x1F1F1F)
        btTitle1.font = UIFont(name:"FuturaPT-Light", size: 32.0)
        
        v1.addSubview(btImage1)
        v1.addSubview(btTitle1)
        
        h = (cellHeight - Int(btImage1.frame.height)) / 2
//        v1.frame = CGRect(x:0, y: Int(headerHeight)+h, width: Int(screenWidth), height: Int(screenHeight))
        v1.frame = CGRect(x:0, y: Int(headerHeight) + h, width: Int(screenWidth), height: cellHeight-h)
        v1.addTapGesture{
            self.timer.invalidate()
            boolBLE = true
            print("BLE")
            
            IsBLE = true
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.navigationController?.pushViewController(self.DeviceSelectC, animated: true)
            } 
        }
        
        let separator = UIView(frame: CGRect(x: 0, y: Int(headerHeight)  + cellHeight, width: Int(screenWidth), height: 1))
        separator.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.09)
        view.addSubview(separator)
        
        // usb
        
        con = connections[1]
        let v2 = UIView()
        let btImage2 = UIImageView(image: #imageLiteral(resourceName: "123"))
        btImage2.frame = CGRect(x: 30, y: 0, width: 173, height: 100)
        let btTitle2 = UILabel(frame: CGRect(x: 220, y: 16, width: screenWidth, height: 36))
        btTitle2.text = con.name
        btTitle2.textColor = UIColor(rgb: 0x1F1F1F)
        btTitle2.font = UIFont(name:"FuturaPT-Light", size: 32.0)

        v2.addSubview(btImage2)
        v2.addSubview(btTitle2)
        
        h = (cellHeight - Int(btImage2.frame.height)) / 2
        
        v2.frame = CGRect(x:0, y: Int(headerHeight) + cellHeight + h, width: Int(screenWidth), height: cellHeight-h)
                v2.addTapGesture{
                    
                }
        v2.alpha = 0.5
        view.addSubview(v1)
        view.addSubview(v2)

    }
}
extension ConnectionSelectController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting)
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
