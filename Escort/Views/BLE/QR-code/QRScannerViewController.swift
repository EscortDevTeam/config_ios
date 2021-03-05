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
                        if pruf.contains("https://www.fmeter.ru/") {
                            if pruf.contains("https://www.fmeter.ru/TD/") {
                                let tdstring = pruf.dropFirst(tdstcount!-6)
                                print(tdstring)
                                hidednCell = true
                                self.navigationController?.pushViewController(DevicesListControllerNew(), animated: true)
                                QRCODE = String(tdstring)
                            } else if pruf.contains("https://www.fmeter.ru/DU/") {
                                let tdstring = pruf.dropFirst(tdstcount!-6)
                                print(tdstring)
                                hidednCell = true
                                self.navigationController?.pushViewController(DevicesDUController(), animated: true)
                                QRCODE = String(tdstring)
                            } else if pruf.contains("https://www.fmeter.ru/TL/") {
                                let tdstring = pruf.dropFirst(tdstcount!-6)
                                print(tdstring)
                                hidednCell = true
                                let tlListDevicesVC = DevicesTLListController()
                                tlListDevicesVC.isTL = true
                                self.navigationController?.pushViewController(tlListDevicesVC, animated: true)
                                QRCODE = String(tdstring)
                            } else if pruf.contains("https://www.fmeter.ru/TH/") {
                                let tdstring = pruf.dropFirst(tdstcount!-6)
                                print(tdstring)
                                hidednCell = true
                                let tlListDevicesVC = DevicesTLListController()
                                tlListDevicesVC.isTL = false
                                self.navigationController?.pushViewController(tlListDevicesVC, animated: true)
                                QRCODE = String(tdstring)
                            }  else {
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

        setupTheme()

    }
    @objc func lightOn() {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if device!.hasTorch {
            do {
                try device!.lockForConfiguration()
                device!.torchMode = device!.torchMode == AVCaptureDevice.TorchMode.on ? .off : .on
                device!.unlockForConfiguration()
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
        navigationCusmotizing(nav: navigationController!, navItem: navigationItem, title: "QR-CODE")
        let img = (isNight ? #imageLiteral(resourceName: "LanternWhite") : #imageLiteral(resourceName: "Lantern") ).withRenderingMode(.alwaysOriginal)
        let rightButton = UIBarButtonItem(image: img,
                                          style: UIBarButtonItem.Style.plain,
                                              target: self,
                                              action: #selector(lightOn))
        navigationItem.rightBarButtonItem = rightButton

        if checkPopQR == true {
            showToast(message: "Не удалось подключиться", seconds: 2.0)
            checkPopQR = false
        }
        checkQR = false
        QRCODE = ""
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
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
        }
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

