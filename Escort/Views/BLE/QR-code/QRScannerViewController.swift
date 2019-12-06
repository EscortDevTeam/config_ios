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
    
    var hamburger = UIImageView(image: UIImage(named: "Lantern")!)

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
                        if pruf.contains("https://www.fmeter.ru/") || pruf.contains("https://www.fmeter.ru/td/") {
                            let tdstring = pruf.dropFirst(tdstcount!-6)
                            print(tdstring)
                            self.navigationController?.pushViewController(DevicesListC, animated: true)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let (headerView, backView) = headerSet(title: "QR-CODE", showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        hamburger = UIImageView(image: UIImage(named: "Lantern")!)
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
    }
    func lightOn() {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if device!.hasTorch {
            do {
                try device!.lockForConfiguration()
                device!.torchMode = device!.torchMode == AVCaptureDevice.TorchMode.on ? .off : .on
                device!.unlockForConfiguration()
                hamburger.image = device!.torchMode == AVCaptureDevice.TorchMode.on ? #imageLiteral(resourceName: "LanternRed") : #imageLiteral(resourceName: "Lantern")
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
        hamburger.image = #imageLiteral(resourceName: "Lantern")
        checkQR = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        if !scannerView.isRunning {
//            scannerView.startScanning()
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }

    @IBAction func scanButtonAction(_ sender: UIButton) {
        scannerView.isRunning ? scannerView.stopScanning() : scannerView.startScanning()
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        sender.setTitle(buttonTitle, for: .normal)
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

