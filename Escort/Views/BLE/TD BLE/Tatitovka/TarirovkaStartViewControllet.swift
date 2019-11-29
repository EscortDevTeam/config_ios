//
//  TarirovkaStartViewControllet.swift
//  Escort
//
//  Created by Володя Зверев on 25.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class TarirovkaStartViewControllet: UIViewController, SecondVCDelegate {
    func secondVC_BackClicked(data: String) {
        viewShow()
    }
    let DeviceSelectCUSB = DeviceSelectControllerUSB()
    let DeviceSelectC = DeviceSelectController()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activity.center = view.center
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    
    private func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = .white
        var h = 0
        
        
        view.addSubview(headerSet(title: "Tank calibration".localized(code)))
        let cellHeight = Int((screenHeight - headerHeight) / 2)
        var con = tarirovkas[0]
        let v1 = UIView()
        let btImage1 = UIImageView(image: UIImage(named: con.image)!)
        btImage1.frame = CGRect(x: 49, y: 0, width: 57, height: 57)
        btImage1.tintColor = .green
        let btTitle1 = UILabel(frame: CGRect(x: 139, y: 12, width: screenWidth, height: 36))
        btTitle1.text = con.name
        btTitle1.textColor = UIColor(rgb: 0x1F1F1F)
        btTitle1.font = UIFont(name:"FuturaPT-Light", size: 36.0)
        
        v1.addSubview(btImage1)
        v1.addSubview(btTitle1)
        
        h = (cellHeight - Int(btImage1.frame.height)) / 2
//        v1.frame = CGRect(x:0, y: Int(headerHeight)+h, width: Int(screenWidth), height: Int(screenHeight))
        v1.frame = CGRect(x:0, y: Int(headerHeight) + h, width: Int(screenWidth), height: cellHeight-h)
        v1.addTapGesture{
            boolBLE = true
            
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
        
        con = tarirovkas[1]
        let v2 = UIView()
        let btImage2 = UIImageView(image: UIImage(named: con.image)!)
        btImage2.frame = CGRect(x: 49, y: 0, width: 57, height: 47)
        let btTitle2 = UILabel(frame: CGRect(x: 139, y: 4, width: screenWidth, height: 36))
        btTitle2.text = con.name
        btTitle2.textColor = UIColor(rgb: 0x1F1F1F)
        btTitle2.font = UIFont(name:"FuturaPT-Light", size: 36.0)

        v2.addSubview(btImage2)
        v2.addSubview(btTitle2)
        
        h = (cellHeight - Int(btImage2.frame.height)) / 2
        
        v2.frame = CGRect(x:0, y: Int(headerHeight) + cellHeight + h, width: Int(screenWidth), height: cellHeight-h)
                v2.addTapGesture{
                    boolBLE = false
                    IsBLE = false
                    self.navigationController?.pushViewController(self.DeviceSelectCUSB, animated: true)
                }
        
        view.addSubview(v1)
        view.addSubview(v2)
    }
}
