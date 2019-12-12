//
//  DeviceListUsbController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 09/08/2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import ExternalAccessory

class DevicesListUsbController: UIViewController {

    var openDevices = "Доступные устройства"
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        
        viewShow()
    }
    @objc func refresh(sender:AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()

    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .white
        }
        activity.center = view.center
        activity.color = .white
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()

    private func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        
        let (headerView, backView) = headerSet(title: "\(openDevices)", showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(bgImage)
        view.addSubview(activityIndicator)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.activityIndicator.stopAnimating()
            self.mainPartShow()
            
        }
        
    }
    
    private func mainPartShow() {
        let data = devices
        scrollView.addSubview(refreshControl)
        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        let cellHeight = 60
        var y = 20
        
        for (i, peripheral) in data.enumerated() {
             
            let container = UIView(frame: CGRect(x: 20, y: y, width: Int(screenWidth - 40), height: cellHeight))
            
            let title = UILabel(frame: CGRect(x: 0, y: 20, width: Int(screenWidth/2), height: 20))
            title.text = peripheral.name

            title.textColor = .white
            title.font = UIFont(name:"FuturaPT-Light", size: 24.0)
            
            let btn = UIView(frame: CGRect(x: Int(screenWidth-140-40), y: 8, width: 140, height: 44))
            btn.backgroundColor = UIColor(rgb: 0xCF2121)
            btn.layer.cornerRadius = 22
            
            let connect = UILabel(frame: CGRect(x: Int(btn.frame.origin.x), y: Int(btn.frame.origin.y), width: Int(btn.frame.width), height: Int(btn.frame.height)))
            connect.text = "Connect"
            connect.textColor = .white
            connect.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            connect.textAlignment = .center
            
            let separator = UIView(frame: CGRect(x: 0, y: cellHeight, width: Int(screenWidth-40), height: 1))
            separator.backgroundColor = UIColor(rgb: 0x959595)
            
            container.addSubview(btn)
            container.addSubview(connect)
            container.addSubview(title)
            container.addSubview(separator)
            
            scrollView.addSubview(container)
            scrollView.bringSubviewToFront(container)
            
            connect.addTapGesture {
                
                DeviceIndex = i
                self.activityIndicator.startAnimating()
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    self.activityIndicator.stopAnimating()
                   
                }
                

                
            }
            
            y = y + cellHeight
        }
        
        scrollView.contentSize = CGSize(width: Int(screenWidth), height: data.count * cellHeight + 40)
    }
}
