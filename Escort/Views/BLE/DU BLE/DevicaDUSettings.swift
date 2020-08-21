//
//  DevicaDUSettings.swift
//  Escort
//
//  Created by Володя Зверев on 03.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//
import UIKit
import UIDrawer
import Lottie

class DevicaDUSettings: UIViewController {
    
    let viewLoad = UIView(frame:CGRect(x: 30, y: headerHeight + 325, width: 200, height: 40))
    let viewLoadTwo = UIView(frame:CGRect(x: 30, y: headerHeight + 415, width: 300, height: 40))
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))

    var timer = Timer()
    let firstTextField = UITextField()
    let secondTextField = UITextField()
    let validatePassword = UILabel()
    var saveAction = UIAlertAction()
    
    let firstTextFieldSecond = UITextField()
    let secondTextFieldSecond = UITextField()
    let validatePasswordSecond = UILabel()
    var saveActionSecond = UIAlertAction()
    
    let ArrayMode: [String] = ["Transportation".localized(code),"Horizontal rotation control".localized(code),"Vertical rotation control".localized(code),"Angle control".localized(code),"Bucket".localized(code),"Plow".localized(code)]
    
    let ArrayModeImage: [UIImage] = [#imageLiteral(resourceName: "транспорт") ,#imageLiteral(resourceName: "контроль угла") ,#imageLiteral(resourceName: "контроль угла") ,#imageLiteral(resourceName: "контроль угла") ,#imageLiteral(resourceName: "ковш"), #imageLiteral(resourceName: "отвал")]
    let ArrayModeImageBlack: [UIImage] = [#imageLiteral(resourceName: "транспорт-black") ,#imageLiteral(resourceName: "контроль угла") ,#imageLiteral(resourceName: "контроль угла") ,#imageLiteral(resourceName: "контроль угла-black") , #imageLiteral(resourceName: "ковш-black"), #imageLiteral(resourceName: "Отвал-black")]
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
                scrollView.contentInset = contentInset
            
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewShow()
        setupTheme()
    }
    override func viewWillAppear(_ animated: Bool) {
        warning = false
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        img.alpha = 0.3
        return img
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.frame = CGRect(x: 0, y: 20, width: screenWidth, height: 200)
        cv.backgroundColor = .clear
        return cv
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
    fileprivate lazy var lblTitle: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle.text = "Minimum level".localized(code)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    
    fileprivate lazy var lblTitle3: UILabel = {
        let lblTitle3 = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle3.text = "Maximum level".localized(code)
        lblTitle3.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle3
    }()
    
    fileprivate lazy var lblTitle4: UILabel = {
        let lblTitle4 = UILabel(frame: CGRect(x: 0, y: 10, width: Int(screenWidth/2), height: 20))
        lblTitle4.text = "Filtration".localized(code)
        lblTitle4.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle4
    }()
    
    fileprivate lazy var termoLabel: UILabel = {
        let termoLabel = UILabel(frame: CGRect(x: 30, y: 40 + Int(headerHeight) + 65*7 + 25, width: Int(screenWidth/2 + 70), height: 20))
        termoLabel.text = "Disable Thermal Compensation".localized(code)
        return termoLabel
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
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-70), height: 40))
        text.text = "Type of bluetooth sensor".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
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
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    private func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })

        view.addSubview(themeBackView3)
        MainLabel.text = "DU BLE Settings".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        
        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(bgImage)
        view.addSubview(scrollView)

        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight + (iphone5s ? 10 : 0)).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        scrollView.contentSize = CGSize(width: Int(screenWidth), height: Int(screenHeight + 30))
        
        scrollView.addSubview(collectionView)
        
        scrollView.addSubview(lblH)
        scrollView.addSubview(lblL)
        scrollView.addSubview(setParam)
        scrollView.addSubview(TextFieldH)
        scrollView.addSubview(TextFieldL)
        
        scrollView.addSubview(deltaKovsh)
        scrollView.addSubview(zaderVkl)
        scrollView.addSubview(zaderVikl)
        scrollView.addSubview(setParamKovsh)
        scrollView.addSubview(TextFieldDelta)
        scrollView.addSubview(TextFieldVkl)
        scrollView.addSubview(TextFieldVikl)
        
        scrollView.addSubview(lblOtH)
        scrollView.addSubview(lblOtL)
        scrollView.addSubview(zaderOtVkl)
        scrollView.addSubview(zaderOtVikl)
        scrollView.addSubview(setParamOt)
        scrollView.addSubview(TextFieldValOtH)
        scrollView.addSubview(TextFieldOtL)
        scrollView.addSubview(TextFieldOtZV)
        scrollView.addSubview(TextFieldOtZVi)

        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollToItem(at:IndexPath(item: actualMode, section: 0), at: .right, animated: false)

        scrollView.addTapGesture {
            self.scrollView.endEditing(true)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        activityIndicator.startAnimating()
        viewAlpha.addSubview(activityIndicator)
        view.addSubview(viewAlpha)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.viewAlpha.removeFromSuperview()
            self.viewLoad.isHidden = false
            self.viewLoadTwo.isHidden = false
            police = true
            
            let alertController = UIAlertController(title: "Set password".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
            let labelLits = UILabel(frame: CGRect(x: 25, y: 40, width: 200, height: 30))
            labelLits.text = "Create a password".localized(code)
            labelLits.alpha = 0.58
            labelLits.font = UIFont(name:"FuturaPT-Light", size: 14.0)

            let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 240)

            alertController.view.addConstraint(height)
            
            self.firstTextField.frame = CGRect(x: 20, y: 70, width: self.view.frame.width/3*2-40, height: 30)
            self.firstTextField.keyboardType = .numberPad
            self.firstTextField.isSecureTextEntry = true
            self.firstTextField.inputAccessoryView = self.toolBar()
            self.firstTextField.layer.cornerRadius = 5
            self.firstTextField.layer.borderWidth = 1
            self.firstTextField.returnKeyType = .next
            self.firstTextField.layer.borderColor = UIColor(named: "Color")!.cgColor
            self.firstTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.firstTextField.frame.height))
            self.firstTextField.leftViewMode = .always
            self.firstTextField.addTarget(self, action: #selector(self.textFieldDidChangeFirst(_:)),for: UIControl.Event.editingChanged)

            let firstTextHide = UIImageView(frame: CGRect(x: self.view.frame.width/3*2-55, y: 74, width: 22, height: 22))
            firstTextHide.image = #imageLiteral(resourceName: "глаз")
            let firstTextHideView = UIView(frame: CGRect(x: self.view.frame.width/3*2-70, y: 60, width: 50, height: 50))
            
            firstTextHideView.addTapGesture {
                if firstTextHide.image == #imageLiteral(resourceName: "глаз") {
                    self.firstTextField.isSecureTextEntry = false
                    firstTextHide.image = #imageLiteral(resourceName: "глаз спрятать")
                } else {
                    self.firstTextField.isSecureTextEntry = true
                    firstTextHide.image = #imageLiteral(resourceName: "глаз")
                }
            }

            let labelLevel = UILabel(frame: CGRect(x: 25, y: 100, width: 200, height: 30))
            labelLevel.text = "Confirm password".localized(code)
            labelLevel.alpha = 0.58
            labelLevel.font = UIFont(name:"FuturaPT-Light", size: 14.0)
            
            self.secondTextField.frame = CGRect(x: 20, y: 130, width: self.view.frame.width/3*2-40, height: 30)
            self.secondTextField.keyboardType = .numberPad
            self.secondTextField.isSecureTextEntry = true
            self.secondTextField.inputAccessoryView = self.toolBar()
            self.secondTextField.layer.cornerRadius = 5
            self.secondTextField.layer.borderWidth = 1
            self.secondTextField.layer.borderColor = UIColor(named: "Color")?.cgColor
            self.secondTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.secondTextField.frame.height))
            self.secondTextField.leftViewMode = .always
            self.secondTextField.addTarget(self, action: #selector(self.textFieldDidChangeFirst(_:)),for: UIControl.Event.editingChanged)

            let secondTextHideView = UIView(frame: CGRect(x: self.view.frame.width/3*2-70, y: 120, width: 50, height: 50))

            
            let secondTextHide = UIImageView(frame: CGRect(x: self.view.frame.width/3*2-55, y: 134, width: 22, height: 22))
            secondTextHide.image = #imageLiteral(resourceName: "глаз")
            secondTextHide.tintColor = .white
            
            secondTextHideView.addTapGesture {
                if secondTextHide.image == #imageLiteral(resourceName: "глаз") {
                    self.secondTextField.isSecureTextEntry = false
                    secondTextHide.image = #imageLiteral(resourceName: "глаз спрятать")
                } else {
                    self.secondTextField.isSecureTextEntry = true
                    secondTextHide.image = #imageLiteral(resourceName: "глаз")
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            
            
            self.saveAction = UIAlertAction(title: "Set".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
                if let it: Int = Int(self.firstTextField.text!) {
                    reload = 8
                    mainPassword = "\(it)"
                    self.activityIndicator.startAnimating()
                    self.viewAlpha.addSubview(self.activityIndicator)
                    self.view.addSubview(self.viewAlpha)
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.view.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        passwordHave = true
                        let alert = UIAlertController(title: "Success".localized(code), message: "Password set successfully".localized(code), preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                passwordSuccess = true
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                            @unknown default:
                                fatalError()
                            }}))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    let alert = UIAlertController(title: "Warning".localized(code), message: "“Password” accepts values from 1 to 2000000000".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            self.navigationController?.popViewController(animated: true)
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            fatalError()
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            self.saveAction.isEnabled = false
            
            self.validatePassword.frame = CGRect(x: 25, y: 160, width: 250, height: 30)
            self.validatePassword.font = UIFont(name:"FuturaPT-Light", size: 14.0)

            alertController.view.addSubview(labelLits)
            alertController.view.addSubview(labelLevel)
            alertController.view.addSubview(self.firstTextField)
            alertController.view.addSubview(self.secondTextField)
            alertController.view.addSubview(self.validatePassword)
            alertController.view.addSubview(firstTextHide)
            alertController.view.addSubview(firstTextHideView)
            alertController.view.addSubview(secondTextHide)
            alertController.view.addSubview(secondTextHideView)

            alertController.addAction(cancelAction)
            alertController.addAction(self.saveAction)
            
            
            //-----------------------------------------------------------SECOND ALERT----------------
            
            let alertControllerSecond = UIAlertController(title: "Enter password".localized(code), message: "", preferredStyle: UIAlertController.Style.alert)
            let labelLitsSecond = UILabel(frame: CGRect(x: 25, y: 40, width: 200, height: 30))
            labelLitsSecond.text = "Enter password".localized(code)
            labelLitsSecond.alpha = 0.58
            labelLitsSecond.font = UIFont(name:"FuturaPT-Light", size: 14.0)

            let heightSecond:NSLayoutConstraint = NSLayoutConstraint(item: alertControllerSecond.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 170)

            alertControllerSecond.view.addConstraint(heightSecond)
            
            self.firstTextFieldSecond.frame = CGRect(x: 20, y: 70, width: self.view.frame.width/3*2-40, height: 30)
            self.firstTextFieldSecond.keyboardType = .numberPad
            self.firstTextFieldSecond.isSecureTextEntry = true
            self.firstTextFieldSecond.inputAccessoryView = self.toolBar()
            self.firstTextFieldSecond.layer.cornerRadius = 5
            self.firstTextFieldSecond.layer.borderWidth = 1
            self.firstTextFieldSecond.returnKeyType = .next
            self.firstTextFieldSecond.layer.borderColor = UIColor(named: "Color")!.cgColor
            self.firstTextFieldSecond.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.firstTextField.frame.height))
            self.firstTextFieldSecond.leftViewMode = .always
            self.firstTextFieldSecond.addTarget(self, action: #selector(self.textFieldDidChangeSecond(_:)),for: UIControl.Event.editingChanged)

            let firstTextHideSecond = UIImageView(frame: CGRect(x: self.view.frame.width/3*2-55, y: 74, width: 22, height: 22))
            firstTextHideSecond.image = #imageLiteral(resourceName: "глаз")
            let firstTextHideViewSecond = UIView(frame: CGRect(x: self.view.frame.width/3*2-70, y: 60, width: 50, height: 50))
            
            firstTextHideViewSecond.addTapGesture {
                if firstTextHideSecond.image == #imageLiteral(resourceName: "глаз") {
                    self.firstTextFieldSecond.isSecureTextEntry = false
                    firstTextHideSecond.image = #imageLiteral(resourceName: "глаз спрятать")
                } else {
                    self.firstTextFieldSecond.isSecureTextEntry = true
                    firstTextHideSecond.image = #imageLiteral(resourceName: "глаз")
                }
            }
            
            let cancelActionSecond = UIAlertAction(title: "Cancel".localized(code), style: UIAlertAction.Style.default, handler: {
                (action : UIAlertAction!) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            
            
            self.saveActionSecond = UIAlertAction(title: "Enter".localized(code), style: UIAlertAction.Style.default, handler: { alert -> Void in
                if let it: Int = Int(self.firstTextFieldSecond.text!) {
                    mainPassword = "\(it)"
                    reload = 9
                    self.activityIndicator.startAnimating()
                    self.viewAlpha.addSubview(self.activityIndicator)
                    self.view.addSubview(self.viewAlpha)
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    self.view.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                        self.view.isUserInteractionEnabled = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        self.viewAlpha.removeFromSuperview()
                        if passwordSuccess == true {
                            let alert = UIAlertController(title: "Success".localized(code), message: "Password is entered".localized(code), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    passwordSuccess = true
                                case .cancel:
                                    print("cancel")
                                case .destructive:
                                    print("destructive")
                                @unknown default:
                                    fatalError()
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            let alert = UIAlertController(title: "Warning".localized(code), message: "Wrong password".localized(code), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    print("default")
                                    self.present(alertControllerSecond, animated: true)
                                case .cancel:
                                    print("cancel")
                                case .destructive:
                                    print("destructive")
                                @unknown default:
                                    fatalError()
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    let alert = UIAlertController(title: "Warning".localized(code), message: "“Password” accepts values from 1 to 2000000000".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            self.present(alertControllerSecond, animated: true)
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        @unknown default:
                            fatalError()
                        }}))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            self.saveActionSecond.isEnabled = false
            
            self.validatePasswordSecond.frame = CGRect(x: 25, y: 95, width: 250, height: 30)
            self.validatePasswordSecond.font = UIFont(name:"FuturaPT-Light", size: 14.0)

            alertControllerSecond.view.addSubview(labelLitsSecond)
            alertControllerSecond.view.addSubview(self.firstTextFieldSecond)
            alertControllerSecond.view.addSubview(self.validatePasswordSecond)
            alertControllerSecond.view.addSubview(firstTextHideSecond)
            alertControllerSecond.view.addSubview(firstTextHideViewSecond)

            alertControllerSecond.addAction(cancelActionSecond)
            alertControllerSecond.addAction(self.saveActionSecond)
            if mainPassword == "" {
                if passwordHave == false {
                    self.present(alertController, animated: true)
                } else {
                    self.present(alertControllerSecond, animated: true)
                    
                }
            }
        }
    }
    @objc func textFieldDidChangeSecond(_ textField: UITextField) {
        if let IntVal: Int = Int(textField.text!) {
            if IntVal == 0 {
                validatePasswordSecond.text = "/0/ password can't be used".localized(code)
                validatePasswordSecond.textColor = UIColor(rgb: 0xCF2121)
                self.saveActionSecond.isEnabled = false
            } else {
                validatePasswordSecond.text = ""
                self.saveActionSecond.isEnabled = true
            }
        } else {
            if textField.text == "" {
                self.saveActionSecond.isEnabled = false
                validatePasswordSecond.text = ""
            } else {
                self.saveActionSecond.isEnabled = false
                validatePasswordSecond.text = "Only numbers are allowed for password".localized(code)
                validatePasswordSecond.textColor = UIColor(rgb: 0xCF2121)
            }
        }
        
        checkMaxLength(textField: textField, maxLength: 10)

    }
    @objc func textFieldDidMax(_ textField: UITextField) {
        print(textField.text!)
        checkMaxLength(textField: textField, maxLength: 3)
    }
    @objc func textFieldDidChangeFirst(_ textField: UITextField) {
        print(textField.text!)

        if let IntVal: Int = Int(textField.text!) {
            if IntVal == 0 {
                validatePassword.text = "/0/ password can't be used".localized(code)
                validatePassword.textColor = UIColor(rgb: 0xCF2121)
                self.saveAction.isEnabled = false
            } else {
                if textField.text == firstTextField.text {
                    if textField.text == secondTextField.text {
                        validatePassword.text = "Passwords match".localized(code)
                        validatePassword.textColor = UIColor(rgb: 0x00A778)
                        self.saveAction.isEnabled = true
                        print("Пароли одинаковы")
                    } else {
                        self.saveAction.isEnabled = false
                        print("Пароли разыне")
                        validatePassword.text = "Passwords do not match".localized(code)
                        validatePassword.textColor = UIColor(rgb: 0xCF2121)
                    }
                } else {
                    self.saveAction.isEnabled = false
                    print("Пароли разыне")
                    validatePassword.text = "Passwords do not match".localized(code)
                    validatePassword.textColor = UIColor(rgb: 0xCF2121)
                }
            }
        } else {
            if textField.text == "" {
                self.saveAction.isEnabled = false
                validatePassword.text = ""
            } else {
                self.saveActionSecond.isEnabled = false
                validatePassword.text = "Only numbers are allowed for password".localized(code)
                validatePassword.textColor = UIColor(rgb: 0xCF2121)
            }
        }
        checkMaxLength(textField: textField, maxLength: 10)
    }
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.text!.count > maxLength {
            textField.deleteBackward()
        }
    }
    @objc func timerAction(){
        viewShowParametrs()
    }

    fileprivate lazy var deltaKovsh: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 30, y: 350-headerHeight - (iphone5s ? 50 : 0), width: screenWidth/2-30, height: 20)
        lbl.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        lbl.text = "Delta".localized(code)
        lbl.isHidden = true
        return lbl
    }()
    fileprivate lazy var zaderVkl: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 30, y: 410-headerHeight - (iphone5s ? 50 : 0), width: screenWidth/2-30, height: 20)
        lbl.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        lbl.text = "Turn ON delay".localized(code)
        lbl.isHidden = true
        return lbl
    }()
    fileprivate lazy var zaderVikl: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 30, y: 470-headerHeight - (iphone5s ? 50 : 0), width: screenWidth/2-30, height: 20)
        lbl.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        lbl.text = "Turn OFF delay".localized(code)
        lbl.isHidden = true
        return lbl
    }()
    fileprivate lazy var setParamKovsh: UIView = {
        let btn = UIView(frame: CGRect(x: 30, y: Int(530-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth-60), height: 44))
        btn.backgroundColor = UIColor(rgb: 0xCF2121)
        btn.layer.cornerRadius = 22
        btn.isHidden = true
        let btnText = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth-60), height: 44))
        btnText.text = "Write parameters to the device".localized(code)
        btnText.textColor = .white
        btnText.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btnText.textAlignment = .center
        btn.addSubview(btnText)
        btn.addTapGesture {
            var quest = 0
            if Int(self.TextFieldDelta.text ?? "0") ?? 0 < 1 || Int(self.TextFieldDelta.text ?? "0") ?? 0 > 179 {
                self.showToast(message: "Delta value 1 to 179".localized(code), seconds: 2.0)
                quest = 1
            }
            if Int(self.TextFieldVkl.text ?? "0") ?? 0 <= 1 || Int(self.TextFieldVkl.text ?? "0") ?? 0 >= 99 {
                self.showToast(message: "Delay value only 1 to 99".localized(code), seconds: 2.0)
                quest = 1
            }
            if Int(self.TextFieldVikl.text ?? "0") ?? 0 <= 1 || Int(self.TextFieldVikl.text ?? "0") ?? 0 >= 99 {
                self.showToast(message: "Delay value only 1 to 99".localized(code), seconds: 2.0)
                quest = 1
            }
            if quest == 0 {
                valL = self.TextFieldDelta.text ?? ""
                zaderV = self.TextFieldVkl.text ?? ""
                zaderVi = self.TextFieldVikl.text ?? ""
                reload = 23
                self.activityIndicator.startAnimating()
                self.viewAlpha.addSubview(self.activityIndicator)
                self.view.addSubview(self.viewAlpha)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.view.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self.viewAlpha.removeFromSuperview()
                    self.showToast(message: "Settings saved".localized(code), seconds: 2.0)
                    self.TextFieldDelta.text = valL
                    self.TextFieldVkl.text = zaderV
                    self.TextFieldVikl.text = zaderVi
                }
            }
        }
        return btn
    }()

    fileprivate lazy var TextFieldDelta: UITextField = {
        let input = UITextField(frame: CGRect(x: Int(screenWidth/2), y: Int(340-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth/2-30), height: 40))
        input.text = valL
        input.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.textColor = isNight ? UIColor.white : UIColor.black
        input.keyboardType = UIKeyboardType.decimalPad
        input.isHidden = true
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    fileprivate lazy var TextFieldVkl: UITextField = {
        let input = UITextField(frame: CGRect(x: Int(screenWidth/2), y: Int(400-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth/2-30), height: 40))
        input.text = zaderV
        input.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.textColor = isNight ? UIColor.white : UIColor.black
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
        input.isHidden = true
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()

    fileprivate lazy var TextFieldVikl: UITextField = {
        let input = UITextField(frame: CGRect(x: Int(screenWidth/2), y: Int(460-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth/2-30), height: 40))
        input.text = zaderVi
        input.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.textColor = isNight ? UIColor.white : UIColor.black
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
        input.isHidden = true
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    
    fileprivate lazy var lblH: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 30, y: 350-headerHeight - (iphone5s ? 50 : 0), width: screenWidth/2-30, height: 20)
        lbl.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        lbl.text = "Top".localized(code)
        lbl.isHidden = true
        return lbl
    }()
    fileprivate lazy var lblL: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 30, y: 410-headerHeight - (iphone5s ? 50 : 0), width: screenWidth/2-30, height: 20)
        lbl.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        lbl.text = "Down".localized(code)
        lbl.isHidden = true
        return lbl
    }()
    
    fileprivate lazy var setParam: UIView = {
        let btn = UIView(frame: CGRect(x: 30, y: Int(470-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth-60), height: 44))
        btn.backgroundColor = UIColor(rgb: 0xCF2121)
        btn.layer.cornerRadius = 22
        btn.isHidden = true
        let btnText = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth-60), height: 44))
        btnText.text = "Write parameters to the device".localized(code)
        btnText.textColor = .white
        btnText.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btnText.textAlignment = .center
        btn.addSubview(btnText)
        btn.addTapGesture {
            var quest = 0
            if Int(self.TextFieldH.text ?? "0") ?? 0 < 1 || Int(self.TextFieldH.text ?? "0") ?? 0 > 179 {
                self.showToast(message: "Value top only 1 to 179".localized(code), seconds: 2.0)
                quest = 1
            }
            if Int(self.TextFieldL.text ?? "0") ?? 0 <= 1 || Int(self.TextFieldL.text ?? "0") ?? 0 > 179 {
                self.showToast(message: "Value down only 1 to 179".localized(code), seconds: 2.0)
                quest = 1
            }
            if quest == 0 {
                valL = self.TextFieldL.text ?? ""
                valH = self.TextFieldH.text ?? ""
                reload = 22
                self.activityIndicator.startAnimating()
                self.viewAlpha.addSubview(self.activityIndicator)
                self.view.addSubview(self.viewAlpha)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.view.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self.viewAlpha.removeFromSuperview()
                    self.showToast(message: "Settings saved".localized(code), seconds: 2.0)
                    self.TextFieldH.text = valH
                    self.TextFieldL.text = valL
                }
            }
        }
        return btn
    }()
    fileprivate lazy var TextFieldL: UITextField = {
        let input = UITextField(frame: CGRect(x: 120, y: Int(400-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth/2-30), height: 40))
        input.text = valL
        input.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.textColor = isNight ? UIColor.white : UIColor.black
        input.keyboardType = UIKeyboardType.decimalPad
        input.isHidden = true
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    fileprivate lazy var TextFieldH: UITextField = {
        let input = UITextField(frame: CGRect(x: 120, y: Int(340-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth/2-30), height: 40))
        input.text = valH
        input.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.textColor = isNight ? UIColor.white : UIColor.black
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
        input.isHidden = true
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    
    fileprivate lazy var lblOtH: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 30, y: 350-headerHeight - (iphone5s ? 50 : 0), width: screenWidth/2-30, height: 20)
        lbl.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        lbl.text = "Top".localized(code)
        lbl.isHidden = true
        return lbl
    }()
    fileprivate lazy var lblOtL: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 30, y: 410-headerHeight - (iphone5s ? 50 : 0), width: screenWidth/2-30, height: 20)
        lbl.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        lbl.text = "Down".localized(code)
        lbl.isHidden = true
        return lbl
    }()
    fileprivate lazy var zaderOtVkl: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 30, y: 470-headerHeight - (iphone5s ? 50 : 0), width: screenWidth/2-30, height: 20)
        lbl.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        lbl.text = "Turn ON delay".localized(code)
        lbl.isHidden = true
        return lbl
    }()
    fileprivate lazy var zaderOtVikl: UILabel = {
        let lbl = UILabel()
        lbl.frame = CGRect(x: 30, y: 535-headerHeight - (iphone5s ? 50 : 0), width: screenWidth/2-30, height: 20)
        lbl.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        lbl.text = "Turn OFF delay".localized(code)
        lbl.isHidden = true
        return lbl
    }()

    fileprivate lazy var setParamOt: UIView = {
        let btn = UIView(frame: CGRect(x: 30, y: Int(590-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth-60), height: 44))
        btn.backgroundColor = UIColor(rgb: 0xCF2121)
        btn.layer.cornerRadius = 22
        btn.isHidden = true
        let btnText = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth-60), height: 44))
        btnText.text = "Write parameters to the device".localized(code)
        btnText.textColor = .white
        btnText.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        btnText.textAlignment = .center
        btn.addSubview(btnText)
        btn.addTapGesture {
            var quest = 0
            if Int(self.TextFieldValOtH.text ?? "0") ?? 0 < 1 || Int(self.TextFieldValOtH.text ?? "0") ?? 0 > 179 {
                self.showToast(message: "Value top only 1 to 179".localized(code), seconds: 2.0)
                quest = 1
            }
            if Int(self.TextFieldOtL.text ?? "0") ?? 0 < 1 || Int(self.TextFieldOtL.text ?? "0") ?? 0 > 179 {
                self.showToast(message: "Value down only 1 to 179".localized(code), seconds: 2.0)
                quest = 1
            }
            if Int(self.TextFieldOtZV.text ?? "0") ?? 0 < 1 || Int(self.TextFieldOtZV.text ?? "0") ?? 0 > 99 {
                self.showToast(message: "Delay value only 1 to 99".localized(code), seconds: 2.0)
                quest = 1
            }
            if Int(self.TextFieldOtZVi.text ?? "0") ?? 0 < 1 || Int(self.TextFieldOtZVi.text ?? "0") ?? 0 > 99 {
                self.showToast(message: "Delay value only 1 to 99".localized(code), seconds: 2.0)
                quest = 1
            }
            if quest == 0 {
                valH = self.TextFieldValOtH.text ?? ""
                valL = self.TextFieldOtL.text ?? ""
                zaderV = self.TextFieldOtZV.text ?? ""
                zaderVi = self.TextFieldOtZVi.text ?? ""
                reload = 24
                self.activityIndicator.startAnimating()
                self.viewAlpha.addSubview(self.activityIndicator)
                self.view.addSubview(self.viewAlpha)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.view.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self.viewAlpha.removeFromSuperview()
                    self.showToast(message: "Settings saved".localized(code), seconds: 2.0)
                    self.TextFieldValOtH.text = valH
                    self.TextFieldOtL.text = valL
                    self.TextFieldOtZV.text = zaderV
                    self.TextFieldOtZVi.text = zaderVi
                }
            }
        }
        return btn
    }()
    
    fileprivate lazy var TextFieldValOtH: UITextField = {
        let input = UITextField(frame: CGRect(x: Int(screenWidth/2), y: Int(340-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth/2-30), height: 40))
        input.text = valH
        input.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.textColor = isNight ? UIColor.white : UIColor.black
        input.keyboardType = UIKeyboardType.decimalPad
        input.isHidden = true
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    fileprivate lazy var TextFieldOtL: UITextField = {
        let input = UITextField(frame: CGRect(x: Int(screenWidth/2), y: Int(400-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth/2-30), height: 40))
        input.text = valL
        input.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.textColor = isNight ? UIColor.white : UIColor.black
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
        input.isHidden = true
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()

    fileprivate lazy var TextFieldOtZV: UITextField = {
        let input = UITextField(frame: CGRect(x: Int(screenWidth/2), y: Int(460-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth/2-30), height: 40))
        input.text = zaderV
        input.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.textColor = isNight ? UIColor.white : UIColor.black
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
        input.isHidden = true
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    fileprivate lazy var TextFieldOtZVi: UITextField = {
        let input = UITextField(frame: CGRect(x: Int(screenWidth/2), y: Int(530-headerHeight) - (iphone5s ? 50 : 0), width: Int(screenWidth/2-30), height: 40))
        input.text = zaderVi
        input.attributedPlaceholder = NSAttributedString(string: "Enter value...".localized(code), attributes: [NSAttributedString.Key.foregroundColor: isNight ? UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0) : UIColor(red: 0.777, green: 0.777, blue: 0.777, alpha: 1.0)])
        input.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        input.layer.borderWidth = 1.0
        input.layer.cornerRadius = 4.0
        input.textColor = isNight ? UIColor.white : UIColor.black
        input.layer.borderColor = UIColor(rgb: 0x959595).cgColor
        input.backgroundColor = .clear
        input.leftViewMode = .always
        input.keyboardType = UIKeyboardType.decimalPad
        input.isHidden = true
        input.addTarget(self, action: #selector(self.textFieldDidMax(_:)),for: UIControl.Event.editingChanged)
        return input
    }()
    func viewShowParametrs() {
        if actualMode == 0 {
            lblH.isHidden = true
            lblL.isHidden = true
            setParam.isHidden = true
            TextFieldH.isHidden = true
            TextFieldL.isHidden = true
            
            deltaKovsh.isHidden = true
            zaderVkl.isHidden = true
            zaderVikl.isHidden = true
            setParamKovsh.isHidden = true
            TextFieldDelta.isHidden = true
            TextFieldVkl.isHidden = true
            TextFieldVikl.isHidden = true
            
            lblOtH.isHidden = true
            lblOtL.isHidden = true
            zaderOtVkl.isHidden = true
            zaderOtVikl.isHidden = true
            setParamOt.isHidden = true
            TextFieldValOtH.isHidden = true
            TextFieldOtL.isHidden = true
            TextFieldOtZV.isHidden = true
            TextFieldOtZVi.isHidden = true
        }
        if actualMode == 1 {
            lblH.isHidden = true
            lblL.isHidden = true
            setParam.isHidden = true
            TextFieldH.isHidden = true
            TextFieldL.isHidden = true
            
            deltaKovsh.isHidden = true
            zaderVkl.isHidden = true
            zaderVikl.isHidden = true
            setParamKovsh.isHidden = true
            TextFieldDelta.isHidden = true
            TextFieldVkl.isHidden = true
            TextFieldVikl.isHidden = true
            
            lblOtH.isHidden = true
            lblOtL.isHidden = true
            zaderOtVkl.isHidden = true
            zaderOtVikl.isHidden = true
            setParamOt.isHidden = true
            TextFieldValOtH.isHidden = true
            TextFieldOtL.isHidden = true
            TextFieldOtZV.isHidden = true
            TextFieldOtZVi.isHidden = true
        }
        if actualMode == 2 {
            lblH.isHidden = true
            lblL.isHidden = true
            setParam.isHidden = true
            TextFieldH.isHidden = true
            TextFieldL.isHidden = true
            
            deltaKovsh.isHidden = true
            zaderVkl.isHidden = true
            zaderVikl.isHidden = true
            setParamKovsh.isHidden = true
            TextFieldDelta.isHidden = true
            TextFieldVkl.isHidden = true
            TextFieldVikl.isHidden = true

            lblOtH.isHidden = true
            lblOtL.isHidden = true
            zaderOtVkl.isHidden = true
            zaderOtVikl.isHidden = true
            setParamOt.isHidden = true
            TextFieldValOtH.isHidden = true
            TextFieldOtL.isHidden = true
            TextFieldOtZV.isHidden = true
            TextFieldOtZVi.isHidden = true
        }
        if actualMode == 3 {
            lblH.isHidden = false
            lblL.isHidden = false
            setParam.isHidden = false
            TextFieldH.isHidden = false
            TextFieldL.isHidden = false
            
            deltaKovsh.isHidden = true
            zaderVkl.isHidden = true
            zaderVikl.isHidden = true
            setParamKovsh.isHidden = true
            TextFieldDelta.isHidden = true
            TextFieldVkl.isHidden = true
            TextFieldVikl.isHidden = true
            
            lblOtH.isHidden = true
            lblOtL.isHidden = true
            zaderOtVkl.isHidden = true
            zaderOtVikl.isHidden = true
            setParamOt.isHidden = true
            TextFieldValOtH.isHidden = true
            TextFieldOtL.isHidden = true
            TextFieldOtZV.isHidden = true
            TextFieldOtZVi.isHidden = true
        }
        if actualMode == 4 {
            lblH.isHidden = true
            lblL.isHidden = true
            setParam.isHidden = true
            TextFieldH.isHidden = true
            TextFieldL.isHidden = true
            
            deltaKovsh.isHidden = false
            zaderVkl.isHidden = false
            zaderVikl.isHidden = false
            setParamKovsh.isHidden = false
            TextFieldDelta.isHidden = false
            TextFieldVkl.isHidden = false
            TextFieldVikl.isHidden = false
            
            lblOtH.isHidden = true
            lblOtL.isHidden = true
            zaderOtVkl.isHidden = true
            zaderOtVikl.isHidden = true
            setParamOt.isHidden = true
            TextFieldValOtH.isHidden = true
            TextFieldOtL.isHidden = true
            TextFieldOtZV.isHidden = true
            TextFieldOtZVi.isHidden = true
        }
        if actualMode == 5 {
            lblH.isHidden = true
            lblL.isHidden = true
            setParam.isHidden = true
            TextFieldH.isHidden = true
            TextFieldL.isHidden = true
            
            deltaKovsh.isHidden = true
            zaderVkl.isHidden = true
            zaderVikl.isHidden = true
            setParamKovsh.isHidden = true
            TextFieldDelta.isHidden = true
            TextFieldVkl.isHidden = true
            TextFieldVikl.isHidden = true
            
            lblOtH.isHidden = false
            lblOtL.isHidden = false
            zaderOtVkl.isHidden = false
            zaderOtVikl.isHidden = false
            setParamOt.isHidden = false
            TextFieldValOtH.isHidden = false
            TextFieldOtL.isHidden = false
            TextFieldOtZV.isHidden = false
            TextFieldOtZVi.isHidden = false
        }
    }
    
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            zaderOtVikl.theme.textColor = themed{ $0.navigationTintColor }
            zaderOtVkl.theme.textColor = themed{ $0.navigationTintColor }
            lblOtH.theme.textColor = themed{ $0.navigationTintColor }
            lblOtL.theme.textColor = themed{ $0.navigationTintColor }
            
            zaderVikl.theme.textColor = themed{ $0.navigationTintColor }
            zaderVkl.theme.textColor = themed{ $0.navigationTintColor }
            deltaKovsh.theme.textColor = themed{ $0.navigationTintColor }
            lblH.theme.textColor = themed{ $0.navigationTintColor }
            lblL.theme.textColor = themed{ $0.navigationTintColor }
            
            lblTitle.theme.textColor = themed{ $0.navigationTintColor }
            lblTitle3.theme.textColor = themed{ $0.navigationTintColor }
            lblTitle4.theme.textColor = themed{ $0.navigationTintColor }
            termoLabel.theme.textColor = themed{ $0.navigationTintColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            zaderOtVikl.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            zaderOtVkl.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            
            lblOtH.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            lblOtL.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            zaderVikl.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            zaderVkl.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            deltaKovsh.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            
            lblH.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            lblL.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            lblTitle.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            lblTitle3.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            lblTitle4.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            termoLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }

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
        firstTextFieldSecond.endEditing(true)
    }
}

extension DevicaDUSettings: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print("collectionView.frame.width/2.5 : \(collectionView.frame.width/2.5)...\(collectionView.frame.width/2)")
        return CGSize(width: 170, height: 210)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backgroundColor = .clear
        cell.viewLabel.text = ArrayMode[indexPath.row]
        cell.viewImage.image = isNight ? ArrayModeImage[indexPath.row] : ArrayModeImageBlack[indexPath.row]
        if indexPath.row == 1 {
            cell.lotView.isHidden = false
            cell.lotViewVer.isHidden = true
            cell.viewImage.isHidden = true
        } else if indexPath.row == 2 {
            cell.lotView.isHidden = true
            cell.lotViewVer.isHidden = false
            cell.viewImage.isHidden = true
        } else {
            cell.lotView.isHidden = true
            cell.lotViewVer.isHidden = true
            cell.viewImage.isHidden = false
        }
        cell.addTapGesture {
            if actualMode != indexPath.row {
                self.activityIndicator.startAnimating()
                self.viewAlpha.addSubview(self.activityIndicator)
                self.view.addSubview(self.viewAlpha)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.view.isUserInteractionEnabled = false
                print("indexPath.rowCell: \(indexPath.row)")
                if indexPath.row == 0 {
                    modeLabel = "0"
                }
                if indexPath.row == 1 {
                    modeLabel = "4"
                }
                if indexPath.row == 2 {
                    modeLabel = "5"
                }
                if indexPath.row == 3 {
                    modeLabel = "6"
                }
                if indexPath.row == 4 {
                    modeLabel = "9"
                }
                if indexPath.row == 5 {
                    modeLabel = "10"
                }
                reload = 21
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self.viewAlpha.removeFromSuperview()
                    if checkMode == true {
                        actualMode = indexPath.row
                        self.showToast(message: "Mode is set successfully".localized(code), seconds: 2.0)
                        collectionView.reloadData()
                        checkMode = false
                        self.TextFieldH.text = valH
                        self.TextFieldL.text = valL
                        self.TextFieldValOtH.text = valH
                        self.TextFieldOtL.text = valL
                        self.TextFieldOtZV.text = zaderV
                        self.TextFieldOtZVi.text = zaderVi
                        self.TextFieldDelta.text = valL
                        self.TextFieldVkl.text = zaderV
                        self.TextFieldVikl.text = zaderVi
                    } else {
                        self.showToast(message: "Mode setting failure. Try again".localized(code), seconds: 2.0)
                    }
                }
            }
        }
            cell.viewLine.isHidden = true
            cell.viewLabel.font = UIFont(name:"FuturaPT-Light", size: 18.0)
            if actualMode == indexPath.row {
                cell.viewLine.isHidden = false
                cell.viewLabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            }
        
        return cell
    }
}

