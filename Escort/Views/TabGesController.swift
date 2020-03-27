//
//  TabGesController.swift
//  Escort
//
//  Created by Володя Зверев on 05.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
var imageX = 55.0
var imageY = 25.0

class TabGesController: UIViewController {
    let panGestureRecognizer = UIPanGestureRecognizer()
    var panGestureAnchorPoint: CGPoint?
    
    fileprivate lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "WhatsApp Image 2020-02-05 at 11.46.18 (1)")
        image.frame = CGRect(x: 0, y: 0, width: Int(screenWidth), height: 250)
        return image
    }()
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.alpha = 0.3
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()
    
    fileprivate lazy var imageVIew: UIView = {
        let image = UIView()
        image.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.center.x = CGFloat(imageX)
        image.center.y = CGFloat(imageY)
        let imageV = UIImageView()
        imageV.image = #imageLiteral(resourceName: "logoGes")
        imageV.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.addSubview(imageV)
        let label = UILabel()
        label.frame = CGRect(x: -27, y: 50, width: 100, height: 20)
        label.text = "Место установки"
        label.textAlignment = .center
        label.font = UIFont(name:"FuturaPT-Medium", size: 14.0)
        label.textColor = .red
        image.addSubview(label)
        return image
    }()
    
    fileprivate lazy var labelMain: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 200 - (iphone5s ? 100 : 0), width: screenWidth-100, height: 90)
        label.text = "Возьмите и перетяните иконку на место установки трекера"
        label.font = UIFont(name:"FuturaPT-Light", size: 20.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.center.x = screenWidth/2
        return label
    }()
    
    fileprivate lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.frame = CGRect(x: 0, y: 300 - (iphone5s ? 100 : 0), width: screenWidth, height: 250)
        return uiView
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
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-60), height: 40))
        text.text = "Type of bluetooth sensor".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17 : 19))
        return text
    }()
    
    fileprivate lazy var uiView2: UIView = {
        let uiView = UIView()
        uiView.frame = CGRect(x: 0, y: hasNotch ? screenHeight - 100: screenHeight/4*3, width: screenWidth/2, height: 46)
        uiView.backgroundColor = UIColor(rgb: 0xE80000)
        uiView.center.x = screenWidth/2
        uiView.layer.cornerRadius = 8
        let textView = UILabel()
        textView.frame = CGRect(x: 0, y: 0, width: screenWidth/2, height: 46)
        textView.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        textView.text = "Далее".localized(code)
        textView.textColor = .white
        textView.textAlignment = .center
        textView.center.x = uiView.bounds.width/2
        uiView.addSubview(textView)
        return uiView
    }()
    let generator = UIImpactFeedbackGenerator(style: .light)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(themeBackView3)

        MainLabel.text = "Фото места установки".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(bgImage)
        view.addSubview(backView)
        
        view.backgroundColor = .gray
        uiView.addSubview(image)
        uiView.addSubview(imageVIew)
        view.addSubview(uiView)
        view.addSubview(uiView2)
        view.addSubview(labelMain)
        
        backView.addTapGesture{
            self.generator.impactOccurred()
            self.dismiss(animated: true, completion: nil)
        }
        uiView2.addTapGesture {
            let renderer = UIGraphicsImageRenderer(size: self.uiView.bounds.size)
            let image = renderer.image { ctx in
                self.uiView.drawHierarchy(in: self.uiView.bounds, afterScreenUpdates: true)
            }
            if photoALLPlace.count > 1 {
                if photoALLPlace.first == UIImage(named: "Group 29-2") || photoALLPlace.first == UIImage(named: "Group 29-2N") {
                    photoALLPlace[1] = image
                } else {
                    photoALLPlace[0] = image
                }
            } else {
                photoALLPlace.append(image)
            }
            photoALLPlaceChech = image
//            self.image.image = image
            self.generator.impactOccurred()
            if let imageData = image.jpeg(.lowest) {
                UserDefaults.standard.set(imageData, forKey: "photoALLPlace_1")
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.maximumNumberOfTouches = 1 // (1)
        imageVIew.addGestureRecognizer(panGestureRecognizer)
        
        setupTheme()
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard panGestureRecognizer === gestureRecognizer else { assert(false); return }
        
        switch gestureRecognizer.state {
        case .began:
            self.generator.impactOccurred()
            assert(panGestureAnchorPoint == nil)
            panGestureAnchorPoint = gestureRecognizer.location(in: view) // (2)
        case .changed:
            guard let panGestureAnchorPoint = panGestureAnchorPoint else { assert(false); return }
            
            var gesturePoint = gestureRecognizer.location(in: view)
            
            // (3)
            print("panGestureAnchorPoint: \(panGestureAnchorPoint)")
            print("gesturePoint: \(gesturePoint)")

                if imageVIew.frame.origin.y >= 0 {
                    if gesturePoint.y >= 300 - (iphone5s ? 100 : 0) {
                        imageVIew.center.y = gesturePoint.y - 290 + (iphone5s ? 100 : 0)
                        imageY = Double(imageVIew.center.y)
                    } else {
                        gesturePoint.y = 300 - (iphone5s ? 100 : 0)
                        imageVIew.center.y = gesturePoint.y - 290 + (iphone5s ? 100 : 0)
                        imageY = Double(imageVIew.center.y)
                    }
                } else {
                    imageVIew.frame.origin.y = 0
                }
            if imageVIew.frame.origin.y <= 183 {
                if gesturePoint.y <= 500 - (iphone5s ? 100 : 0) {
                    imageVIew.center.y = gesturePoint.y - 275 + (iphone5s ? 100 : 0)
                    imageY = Double(imageVIew.center.y)

                } else {
                    gesturePoint.y = 500 - (iphone5s ? 100 : 0)
                    imageVIew.center.y = gesturePoint.y - 275 + (iphone5s ? 100 : 0)
                    imageY = Double(imageVIew.center.y)
                }
            } else {
                imageVIew.frame.origin.y = 183
                imageY = Double(imageVIew.frame.origin.y)
            }
            
            if imageVIew.frame.origin.x >= 27 {
                if gesturePoint.x >= 52 {
                    imageVIew.center.x = gesturePoint.x
                    imageX = Double(imageVIew.frame.origin.x)
                } else {
                    gesturePoint.x = 52
                    imageVIew.center.x = gesturePoint.x
                }
            } else {
                imageVIew.frame.origin.x = 27
            }
            
            if imageVIew.frame.origin.x <= screenWidth - 80 {
                if gesturePoint.x <= screenWidth {
                    imageVIew.center.x = gesturePoint.x
                    imageX = Double(imageVIew.frame.origin.x)
                } else {
                    gesturePoint.x = screenWidth
                    imageVIew.center.x = gesturePoint.x
                }
            } else {
                imageVIew.frame.origin.x = screenWidth - 80
            }

            
//            if gesturePoint.y <= 500 && gesturePoint.y >= 300 {
//                imageVIew.center.y += gesturePoint.y - panGestureAnchorPoint.y
//                imageY = Double(gesturePoint.y - 300)
//            }
//            imageVIew.center.x += gesturePoint.x - panGestureAnchorPoint.x
//            imageX = Double(gesturePoint.x)
//            self.panGestureAnchorPoint = gesturePoint

            
        case .cancelled, .ended:
            self.generator.impactOccurred()
            panGestureAnchorPoint = nil
            
        case .failed, .possible:
            assert(panGestureAnchorPoint == nil)
            break
        @unknown default:
            fatalError()
        }
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            labelMain.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelMain.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)

        }
    }
}
