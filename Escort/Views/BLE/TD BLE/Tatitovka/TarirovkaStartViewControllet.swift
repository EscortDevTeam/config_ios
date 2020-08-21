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
import UIDrawer

class TarirovkaStartViewControllet: UIViewController {
    func secondVC_BackClicked(data: String) {
        viewShow()
    }
    let DeviceSelectCUSB = DeviceSelectControllerUSB()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        viewShow()
        setupTheme()
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
        text.text = "Tank calibration".localized(code)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
    }()
    lazy var btTitle1: UILabel = {
        let btTitle1 = UILabel(frame: CGRect(x: 120, y: 36, width: screenWidth, height: 36))
        btTitle1.frame.origin.x = screenWidth/2-50
        btTitle1.text = "Start".localized(code)
        btTitle1.font = UIFont(name:"FuturaPT-Light", size: iphone5s ? 38.0 :42.0)
        return btTitle1
    }()
    lazy var btTitle2: UILabel = {
        let btTitle2 = UILabel(frame: CGRect(x: 160, y: 16, width: screenWidth, height: 36))
        btTitle2.frame.origin.x = screenWidth/2-50
        btTitle2.text = "Continue".localized(code)
        btTitle2.font = UIFont(name:"FuturaPT-Light", size: iphone5s ? 38.0 :42.0)
        return btTitle2
    }()
    lazy var btTitle3: UILabel = {
        let btTitle1 = UILabel(frame: CGRect(x: 40, y: 36, width: screenWidth-80, height: 70))
        btTitle1.text = "The file will be saved in the application \"Files\", in the folder \"Escort\"".localized(code)
        btTitle1.numberOfLines = 0
        btTitle1.textAlignment = .center
        btTitle1.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return btTitle1
    }()
    lazy var btTitle4: UILabel = {
        let btTitle2 = UILabel(frame: CGRect(x: 40, y: 16, width: screenWidth-80, height: 50))
        btTitle2.numberOfLines = 0
        btTitle2.textAlignment = .center
        btTitle2.text = "Open the previously created calibration file".localized(code)
        btTitle2.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        return btTitle2
    }()
    fileprivate lazy var separator: UIView = {
        let separator = UIView(frame: CGRect(x: 0, y: Int(headerHeight)  + Int((screenHeight - headerHeight) / 2), width: Int(screenWidth), height: 1))
        separator.alpha = 0.1
        return separator
    }()
    fileprivate lazy var btImage1: UIImageView = {
        let btImage1 = UIImageView(image: #imageLiteral(resourceName: "startT"))
        btImage1.frame = CGRect(x: 40, y: 0, width: (iphone5s ? 60 : 70), height: (iphone5s ? 60 : 70))
        btImage1.image = btImage1.image!.withRenderingMode(.alwaysTemplate)
        return btImage1
    }()
    fileprivate lazy var btImage2: UIImageView = {
        let btImage2 = UIImageView(image: #imageLiteral(resourceName: "continT"))
        btImage2.frame = CGRect(x: 40, y: 0, width: (iphone5s ? 60 : 70), height: (iphone5s ? 50 : 60))
        btImage2.image = btImage2.image!.withRenderingMode(.alwaysTemplate)
        return btImage2
    }()
    fileprivate lazy var firstTextField: UITextField = {
        let firstTextField = UITextField(frame: CGRect(x: 20, y: 70, width: view.frame.width/3*2-40, height: 30))
        firstTextField.text = ""
        firstTextField.keyboardType = .numberPad
        firstTextField.layer.cornerRadius = 5
        firstTextField.inputAccessoryView = self.toolBar()
        firstTextField.layer.borderWidth = 1
        firstTextField.layer.borderColor = UIColor(named: "Color")!.cgColor
        firstTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: firstTextField.frame.height))
        firstTextField.leftViewMode = .always
        return firstTextField
    }()
    fileprivate lazy var secondTextField: UITextField = {
        let secondTextField = UITextField(frame: CGRect(x: 20, y: 130, width: view.frame.width/3*2-40, height: 30))
        secondTextField.text = ""
        secondTextField.keyboardType = .numberPad
        secondTextField.layer.cornerRadius = 5
        secondTextField.inputAccessoryView = self.toolBar()
        secondTextField.layer.borderWidth = 1
        secondTextField.layer.borderColor = UIColor(named: "Color")?.cgColor
        secondTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: secondTextField.frame.height))
        secondTextField.leftViewMode = .always
        return secondTextField
    }()
    fileprivate lazy var firstTextFieldOne: UITextField = {
        let firstTextField = UITextField(frame: CGRect(x: 20, y: 70, width: view.frame.width/3*2-40, height: 30))
        firstTextField.text = ""
        firstTextField.keyboardType = .numberPad
        firstTextField.layer.cornerRadius = 5
        firstTextField.layer.borderWidth = 1
        firstTextField.inputAccessoryView = self.toolBar()
        firstTextField.layer.borderColor = UIColor(named: "Color")!.cgColor
        firstTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: firstTextField.frame.height))
        firstTextField.leftViewMode = .always
        return firstTextField
    }()
    private func viewShow() {
        
        view.addSubview(themeBackView3)
        MainLabel.text = "Tank calibration".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)

        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        
        let cellHeight = Int((screenHeight - headerHeight) / 2)
        let v1 = UIView()

        btImage1.center.y = CGFloat(cellHeight/2)
        btTitle1.center.y = CGFloat(cellHeight/2)
        btTitle3.center.y = CGFloat(cellHeight/2+60)
        v1.addSubview(btTitle3)
        v1.addSubview(btImage1)
        v1.addSubview(btTitle1)

        v1.frame = CGRect(x:0, y: Int(headerHeight), width: Int(screenWidth), height: cellHeight)
        v1.addTapGesture{
            chekOpen = true
            self.navigationController?.pushViewController(TarirovkaSettingsViewController(), animated: true)

            
        }
        view.addSubview(separator)
        
        // Continue
        
        let v2 = UIView()
        btImage2.center.y = CGFloat(cellHeight/2)
        btTitle2.center.y = CGFloat(cellHeight/2)
        btTitle4.center.y = CGFloat(cellHeight/2+60)
        v2.addSubview(btTitle4)
        v2.addSubview(btImage2)
        v2.addSubview(btTitle2)
        v2.frame = CGRect(x:0, y: Int(headerHeight) + cellHeight, width: Int(screenWidth), height: cellHeight)
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
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            btTitle1.theme.textColor = themed{ $0.navigationTintColor }
            btTitle2.theme.textColor = themed{ $0.navigationTintColor }
            btTitle3.theme.textColor = themed{ $0.navigationTintColor }
            btTitle4.theme.textColor = themed{ $0.navigationTintColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            separator.theme.backgroundColor = themed { $0.navigationTintColor }
            btImage2.theme.tintColor = themed{ $0.navigationTintColor }
            btImage1.theme.tintColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            btTitle1.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            btTitle2.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            btTitle3.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            btTitle4.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            separator.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            btImage2.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            btImage1.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
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
        
        let labelLevel = UILabel(frame: CGRect(x: 25, y: 100, width: 200, height: 30))
        labelLevel.text = "Initial tank volume".localized(code)
        labelLevel.alpha = 0.58
        labelLevel.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        let saveAction = UIAlertAction(title: "Save".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
            stepTar = Int(String(self.firstTextFieldOne.text!)) ?? 0
            startVTar = Int(String(self.secondTextField.text!)) ?? 0
            self.navigationController?.pushViewController(TirirovkaTableViewController(), animated: true)

        })
        
        
        alertController.view.addSubview(labelLits)
        alertController.view.addSubview(labelLevel)
        alertController.view.addSubview(firstTextFieldOne)
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

        let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        let saveAction = UIAlertAction(title: "Save".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
            stepTar = Int(String(self.firstTextField.text!)) ?? 0
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
    fileprivate func toolBar() -> UIToolbar {
        let bar = UIToolbar()
        let reset = UIBarButtonItem(barButtonSystemItem: .flexibleSpace , target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done".localized(code), style: .done, target: self, action: #selector(resetTapped))
        bar.setItems([reset,done], animated: false)
        bar.sizeToFit()
        return bar
    }
    @objc func resetTapped() {
        secondTextField.endEditing(true)
        firstTextField.endEditing(true)
        firstTextFieldOne.endEditing(true)
    }
}

extension TarirovkaStartViewControllet: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark)
    }
}
