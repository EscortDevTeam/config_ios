//
//  DetailViewController.swift
//  Escort
//
//  Created by Володя Зверев on 29.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailLabel: CopyLabel!
    
    var qrData: QRData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = qrData?.codeString
        let tdstcount = qrData?.codeString?.count
        let tdstring = qrData?.codeString!.dropFirst(tdstcount!-6)
        print(tdstring!)
        UIPasteboard.general.string = detailLabel.text
        showToast(message : "Text copied to clipboard")

    }

    @IBAction func openInWebAction(_ sender: Any) {
        if let url = URL(string: qrData?.codeString ?? ""), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        } else {
            showToast(message : "Not a valid URL")
        }
    }
}
