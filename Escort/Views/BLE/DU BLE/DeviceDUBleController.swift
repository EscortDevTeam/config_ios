//
//  DeviceDUBleController.swift
//  Escort
//
//  Created by Володя Зверев on 03.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//
import UIKit
import UIDrawer
import RxSwift
import RxTheme

class DeviceDUBleController: UIViewController {
    
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    var attributedTitle = NSAttributedString()
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    var timer = Timer()
    var count = 0
    var timerTrue = 0
    
    let firstTextField = UITextField()
    let secondTextField = UITextField()
    let validatePassword = UILabel()
    var saveAction = UIAlertAction()
    
    let firstTextFieldSecond = UITextField()
    let secondTextFieldSecond = UITextField()
    let validatePasswordSecond = UILabel()
    var saveActionSecond = UIAlertAction()
    
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewShow()
        setupTheme()
    }
    @objc func refresh(sender:AnyObject) {
        repeatData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.refreshControl.endRefreshing()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true
        QRCODE = ""
        attributedTitle = NSAttributedString(string: "Wait".localized(code), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        item = 0
        police = false
        if timerTrue == 0 {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            timerTrue = 1
        }
        
        if reloadBack == 1{
            self.navigationController?.popViewController(animated: true)
            timerTrue = 0
            reloadBack = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if countNot == 0 {
                if passNotif == 1 {
                    passwordHave = true
                    self.showToast(message: "Sensor is not password-protected".localized(code), seconds: 3.0)
                } else {
                    passwordHave = false
                }
                countNot = 1
            }
        }
    }
    @objc func timerAction(){
        repeatData()
        count += 1
        print("count: \(count)")
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.alpha = 0.3
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()
    fileprivate lazy var scaleView: UIView = {
        let scaleView = UIView(frame: CGRect(x: Int(screenWidth-72), y: Int(screenHeight/2+190), width: 14, height: -2))
        scaleView.backgroundColor = UIColor(rgb: 0x00A778)
        return scaleView
    }()
    
    fileprivate lazy var bgImageBattary: UIImageView = {
        let img = UIImageView(image: UIImage(named: "Battary.png")!)
        img.frame = CGRect(x:screenWidth-60, y: screenHeight/5-31, width: 32, height: 14)
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        return img
    }()
    fileprivate lazy var bgImageBattary1: UIView = {
        let img = UIView(frame: CGRect(x:screenWidth-58, y: screenHeight/5-29, width: 8, height: 10))
        return img
    }()
    fileprivate lazy var bgImageBattary2: UIView = {
        let img = UIView(frame: CGRect(x:screenWidth-50, y: screenHeight/5-29, width: 8, height: 10))
        return img
    }()
    fileprivate lazy var bgImageBattary3: UIView = {
        let img = UIView(frame: CGRect(x:screenWidth-42, y: screenHeight/5-29, width: 9, height: 10))
        return img
    }()
    
    fileprivate lazy var bgImageSignal: UIImageView = {
        let img = UIImageView(image: UIImage(named: "signal1.png")!)
        img.frame = CGRect(x: 30, y: screenHeight/5-22, width: 4, height: 5)
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        return img
    }()
    fileprivate lazy var bgImageSignal2: UIImageView = {
        let img = UIImageView(image: UIImage(named: "signal2.png")!)
        img.frame = CGRect(x: 35, y: screenHeight/5-24, width: 4, height: 7)
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        return img
    }()
    fileprivate lazy var bgImageSignal3: UIImageView = {
        let img = UIImageView(image: UIImage(named: "signal3.png")!)
        img.frame = CGRect(x: 40, y: screenHeight/5-26, width: 4, height: 9)
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        return img
    }()
    
    
    fileprivate lazy var sensorImage: UIImageView = {
        let img = UIImageView(image: #imageLiteral(resourceName: "Слой 2-10"))
        img.frame = CGRect(x: screenWidth-200, y: 0, width: 144, height: 106)
        img.center.y = iphone5s ? self.view.center.y/3 + headerHeight + 10 : self.view.center.y/2 + headerHeight
        img.center.x = self.view.center.x/2 * 3
        img.image = img.image!.withRenderingMode(.alwaysTemplate)

        return img
    }()
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var textLineCreateName: UILabel = {
        let deviceName = UILabel(frame: CGRect(x: 30, y: iphone5s
            ? Int(screenHeight/6) : Int(screenHeight/4), width: Int(screenWidth), height: 78))
        deviceName.text = "№ \(nameDevice)\nFW: \(VV)"
        deviceName.textColor = UIColor(rgb: 0xE9E9E9)
        deviceName.font = UIFont(name:"FuturaPT-Medium", size: 20.0)
        deviceName.numberOfLines = 0
        return deviceName
    }()
    
    fileprivate lazy var textLineCreateTemp: UIImageView = {
        let degreeIcon = UIImageView(image: UIImage(named: "temp")!)
        degreeIcon.frame = CGRect(x: 130, y: Int(screenHeight/4) + 12, width: 18, height: 31)
        degreeIcon.image = degreeIcon.image!.withRenderingMode(.alwaysTemplate)

        return degreeIcon
    }()
    fileprivate lazy var textLineCreateTempText: UILabel = {
        let degreeName = UILabel(frame: CGRect(x: 154, y: Int(screenHeight/4) + 15, width: 40, height: 31))
        degreeName.textColor = UIColor(rgb: 0xDADADA)
        degreeName.font = UIFont(name:"FuturaPT-Medium", size: 16.0)
        return degreeName
    }()

    fileprivate lazy var textLineCreateLevel: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 30, y: iphone5s ? Int(screenHeight / 3.5) : Int(screenHeight / 2.5), width: Int(screenWidth-160), height: 20))
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    fileprivate lazy var textLineCreateMode: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 30, y: iphone5s ? Int(screenHeight / 3.5) + Int((screenHeight-screenHeight/3.5)/9)-10 : Int(screenHeight / 2.5) + Int((screenHeight-screenHeight/2.5)/9)-10, width: Int(screenWidth-30), height: 40))
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    fileprivate lazy var textLineCreateEvent: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 30, y: iphone5s ? Int(screenHeight / 3.5) + Int((screenHeight-screenHeight/3.5)/9*2) : Int(screenHeight / 2.5) + Int((screenHeight-screenHeight/2.5)/9*2), width: Int(screenWidth-60), height: 20))
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    fileprivate lazy var textLineCreateRssi: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 30, y: iphone5s ? Int(screenHeight / 3.5) + Int((screenHeight-screenHeight/3.5)/9*3) : Int(screenHeight / 2.5) + Int((screenHeight-screenHeight/2.5)/9*3), width: Int(screenWidth-160), height: 20))
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    fileprivate lazy var textLineCreateVbat: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 30, y: iphone5s ? Int(screenHeight / 3.5) + Int((screenHeight-screenHeight/3.5)/9*4) : Int(screenHeight / 2.5) + Int((screenHeight-screenHeight/2.5)/9*4), width: Int(screenWidth-160), height: 20))
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    fileprivate lazy var textLineCreateID: UILabel = {
        let lblTitle = UILabel(frame: CGRect(x: 30, y: iphone5s ? Int(screenHeight / 3.5) + Int((screenHeight-screenHeight/3.5)/9*5) : Int(screenHeight / 2.5) + Int((screenHeight-screenHeight/2.5)/9*5), width: Int(screenWidth-140), height: 20))
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return lblTitle
    }()
    fileprivate lazy var statusName: UILabel = {
        let statusName = UILabel(frame: CGRect(x: 30, y:iphone5s ? Int(screenHeight / 3.5) + Int((screenHeight-screenHeight/3.5)/9*6) :  Int(screenHeight / 2.5) + Int((screenHeight-screenHeight/2.5)/9*6), width: Int(screenWidth), height: 40))
        statusName.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        return statusName
    }()
    
    fileprivate lazy var setZero: UIView = {
        let statusName = UIView(frame: CGRect(x: Int(screenWidth/3)+10, y: iphone5s ? Int(screenHeight / 3.5) + Int((screenHeight-screenHeight/3.5)/9*6)-10 : Int(screenHeight / 2.5) + Int((screenHeight-screenHeight/2.5)/9*6)-10, width: Int(screenWidth/2.5), height: 50))
        statusName.layer.cornerRadius = 25
        statusName.backgroundColor = UIColor(rgb: 0xE80000)
        let statusNamalabel = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth/2.5), height: 50))
        statusNamalabel.text = "Set 0".localized(code)