struct CustomData {
    var title: String
    var url: String
    var backgroundImage: UIImage
}


class CustomCell: UICollectionViewCell {
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            bg.image = data.backgroundImage
            
        }
    }
    
    fileprivate let bg: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
                iv.layer.cornerRadius = 12
        return iv
    }()
    
    fileprivate let view: UIView = {
       let iv = UIView()
        iv.frame = CGRect(x: 10, y: 10, width: 150, height: 100)
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.layer.borderWidth = 1.0   // толщина обводки
        iv.layer.borderColor = UIColor(rgb: 0x989898).cgColor // цвет обводки
        iv.clipsToBounds = true
        return iv
    }()
    fileprivate let viewLine: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: 170, height: 192)
        let v1 = UIView()
        v1.frame = CGRect(x: 10, y: 10, width: 150, height: 100)
        v1.layer.cornerRadius = 5
        v1.layer.borderWidth = 1.0   // толщина обводки
        v1.layer.borderColor = UIColor(rgb: 0xCF2121).cgColor // цвет обводки
        v1.clipsToBounds = true
        v.addSubview(v1)

        let iv = UIView()
        iv.frame = CGRect(x: 5, y: 180, width: 160, height: 2)
        iv.backgroundColor = UIColor(rgb: 0xCF2121) // цвет обводки
        v.addSubview(iv)

        return v
    }()
    
    fileprivate let viewImage: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: 25, y: 10, width: 128, height: 90)
        return iv
    }()
    fileprivate let viewLabel: UILabel = {
        let iv = UILabel()
        iv.frame = CGRect(x: 5, y: 105, width: 160, height: 80)
        iv.numberOfLines = 3
        iv.textColor = .white
        iv.textAlignment = .center
        iv.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        iv.clipsToBounds = true
        return iv
    }()
    
    fileprivate var lotView: AnimationView = {
        let lotView = AnimationView(name: isNight ? "du_ble_black_2" : "du_ble_white_2")
        lotView.frame = CGRect(x: 0, y: 0, width: 171, height: 116)
        lotView.animationSpeed = 3.0
        lotView.loopMode = .loop
//        lotView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        lotView.play()
        //        iv.contentMode = .scaleAspectFill
        //        iv.clipsToBounds = true
        return lotView
    }()
        fileprivate var lotViewVer: AnimationView = {
            let lotView = AnimationView(name: isNight ? "du-ble_black_1" : "du_ble_white_1")
            lotView.frame = CGRect(x: 0, y: 0, width: 171, height: 116)
            lotView.animationSpeed = 3.0
            lotView.loopMode = .loop
    //        lotView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            lotView.play()
            //        iv.contentMode = .scaleAspectFill
            //        iv.clipsToBounds = true
            return lotView
        }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(bg)
        contentView.addSubview(view)
        contentView.addSubview(viewLabel)
        contentView.addSubview(viewImage)
        contentView.addSubview(viewLine)
        contentView.addSubview(lotView)
        contentView.addSubview(lotViewVer)

        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        setupTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            viewLabel.theme.textColor = themed { $0.navigationTintColor }
        } else {
            // Fallback on earlier versions
        }
    }
}
