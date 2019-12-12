//
//  TarirovkaStartViewControllet.swift
//  Escort
//
//  Created by Володя Зверев on 25.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import UIDrawer
import MobileCoreServices

class TarirovkaStartViewControllet: UIViewController, SecondVCDelegate {
    func secondVC_BackClicked(data: String) {
        viewShow()
    }
    let DeviceSelectCUSB = DeviceSelectControllerUSB()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        viewShow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        warning = false
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
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
        view.backgroundColor = .white
        var h = 0
        
        
        let (headerView, backView) = headerSet(title: "Tank calibration".localized(code), showBack: true)
        view.addSubview(headerView)
        view.addSubview(backView!)
        backView!.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
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
            chekOpen = true
            self.navigationController?.pushViewController(TarirovkaSettingsViewController(), animated: true)

            
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
                    chekOpen = false
                    let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePlainText as String], in: .import)
                    documentPicker.delegate = self
                    documentPicker.allowsMultipleSelection = false
                    self.present(documentPicker, animated: true, completion: nil)
                }
        
        view.addSubview(v1)
        view.addSubview(v2)
    }
}
extension TarirovkaStartViewControllet: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let selectedFileURL = urls.first else {
            return
        }
        sandboxFileURLPath = selectedFileURL.absoluteURL