//        print("statusName.bounds.width: \(statusName.bounds.width)")
        statusNamalabel.center.x = (statusName.bounds.width)/2
        statusNamalabel.textAlignment = .center
        statusNamalabel.textColor = .white
        statusNamalabel.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        statusName.addSubview(statusNamalabel)
        return statusName
    }()
    fileprivate lazy var textLineCreateCopy: UIImageView = {
        let copyView = UIImageView()
        copyView.frame = CGRect(x: Int(screenWidth/2+73), y: iphone5s ? Int(screenHeight / 3.5) + Int((screenHeight-screenHeight/3.5)/9*5) : Int(screenHeight / 2.5) + Int((screenHeight-screenHeight/2.5)/9*5), width: 13, height: 16)
        return copyView
    }()

    private func textLineCreate(title: String, text: String, x: Int, y: Int) -> UIView {
        let v = UIView(frame: CGRect(x: x, y: y, width: Int(screenWidth-160), height: 20))
        
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenWidth/2), height: 20))
        lblTitle.text = title
        lblTitle.textColor = UIColor(rgb: 0xE9E9E9)
        lblTitle.font = UIFont(name:"FuturaPT-Light", size: 18.0)
        
        let lblText = UILabel(frame: CGRect(x: 70, y: 0, width: Int(screenWidth/2), height: 20))
        lblText.text = text
        lblText.textColor = UIColor(rgb: 0xE9E9E9)
        lblText.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
        
        v.addSubview(lblTitle)
        v.addSubview(lblText)
        
        return v
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
        text.text = "Type of bluetooth sensor".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
    }()
    fileprivate lazy var footer: UIView = {
    let footer = UIView(frame: CGRect(x: 0, y: screenHeight - 90, width: screenWidth, height: 90))
        footer.layer.shadowRadius = 3.0
        footer.layer.shadowOpacity = 0.2
        footer.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        return footer
    }()
    fileprivate lazy var cellSettingAddName: UILabel = {
        let cellSettingAddName = UILabel(frame: CGRect(x: 0, y: 55, width: Int(screenWidth/3), height: 20))
        cellSettingAddName.text = "Additional Features".localized(code)
        cellSettingAddName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellSettingAddName.textAlignment = .center
        return cellSettingAddName
    }()
    fileprivate lazy var cellSettingName: UILabel = {
        let cellSettingName = UILabel(frame: CGRect(x: 0, y: 55, width: Int(screenWidth/3), height: 20))
        cellSettingName.text = "Settings".localized(code)
        cellSettingName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellSettingName.textAlignment = .center
        return cellSettingName
    }()
    fileprivate lazy var cellHelpName: UILabel = {
        let cellHelpName = UILabel(frame: CGRect(x: 0, y: 55, width: Int(screenWidth/3), height: 20))
        cellHelpName.text = "Reference".localized(code)
        cellHelpName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellHelpName.textAlignment = .center
        return cellHelpName
    }()
    func delay(interval: TimeInterval, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            closure()
        }
    }
    fileprivate lazy var cellSettingSeparetor: UIView = {
        let cellSettingSeparetor = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 90))
        cellSettingSeparetor.alpha = 0.1
        return cellSettingSeparetor
    }()
    fileprivate lazy var cellSettingSeparetorTwo: UIView = {
        let cellSettingSeparetor = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 90))
        cellSettingSeparetor.alpha = 0.1
        return cellSettingSeparetor
    }()
    
    private func viewShow() {
        view.addSubview(themeBackView3)
        MainLabel.text = "DU BLE".localized(code)
        view.addSubview(MainLabel)
        
        viewAlpha.addSubview(activityIndicator)
        view.addSubview(viewAlpha)
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.view.isUserInteractionEnabled = true
            self.viewShowMain()
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        warning = true
    }
    override func viewWillAppear(_ animated: Bool) {
        warning = false
        viewAlpha.addSubview(activityIndicator)
        view.addSubview(viewAlpha)
        self.view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.activityIndicator.stopAnimating()
            self.viewAlpha.removeFromSuperview()
            self.refreshControl.endRefreshing()
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.view.isUserInteractionEnabled = true

        }

    }
    override func viewDidDisappear(_ animated: Bool) {
        timerTrue = 0
        timer.invalidate()
        nameDevice = ""
        VV = ""
        level = ""
        RSSIMain = ""
        vatt = ""
        id = ""
        temp = nil
        viewShowMain()
    }
    private func viewShowMain() {
        
        view.addSubview(backView)
        
        self.activityIndicator.stopAnimating()

        self.view.isUserInteractionEnabled = true
        
        backView.addTapGesture{
            self.timerTrue = 0
            self.view.subviews.forEach({ $0.removeFromSuperview() })
            self.timer.invalidate()
            nameDevice = ""
            temp = nil
            self.navigationController?.popViewController(animated: true)
        }
        view.addSubview(bgImage)
        view.addSubview(sensorImage)
        view.addSubview(bgImageBattary)
        view.addSubview(bgImageBattary1)
        view.addSubview(bgImageBattary2)
        view.addSubview(bgImageBattary3)
        
        
        view.addSubview(bgImageSignal)
        view.addSubview(bgImageSignal2)
        view.addSubview(bgImageSignal3)

        var y = 100
        let deltaY = 50
        
        textLineCreateName.text = "№ \(nameDevice)\nFW: \(VV)"
        view.addSubview(textLineCreateName)
        
//        view.addSubview(textLineCreateTemp)
//        textLineCreateTempText.text = "\(temp ?? "0")°"
//        view.addSubview(textLineCreateTempText)
        
        scrollView.addSubview(refreshControl)
        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight-20).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        scrollView.contentSize = CGSize(width: Int(screenWidth), height: Int(screenHeight))
        
        
        y = Int(screenHeight / 5)
        
        textLineCreateLevel.text = "Angle".localized(code) + "\(level)°"
        view.addSubview(textLineCreateLevel)
        y = y + deltaY + (hasNotch ? 0 : 40)
        textLineCreateMode.text = "Mode".localized(code)
        view.addSubview(textLineCreateMode)
        y = y + deltaY + (hasNotch ? 0 : 40)
        textLineCreateEvent.text = "Event notification".localized(code)
        view.addSubview(textLineCreateEvent)
        y = y + deltaY + (hasNotch ? 0 : 40)
        textLineCreateRssi.text = "RSSI:    \(RSSIMain)"
        view.addSubview(textLineCreateRssi)
        y = y + deltaY + (hasNotch ? 0 : 40)
        textLineCreateVbat.text = "Vbat:    \(vatt)V"
        view.addSubview(textLineCreateVbat)
        y = y + deltaY + (hasNotch ? 0 : 40)
        textLineCreateID.text = "ID:        \(id)"
        view.addSubview(textLineCreateID)
        if isNight {
            textLineCreateCopy.image = #imageLiteral(resourceName: "copy")
        } else {
            textLineCreateCopy.image = #imageLiteral(resourceName: "Group-2")
        }
        view.addSubview(textLineCreateCopy)
        let copyViewMain = UIView(frame: CGRect(x: Int(screenWidth/2+73)-10, y: iphone5s ? Int(screenHeight / 3.5) + Int((screenHeight-screenHeight/3.5)/9*5)-10 : Int(screenHeight / 2.5) + Int((screenHeight-screenHeight/2.5)/9*5)-10, width: 35, height: 35))
        copyViewMain.backgroundColor = .clear
        view.addSubview(copyViewMain)
        
        copyViewMain.addTapGesture {
            UIPasteboard.general.string = id
            let alert = UIAlertController(title: "Сopied to clipboard".localized(code), message: "\(id)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                @unknown default:
                    fatalError()
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        
        if temp != nil {
            statusName.text = "Connected".localized(code)
            statusName.textColor = UIColor(rgb: 0x00A778)
        } else {
            statusName.text = "Disconnected".localized(code)
            statusName.textColor = UIColor(rgb: 0xCF2121)
            item = 0
        }

        let cntMain1: Int = Int(cnt1)!
        cnt1 = cnt2
        let cntMain2: Int = Int(cnt2)!
        let abc:Double = Double(abs(cntMain1-cntMain2))/Double(cntMain1/100)
        print("abc: \(abc)")
        if abc > 1 {
            itemColor = 0
//            lbl4.text = "Not stable".localized(code)
            statusDeviceY = "Not stable".localized(code)
//            lbl4.textColor = UIColor(rgb: 0xCF2121)
            item = 1
        } else {
            itemColor = 1
//            lbl4.text = "Stable".localized(code)
            statusDeviceY = "Stable".localized(code)
//            lbl4.textColor = UIColor(rgb: 0x00A778)
        }
        
        view.addSubview(statusName)
        view.addSubview(setZero)
        
        setZero.addTapGesture {
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
//                self.navigationController?.popViewController(animated: true)
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
                                reload = 20
                                self.activityIndicator.startAnimating()
                                self.viewAlpha.addSubview(self.activityIndicator)
                                self.view.addSubview(self.viewAlpha)
                                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                                self.view.isUserInteractionEnabled = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                                    self.view.isUserInteractionEnabled = true
                                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                                    self.viewAlpha.removeFromSuperview()
                                    if checkASA == true {
                                        self.showToast(message: "Zero angle setup succesfully done".localized(code), seconds: 2.0)
                                        checkASA = false
                                    } else {
                                        self.showToast(message: "Failed to set zero angle".localized(code), seconds: 2.0)
                                        checkASA = false
                                    }
                                }
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
//                            self.navigationController?.popViewController(animated: true)
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
//                self.navigationController?.popViewController(animated: true)
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
                                    reload = 20
                                    self.activityIndicator.startAnimating()
                                    self.viewAlpha.addSubview(self.activityIndicator)
                                    self.view.addSubview(self.viewAlpha)
                                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                                    self.view.isUserInteractionEnabled = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                                        self.view.isUserInteractionEnabled = true
                                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                                        self.viewAlpha.removeFromSuperview()
                                        if checkASA == true {
                                            self.showToast(message: "Zero angle setup succesfully done".localized(code), seconds: 2.0)
                                            checkASA = false
                                        } else {
                                            self.showToast(message: "Failed to set zero angle".localized(code), seconds: 2.0)
                                            checkASA = false
                                        }
                                    }
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
            } else {
                reload = 20
                self.activityIndicator.startAnimating()
                self.viewAlpha.addSubview(self.activityIndicator)
                self.view.addSubview(self.viewAlpha)
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.view.isUserInteractionEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self.viewAlpha.removeFromSuperview()
                    if checkASA == true {
                        self.showToast(message: "Zero angle setup succesfully done".localized(code), seconds: 2.0)
                        checkASA = false
                    } else {
                        self.showToast(message: "Failed to set zero angle".localized(code), seconds: 2.0)
                        checkASA = false
                    }
                }
            }
        }
