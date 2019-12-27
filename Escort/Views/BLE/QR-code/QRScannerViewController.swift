//
//  ScannerViewController.swift
//  Escort
//
//  Created by Володя Зверев on 29.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController {
    
    var hamburger = UIImageView(image: UIImage(named: isNight ? "LanternWhite" : "Lantern")!)

    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }

    let DevicesListC = DevicesListController()

    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                let tdstcount = qrData?.codeString?.count
                if let pruf = qrData?.codeString {
                    print(pruf)
                    if pruf.count == 52 || pruf.count == 55 {
                        if pruf.contains("https://www.fmeter.ru/") || pruf.contains("https://www.fmeter.ru/TD/") {
                            let tdstring = pruf.dropFirst(tdstcount!-6)
                            print(tdstring)
                            hidednCell = true
                            self.navigationController?.pushViewController(DevicesListControllerNew(), animated: true)
                            QRCODE = String(tdstring)
                        } else {
                            showToast(message: "QR-code не поддерживается", seconds: 2.0)
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                self.scannerView.startScanning()
                            })
                        }
                    } else {
                        showToast(message: "QR-code не поддерживается", seconds: 2.0)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                            self.scannerView.startScanning()
                        })
                    }
                }
            }
        }
    }
    fileprivate lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+30 : 40), width: 50, height: 40)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 8, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height/2
        backView.addSubview(back)
        return backView
    }()
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy, width: Int(screenWidth-60), height: 40))
        text.text = "Tank calibration".localized(code)
        text.font = UIFont(name:"BankGothicBT-Medium", size: 19.0)
        return text
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(themeBackView3)
        MainLabel.text = "QR-CODE".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)

        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        hamburger = UIImageView(image: UIImage(named: isNight ? "LanternWhite" : "Lantern")!)
        let hamburgerPlace = UIView()
        var yHamb = screenHeight/22
        if screenWidth == 414 {
            yHamb = screenHeight/20
        }
        if screenHeight >= 750 {
            yHamb = screenHeight/16
            if screenWidth == 375 {
                yHamb = screenHeight/19
            }
        }
        hamburgerPlace.frame = CGRect(x: screenWidth-50, y: yHamb-10, width: 35, height: 45)
        hamburger.frame = CGRect(x: screenWidth-45, y: yHamb-10, width: 25, height: 35)
        
        view.addSubview(hamburger)
        view.addSubview(hamburgerPlace)
        
        
        hamburgerPlace.addTapGesture {
            self.lightOn()
        }
        setupTheme()

    }
    func lightOn() {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if device!.hasTorch {
            do {
                try device!.lockForConfiguration()
                device!.torchMode = device!.torchMode == AVCaptureDevice.TorchMode.on ? .off : .on
                device!.unlockForConfiguration()
                hamburger.image = device!.torchMode == AVCaptureDevice.TorchMode.on ? #imageLiteral(resourceName: "LanternRed") : (isNight ? #imageLiteral(resourceName: "LanternWhite") : #imageLiteral(resourceName: "Lantern") )
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if checkPopQR == true {
            showToast(message: "Не удалось подключиться", seconds: 2.0)
            checkPopQR = false
        }
        hamburger.image = (isNight ? #imageLiteral(resourceName: "LanternWhite") : #imageLiteral(resourceName: "Lantern") )
        checkQR = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        if !scannerView.isRunning {
//            scannerView.startScanning()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if !scannerView.isRunning {
            scannerView.stopScanning()
//        }
    }

    @IBAction func scanButtonAction(_ sender: UIButton) {
        scannerView.isRunning ? scannerView.stopScanning() : scannerView.startScanning()
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        sender.setTitle(buttonTitle, for: .normal)
    }
    fileprivate func setupTheme() {
        view.theme.backgroundColor = themed { $0.backgroundColor }
        themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
        MainLabel.theme.textColor = themed{ $0.navigationTintColor }
        backView.theme.tintColor = themed{ $0.navigationTintColor }
     }
}


extension QRScannerViewController: QRScannerViewDelegate {
    func qrScanningDidStop() {
//        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
//        scanButton.setTitle(buttonTitle, for: .normal)
    }
    
    func qrScanningDidFail() {
        presentAlert(withTitle: "Error", message: "Scanning Failed. Please try again")
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
    }
    
    
    
}