//        print(sandboxFileURLPath!.path.dropLast(Int((sandboxFileURLPath?.path.count)!)+3))
//        print(sandboxFileURLPath)
        if chekOpen == true {
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
            sandboxFileURLPath = dir
            print(sandboxFileURLPath!.path)
            print(sandboxFileURL.path)
            self.navigationController?.pushViewController(TarirovkaSettingsViewController(), animated: true)
        } else {
            do {
                let applicationURLs = FileManager.default.urls(for: .applicationDirectory, in: .allDomainsMask)
                print(applicationURLs)
                print(textName.count)
                let contents = try String(contentsOfFile: selectedFileURL.path)
                print(selectedFileURL.path)
                let cont = contents.split(separator: "\n")
                print(cont.count)
                var checkSliv = 0
                for i in 0...cont.count-1 {
                    let rom = cont[i].split(separator: ",")
                    let a = rom[1].split(separator: " ")
                    if i == 0 {
                        checkSliv = Int(String(rom[0]))!
                    }
                    if i == 1 {
                        if Int(String(rom[0]))! > checkSliv{
                            sliv = true
                        } else {
                            sliv = false
                        }
                    }
                    itemsT.append("\(rom[0])")
                    levelnumberT.append("\(a[0])")
                    print("items: \(rom[0])" + " levelnumber: \(a[0])")
                }
                tarNew = false
                let nameSave = selectedFileURL.path
                let nameSaveMassiv = nameSave.split(separator: "/")
                let nameLast = nameSaveMassiv.last!.split(separator: ".")
                textName = "\(String(describing: nameLast.first!))"
                alertSliv()
                
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
    func alert() {
        let alertController = UIAlertController(title: "Make changes".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
        let labelLits = UILabel(frame: CGRect(x: 25, y: 40, width: 100, height: 30))
        labelLits.text = "Step".localized(code)
        labelLits.alpha = 0.58
        labelLits.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 220)
        
        alertController.view.addConstraint(height)
        
        let firstTextField = UITextField(frame: CGRect(x: 20, y: 70, width: view.frame.width/3*2-40, height: 30))
        firstTextField.text = ""
        firstTextField.keyboardType = .numberPad
        firstTextField.layer.cornerRadius = 5
        firstTextField.layer.borderWidth = 1
        firstTextField.layer.borderColor = UIColor(named: "Color")!.cgColor
        firstTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: firstTextField.frame.height))
        firstTextField.leftViewMode = .always
        
        let labelLevel = UILabel(frame: CGRect(x: 25, y: 100, width: 200, height: 30))
        labelLevel.text = "Initial tank volume".localized(code)
        labelLevel.alpha = 0.58
        labelLevel.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        
        let secondTextField = UITextField(frame: CGRect(x: 20, y: 130, width: view.frame.width/3*2-40, height: 30))
        secondTextField.text = ""
        secondTextField.keyboardType = .numberPad
        secondTextField.layer.cornerRadius = 5
        secondTextField.layer.borderWidth = 1
        secondTextField.layer.borderColor = UIColor(named: "Color")?.cgColor
        secondTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: secondTextField.frame.height))
        secondTextField.leftViewMode = .always
        let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        let saveAction = UIAlertAction(title: "Save".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
            stepTar = Int(String(firstTextField.text!)) ?? 0
            startVTar = Int(String(secondTextField.text!)) ?? 0
            self.navigationController?.pushViewController(TirirovkaTableViewController(), animated: true)

        })
        
        
        alertController.view.addSubview(labelLits)
        alertController.view.addSubview(labelLevel)
        alertController.view.addSubview(firstTextField)
        alertController.view.addSubview(secondTextField)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func alertZaliv() {
        let alertController = UIAlertController(title: "Make changes".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
        let labelLits = UILabel(frame: CGRect(x: 25, y: 40, width: 100, height: 30))
        labelLits.text = "Step".localized(code)
        labelLits.alpha = 0.58
        labelLits.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 160)
        
        alertController.view.addConstraint(height)
        
        let firstTextField = UITextField(frame: CGRect(x: 20, y: 70, width: view.frame.width/3*2-40, height: 30))
        firstTextField.text = ""
        firstTextField.keyboardType = .numberPad
        firstTextField.layer.cornerRadius = 5
        firstTextField.layer.borderWidth = 1
        firstTextField.layer.borderColor = UIColor(named: "Color")!.cgColor
        firstTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: firstTextField.frame.height))
        firstTextField.leftViewMode = .always

        let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        let saveAction = UIAlertAction(title: "Save".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
            stepTar = Int(String(firstTextField.text!)) ?? 0
            self.navigationController?.pushViewController(TirirovkaTableViewController(), animated: true)

        })
        
        
        alertController.view.addSubview(labelLits)
        alertController.view.addSubview(firstTextField)
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func alertSliv() {
        let alertController = UIAlertController(title: "Make changes".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
        let slivButton = UIButton(frame: CGRect(x: 20, y: 50, width: view.frame.width/3*2-40, height: 50))
        let zalivButton = UIButton(frame: CGRect(x: 20, y: 110, width: view.frame.width/3*2-40, height: 50))

        if sliv == true {
            slivButton.layer.cornerRadius = 20
            slivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            slivButton.setTitle("Draining".localized(code), for: UIControl.State.normal)
            slivButton.setTitleColor(UIColor(named: "Color-1"), for: UIControl.State.normal)
            
            zalivButton.layer.cornerRadius = 20
            zalivButton.layer.borderWidth = 1
            zalivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            zalivButton.setTitle("Filing".localized(code), for: UIControl.State.normal)
            zalivButton.setTitleColor(UIColor(named: "Color-1"), for: UIControl.State.normal)
        } else {
            zalivButton.layer.cornerRadius = 20
            zalivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            zalivButton.setTitle("Filing".localized(code), for: UIControl.State.normal)
            zalivButton.setTitleColor(UIColor(named: "Color-1"), for: UIControl.State.normal)
            
            slivButton.layer.cornerRadius = 20
            slivButton.layer.borderWidth = 1
            slivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            slivButton.setTitle("Draining".localized(code), for: UIControl.State.normal)
            slivButton.setTitleColor(UIColor(named: "Color-1"), for: UIControl.State.normal)
        }
        slivButton.addTapGesture {
            slivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            slivButton.layer.borderWidth = 0
            zalivButton.layer.borderWidth = 1
            zalivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            zalivButton.backgroundColor = .clear
            sliv = true
        }
        zalivButton.addTapGesture {
            zalivButton.backgroundColor = UIColor(rgb: 0xCF2121)
            zalivButton.layer.borderWidth = 0
            slivButton.layer.borderWidth = 1
            slivButton.layer.borderColor = UIColor(rgb: 0x959595).cgColor
            slivButton.backgroundColor = .clear
            sliv = false
        }

        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 220)
        
        alertController.view.addConstraint(height)

        let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        let saveAction = UIAlertAction(title: "Save".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
            if sliv == true {
                self.alert()
            } else {
                self.alertZaliv()
            }

        })
        
        
        alertController.view.addSubview(slivButton)
        alertController.view.addSubview(zalivButton)

        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