//        view.addSubview(lbl4)
        
        // tabs
        
        
        let footerCellWidth = Int(screenWidth/3), footerCellHeight = 90
        
        let cellSetting = UIView(frame: CGRect(x: 0, y: 0, width: footerCellWidth, height: footerCellHeight))
        let cellSettingIcon = UIImageView(image: UIImage(named: "settings.png")!)
        cellSettingIcon.frame = CGRect(x: 0, y: 0, width: 47, height: 47)
        cellSettingIcon.center = CGPoint(x: cellSetting.frame.size.width / 2, y: cellSetting.frame.size.height / 2 - 15)
        cellSetting.addSubview(cellSettingIcon)
        

        cellSetting.addSubview(cellSettingName)

        cellSetting.addTapGesture {
            if temp != nil {
                self.navigationController?.pushViewController(DevicaDUSettings(), animated: true)
            } else {
                self.showToast(message: "Not connected to the sensor".localized(code), seconds: 1.0)
            }
        }
        
        let cellSettingAdd = UIView(frame: CGRect(x: footerCellWidth, y: 0, width: footerCellWidth, height: footerCellHeight))
        let cellSettingAddIcon = UIImageView(image: UIImage(named: "settings-add.png")!)
        cellSettingAddIcon.frame = CGRect(x: 0, y: 0, width: 47, height: 47)
        cellSettingAddIcon.center = CGPoint(x: cellSettingAdd.frame.size.width / 2, y: cellSettingAdd.frame.size.height / 2 - 15)
        cellSettingAdd.addSubview(cellSettingAddIcon)
        
        cellSettingAdd.addSubview(cellSettingAddName)
        
        cellSettingAdd.addSubview(cellSettingSeparetor)
        
        cellSettingAdd.addTapGesture {
            if temp != nil {
                self.navigationController?.pushViewController(DeviceDUPassword(), animated: true)
            } else {
                self.showToast(message: "Not connected to the sensor".localized(code), seconds: 1.0)
            }
        }
        
        let cellHelp = UIView(frame: CGRect(x: footerCellWidth*2, y: 0, width: footerCellWidth, height: footerCellHeight))
        let cellHelpIcon = UIImageView(image: UIImage(named: "boxquestion")!)
        cellHelpIcon.frame = CGRect(x: 0, y: 0, width: 47, height: 47)
        cellHelpIcon.center = CGPoint(x: cellHelp.frame.size.width / 2, y: cellHelp.frame.size.height / 2 - 15)
        cellHelp.addSubview(cellHelpIcon)
        
        cellHelp.addSubview(cellHelpName)
        
        cellHelp.addSubview(cellSettingSeparetorTwo)
        
        cellHelp.addTapGesture {
            if temp != nil {
                
            } else {
                self.showToast(message: "Not connected to the sensor".localized(code), seconds: 1.0)
            }
        }
        
        
        footer.addSubview(cellSetting)
        footer.addSubview(cellSettingAdd)
        footer.addSubview(cellHelp)
        
        view.addSubview(footer)

        let lineView = UIView(frame: CGRect(x: 0, y: iphone5s ? screenHeight/5 + 45 : screenHeight/4+80, width: screenWidth/2, height: 1))
        lineView.backgroundColor = UIColor(rgb: 0xCF2121)
        view.addSubview(lineView)
        
    }
    func repeatData() {
        textLineCreateName.text = "№ \(nameDevice)\nFW: \(VV)"
        textLineCreateTempText.text = "\(temp ?? "0")°"
        textLineCreateLevel.text = iphone5s ? "Angle".localized(code) + ":\t\(level)°" : "Angle".localized(code) + ":\t\t\(level)°"
        if modeLabel == "0" {
            mode = "Transportation".localized(code)
            modeS = "Accelerometer is off".localized(code)
            actualMode = 0
        }
        if modeLabel == "4" {
            mode = "Horizontal rotation control".localized(code)
            if modeS == "0" {
                modeS = "Inactive".localized(code)
            }
            if modeS == "1" {
                modeS = "To the left".localized(code)
            }
            if modeS == "2" {
                modeS = "To the right".localized(code)
            }
            actualMode = 1
        }
        if modeLabel == "5" {
            mode = "Vertical rotation control".localized(code)
            if modeS == "0" {
                modeS = "Inactive".localized(code)
            }
            if modeS == "1" {
                modeS = "To the left".localized(code)
            }
            if modeS == "2" {
                modeS = "To the right".localized(code)
            }
            actualMode = 2
        }
        if modeLabel == "6" {
            mode = "Angle control".localized(code)
            if modeS == "0" {
                modeS = "Inactive".localized(code)
            }
            if modeS == "1" {
                modeS = "Active".localized(code)
            }
            actualMode = 3
        }
        if modeLabel == "9" {
            mode = "Bucket".localized(code)
            if modeS == "0" {
                modeS = "Inactive".localized(code)
            }
            if modeS == "1" {
                modeS = "Active".localized(code)
            }
            actualMode = 4
        }
        if modeLabel == "10" {
            mode = "Plow".localized(code)
            if modeS == "0" {
                modeS = "Inactive".localized(code)
            }
            if modeS == "1" {
                modeS = "Active".localized(code)
            }
            actualMode = 5
            
        }
        textLineCreateMode.text = iphone5s ? "Mode".localized(code) + ":\t\(mode)" : "Mode".localized(code) + ":\t\t\(mode)"
        textLineCreateEvent.text = "Event notific.".localized(code) + ":\t\(modeS)"

        textLineCreateRssi.text = iphone5s ? "RSSI:\t\(RSSIMain)" : "RSSI:\t\t\(RSSIMain)"
        textLineCreateVbat.text = iphone5s ? "Vbat:\t\(vatt)V" : "Vbat:\t\t\(vatt)V"
        textLineCreateID.text = iphone5s ? "ID:\t\t\(id)" : "ID:\t\t\t\(id)"
        let vatDouble = Double(vatt)
        bgImageBattary1.isHidden = true
        bgImageBattary2.isHidden = true
        bgImageBattary3.isHidden = true
        if vatDouble != nil {
            if 3.4 <= vatDouble!{
                bgImageBattary1.isHidden = false
                bgImageBattary2.isHidden = false
                bgImageBattary3.isHidden = false
            }
            if 3.0 <= vatDouble! && 3.4 > vatDouble!{
                bgImageBattary1.isHidden = false
                bgImageBattary2.isHidden = false
                bgImageBattary3.isHidden = true

            }
            if 2.0 <= vatDouble! && 3.0 > vatDouble!{
                bgImageBattary1.isHidden = false
                bgImageBattary2.isHidden = true
                bgImageBattary3.isHidden = true
            }
            if 2.0 > vatDouble!{
                bgImageBattary1.isHidden = true
                bgImageBattary2.isHidden = true
                bgImageBattary3.isHidden = true
            }
        }
        if Int(RSSIMain) ?? -100 >= -60 {
            bgImageSignal.isHidden = false
            bgImageSignal2.isHidden = false
            bgImageSignal3.isHidden = false
        }
        if Int(RSSIMain) ?? -100 <= -61 && Int(RSSIMain) ?? -100 >= -85 {
            bgImageSignal.isHidden = false
            bgImageSignal2.isHidden = false
            bgImageSignal3.isHidden = true
        }
        if Int(RSSIMain) ?? -100 <= -86 && Int(RSSIMain) ?? -100 >= -110 {
            bgImageSignal.isHidden = false
            bgImageSignal2.isHidden = true
            bgImageSignal3.isHidden = true
        }
        if isNight {
            textLineCreateCopy.image = #imageLiteral(resourceName: "copy")
        } else {
            textLineCreateCopy.image = #imageLiteral(resourceName: "Group-2")
        }
        
        let cntMain1: Int = Int(cnt1)!
        cnt1 = cnt2
        let cntMain2: Int = Int(cnt2)!
        let abc:Double = Double(abs(cntMain1-cntMain2))/Double(cntMain1/100)
        print("abc: \(abc)")
        if abc > 1 {
            itemColor = 0
//            lbl4.text = "Not stable".localized(code)
//            statusDeviceY = "Not stable".localized(code)
//            lbl4.textColor = UIColor(rgb: 0xCF2121)
            item = 1
        } else {
            itemColor = 1
//            lbl4.text = "Stable".localized(code)
            statusDeviceY = "Stable".localized(code)
//            lbl4.textColor = UIColor(rgb: 0x00A778)
        }
        if temp != nil {
            statusName.text = "Connected".localized(code)
            statusName.textColor = UIColor(rgb: 0x00A778)
        } else {
            statusName.text = "Disconnected".localized(code)
            statusName.textColor = UIColor(rgb: 0xCF2121)
            itemColor = 0
//            lbl4.text = "Not stable".localized(code)
            statusDeviceY = "Not stable".localized(code)
//            lbl4.textColor = UIColor(rgb: 0xCF2121)
            item = 0
        }
//        var y = Int(screenHeight / 1.67) + 100
//        if screenHeight == 812.0{
//            y = y - 15
//        }
//        statusName.frame.origin = CGPoint(x: 30, y: y)
//        y = Int(screenHeight / 1.67) + 100 + (hasNotch ? 30 : 40)
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            footer.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            cellSettingName.theme.textColor = themed{ $0.navigationTintColor }
            cellSettingAddName.theme.textColor = themed{ $0.navigationTintColor }
            cellHelpName.theme.textColor = themed{ $0.navigationTintColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
            textLineCreateLevel.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateMode.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateEvent.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateRssi.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateVbat.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateID.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateTempText.theme.textColor = themed{ $0.navigationTintColor }
            textLineCreateTemp.theme.tintColor = themed{ $0.navigationTintColor }
            textLineCreateName.theme.textColor = themed{ $0.navigationTintColor }
            sensorImage.theme.tintColor = themed{ $0.navigationTintColor }
            bgImageSignal.theme.tintColor = themed{ $0.navigationTintColor }
            bgImageSignal2.theme.tintColor = themed{ $0.navigationTintColor }
            bgImageSignal3.theme.tintColor = themed{ $0.navigationTintColor }
            bgImageBattary.theme.tintColor = themed{ $0.navigationTintColor }
            bgImageBattary1.theme.backgroundColor = themed{ $0.navigationTintColor }
            bgImageBattary2.theme.backgroundColor = themed{ $0.navigationTintColor }
            bgImageBattary3.theme.backgroundColor = themed{ $0.navigationTintColor }
            cellSettingSeparetorTwo.theme.backgroundColor = themed{ $0.navigationTintColor }
            cellSettingSeparetor.theme.backgroundColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellSettingName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellSettingAddName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellHelpName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateLevel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateMode.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateEvent.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateRssi.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateVbat.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateID.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateTempText.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateTemp.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            textLineCreateName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            sensorImage.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageSignal.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageSignal2.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageSignal3.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageBattary.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageBattary1.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageBattary2.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            bgImageBattary3.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellSettingSeparetorTwo.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellSettingSeparetor.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            footer.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
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

extension DeviceDUBleController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark)
    }
}
