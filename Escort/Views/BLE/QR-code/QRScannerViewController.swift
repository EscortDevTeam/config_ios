//
//  ScannerViewController.swift
//  Escort
//
//  Created by Володя Зверев on 29.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

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
                print("qrData?.codeString?\(qrData?.codeString)")
                let tdstcount = qrData?.codeString?.count
                if let pruf = qrData?.codeString {
                    if pruf.contains("https://www.fmeter.ru/") {
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
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !scannerView.isRunning {
            scannerView.startScanning()
        }
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

