//
//  PopupViewController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 12/08/2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    var labelLanguage = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth/2), height: 60))
    var labelLanguageMain = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth/2, height: screenHeight/2))
    var strel = UIImageView(image: UIImage(named: "strel.png")!)
    @IBOutlet weak var POP: UIView!
    let VCMenu = UIView()
    var container = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moveIn()
        menuLoad()
    }
    func menuLoad() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        let cellHeight = 70
        var y = 10
        VCMenu.frame = CGRect(x: 0, y: 0, width: 0, height: screenHeight)
        container = UIView(frame: CGRect(x: 50, y: Int(screenWidth-100), width: Int(screenWidth - 40), height: 280))
        var withLine = 123
        for (i, i2) in menuSide.enumerated() {
            if i2.name == "Выбор языка"{
                withLine = 180
                strel.frame = CGRect(x: 242, y: y + Int(screenWidth-115), width: 39, height: 12)
                self.view.addSubview(strel)
            }
            if i2.name == "USB"{
                withLine = withLine / 2
            }

            let title = UILabel(frame: CGRect(x: 50, y: y + Int(screenWidth-140), width: Int(screenWidth/2+20), height: 60))
            let redLine = UIView(frame: CGRect(x: 0, y: y + 15, width: withLine, height: 2))
            redLine.backgroundColor = UIColor(rgb: 0xCF2121)
            title.text = i2.name
            title.textColor = .black
            title.font = UIFont(name:"FuturaPT-Light", size: 36.0)

            view.addSubview(title)
            container.addSubview(redLine)
            
            VCMenu.addSubview(container)
            view.addSubview(VCMenu)
            title.addTapGesture {
                print("I: \(i2), \(i)")
                if i == 0 {
                    IsBLE = true
                }
                if i == 1 {
                    IsBLE = false
                }
                if i == 2 {
                    if self.strel.image == UIImage(named: "strel.png"){
                        y = 200
                        title.font = UIFont(name:"FuturaPT-Medium", size: 36.0)
                        self.strel.image = UIImage(named: "strela2.png")
                        for (_,j2) in languages.enumerated() {
                            self.labelLanguage = UILabel(frame: CGRect(x: 73, y: y + Int(screenWidth-140), width: Int(screenWidth/2), height: 60))
                            self.labelLanguage.text = j2.name
                            self.labelLanguage.textColor = .black
                            self.labelLanguage.font = UIFont(name:"FuturaPT-Light", size: 24.0)
                            self.labelLanguageMain.addSubview(self.labelLanguage)
                            self.view.addSubview(self.labelLanguageMain)
//                            self.view.addSubview(self.labelLanguage)
                            y = y + cellHeight - 20
                        }
                    } else {
                        title.font = UIFont(name:"FuturaPT-Light", size: 36.0)
                        self.strel.image = UIImage(named: "strel.png")
                        
                            self.labelLanguageMain.removeFromSuperview()
                        
                        
                    }
                }
                if i == 1 || i == 0 {
                    if let navController = self.navigationController {
                        navController.pushViewController(IsBLE ? DeviceSelectController() : DeviceSelectController() , animated: true)
                    }
                }
            }
            
//                DeviceIndex = i
//                print(title)
//                if let navController = self.navigationController {
//                    navController.pushViewController(ConnectionSelectController(), animated: true)
//                }
//            }
            y = y + cellHeight
        }
    }
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
            if sender.state == .ended {
                switch sender.direction {
                case .left:
                        print("Left")
                        moveOut()
                        rightCount -= 1
                default:
                    break
                }
        }
    }
    func moveIn() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

            self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            self.view.alpha = 0.0
            
            UIView.animate(withDuration: 0.24) {
                self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.view.alpha = 1.0
            }
        }
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    func moveOut() {
            UIView.animate(withDuration: 0.24, animations: {
                self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
                self.view.alpha = 0.0
            }) { _ in
                self.view.removeFromSuperview()
            }
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
