//
//  Charts.swift
//  Escort
//
//  Created by Володя Зверев on 09.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.


import UIKit
import SwiftChart

class Charts: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        warning = false
    }
    override func viewDidAppear(_ animated: Bool) {

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
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()
    
    private func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewShowTwo()
        }
    }
    private func viewShowTwo() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.addSubview(bgImage)
        let (headerView, backView) = headerSetMenu(title:"Tank calibration chart".localized(code), showBack: true)
        view.addSubview(headerView)
        if iphone5s {
            view.addSubview(backView!)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.activityIndicator.stopAnimating()
            backView!.addTapGesture{
                let  vc =  self.navigationController?.viewControllers.filter({$0 is TirirovkaTableViewController}).first
                self.navigationController?.popToViewController(vc!, animated: true)
            }
            
            let chart = Chart(frame: CGRect(x: 50, y: 200, width: screenWidth-100, height: screenHeight/2))
//            chart.axesColor = .white
            chart.highlightLineColor = .white
            chart.minY = 0
            
            chart.labelColor = .white
            let series = ChartSeries([])
            series.color = UIColor(rgb: 0x00A778)
            for i in 0...itemsC.count-1 {
//                series.data = [(x: 0.0, y: 0.0),(x: 20.0, y: 80.0),(x: 40.0, y: 100.0),(x: 60.0, y: 95.0),(x: 340, y: 1023)]
                if sliv == true {
                    series.data.append((x: -Double(itemsC[i])!, y: Double(levelnumberC[i])!))
                } else {
                    series.data.append((x: Double(itemsC[i])!, y: Double(levelnumberC[i])!))
                }
            }
            chart.add(series)
            self.view.addSubview(chart)
            
            let lineVert = UIView(frame: CGRect(x: 49, y: 180, width: 2, height: screenHeight/2))
            lineVert.backgroundColor = UIColor(rgb: 0xFFFFFF)
            self.view.addSubview(lineVert)
            lineVert.alpha = 0.74

            
            let lineImage = UIImageView(frame: CGRect(x: 0, y: 173, width: 18.5, height: 7.5))
            lineImage.center.x = 50
            lineImage.image = #imageLiteral(resourceName: "Vector 2.6")
            self.view.addSubview(lineImage)
            
            let lineVert2 = UIView(frame: CGRect(x: 49, y: screenHeight/2+180, width: screenWidth-80, height: 2))
            lineVert2.backgroundColor = UIColor(rgb: 0xFFFFFF)
            lineVert2.alpha = 0.74
            self.view.addSubview(lineVert2)
            
            let lineImage2 = UIImageView(frame: CGRect(x: screenWidth-31, y: 0, width: 7.5, height: 18.5))
            lineImage2.center.y = screenHeight/2+181
            lineImage2.image = #imageLiteral(resourceName: "Vector 2.7")
            self.view.addSubview(lineImage2)
            let viewAll = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
            viewAll.backgroundColor = .clear
            self.view.addSubview(viewAll)
        }
    }
}
