//
//  TLController.swift
//  Escort
//
//  Created by Володя Зверев on 04.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit

class TLController: UIViewController {
    
    var viewModel: ViewModelDevice = ViewModelDevice()
    var tableView: UITableView!
    weak var delegate: ConnectedDelegate?
    var refreshControl = UIRefreshControl()
    var timer = Timer()
    let generator = UIImpactFeedbackGenerator(style: .light)
    var deviceTLVC = TLTHSettingsController()
    let blackBoxVC = BlackBoxTHController()
    var newPassword = true
        
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    var attributedTitle = NSAttributedString()
    var count = 0
    var timerTrue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(bgImage)
        createFooter()
        createTableView()
        registerCell()
//        viewShow()
        NSLayoutConstraint.activate([
            
            self.tableView.topAnchor.constraint(equalTo: view.topAnchor ),
            self.tableView.bottomAnchor.constraint(equalTo: footer.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])
        setupTheme()
    }
    
    func createFooter() {
        let footerCellWidth = Int(screenWidth/2), footerCellHeight = 90
        
        let cellSetting = UIView(frame: CGRect(x: 0, y: 0, width: footerCellWidth, height: footerCellHeight))

        cellSetting.addSubview(cellSettingIcon)
        cellSetting.addSubview(cellSettingAddName)


        cellSetting.addTapGesture { [self] in
            deviceTLVC.delegate = self
            deviceTLVC.delegateAlert = self
            deviceTLVC.viewModel = viewModel
            deviceTLVC.labelMain = "Settings"
//            deviceTLVC.passwortIsEnter = false
            self.navigationController?.pushViewController(deviceTLVC, animated: true)
        }

        footer.addSubview(cellSetting)
        footer.addSubview(cellHelp)
        
        view.addSubview(footer)
    }
    @objc func refresh(sender:AnyObject) {
        timerAction()
    }
    
    fileprivate func createTableView() {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.allowsSelection = false
        tableView.addSubview(sensorImage)
        tableView.refreshControl = refreshControl
        self.tableView = tableView
    }
    fileprivate func registerCell() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NumberDeviceCell.self, forCellReuseIdentifier: "NumberDeviceCell")
        tableView.register(SignalCell.self, forCellReuseIdentifier: "SignalCell")
        tableView.register(TempCell.self, forCellReuseIdentifier: "TempCell")
        tableView.register(IDDeviceCell.self, forCellReuseIdentifier: "IDDeviceCell")
        tableView.register(StableDeviceCell.self, forCellReuseIdentifier: "StableDeviceCell")
        tableView.register(RedLineCell.self, forCellReuseIdentifier: "RedLineCell")
        tableView.register(IdCopyCell.self, forCellReuseIdentifier: "IdCopyCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let attributes = [NSAttributedString.Key.foregroundColor: isNight ? UIColor.white : UIColor.black]
        attributedTitle = NSAttributedString(string: "Wait".localized(code), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = isNight ? .white : .black
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        item = 0
        police = false
        if viewModel.passwordFirst == true {
            reload = 20
            delegate?.buttonTap()
            viewModel.passwordFirst = false
        }
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        if reloadBack == 1{
            self.navigationController?.popViewController(animated: true)
            timerTrue = 0
            reloadBack = 0
        }
    }
    @objc func timerAction(){
        reload = 0
        delegate?.buttonTap()
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        return img
    }()
    
    fileprivate lazy var sensorImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "tlBleBack")!)
        img.frame.origin = CGPoint(x: screenWidth/2, y: screenHeight / 5 - (iphone5s ? 70 : 70))
        img.center.x = screenWidth / 4 * 3
        img.sizeToFit()
        img.image = img.image!.withRenderingMode(.alwaysTemplate)
        return img
    }()

    fileprivate lazy var cellHelpIcon: UIImageView = {
        let cellHelpIcon = UIImageView(image: UIImage(named: viewModel.isTL ? (isNight ? "boxquestion-white" : "boxquestion-black") : (isNight ? "blackboxicon-white" : "blackboxicon-black"))!)
        cellHelpIcon.frame = CGRect(x: 1, y: 0, width: 47, height: 47)
        cellHelpIcon.center = CGPoint(x: screenWidth / 4, y: 90 / 2 - 15)
        return cellHelpIcon
    }()

    fileprivate lazy var cellHelp: UIView = {
        let footerCellWidth = Int(screenWidth/2), footerCellHeight = 90
        let cellHelp = UIView(frame: CGRect(x: footerCellWidth, y: 0, width: footerCellWidth, height: footerCellHeight))
        cellHelp.addSubview(cellHelpIcon)
        cellHelp.addSubview(cellSettingName)
        cellHelp.addSubview(cellSettingSeparetor)
        return cellHelp
    }()

    fileprivate lazy var footer: UIView = {
    let footer = UIView(frame: CGRect(x: 0, y: screenHeight - 180, width: screenWidth, height: 90))
        footer.layer.shadowRadius = 3.0
        footer.layer.shadowOpacity = 0.2
        footer.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        return footer
    }()
    fileprivate lazy var cellSettingAddName: UILabel = {
        let cellSettingAddName = UILabel(frame: CGRect(x: 0, y: 55, width: Int(screenWidth/2), height: 20))
        cellSettingAddName.text = "Settings".localized(code)
        cellSettingAddName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellSettingAddName.textAlignment = .center
        return cellSettingAddName
    }()
    fileprivate lazy var cellSettingIcon: UIImageView = {
        let footerCellWidth = Int(screenWidth/4), footerCellHeight = 90 / 2 - 15
        
        let cellSettingIcon = UIImageView(image: UIImage(named: isNight ? "settings" : "settings-black")!)
        cellSettingIcon.frame = CGRect(x: 0, y: 0, width: 47, height: 47)
        cellSettingIcon.center = CGPoint(x: footerCellWidth, y: footerCellHeight)
        return cellSettingIcon
    }()
    fileprivate lazy var cellSettingName: UILabel = {
        let cellSettingName = UILabel(frame: CGRect(x: 0, y: 55, width: Int(screenWidth/2), height: 20))
        cellSettingName.text = "Reference".localized(code)
        cellSettingName.font = UIFont(name:"FuturaPT-Light", size: 14.0)
        cellSettingName.textAlignment = .center
        return cellSettingName
    }()

    fileprivate lazy var cellSettingSeparetor: UIView = {
        let cellSettingSeparetor = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 90))
        cellSettingSeparetor.alpha = 0.1
        return cellSettingSeparetor
    }()
    fileprivate lazy var degreeIcon: UIImageView = {
        let degreeIcon = UIImageView(image: UIImage(named: "temp")!)
        degreeIcon.frame = CGRect(x: 20, y: 0, width: 18, height: 31)
        degreeIcon.image = degreeIcon.image!.withRenderingMode(.alwaysTemplate)

        return degreeIcon
    }()

    override func viewWillDisappear(_ animated: Bool) {
        warning = true
        timer.invalidate()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationCusmotizing(nav: navigationController!, navItem: navigationItem, title: (viewModel.isTL ? "TL" : "TH") + " BLE \(nameDevice)")
        sensorImage.image = (viewModel.isTL ? UIImage(named: "tlBleBack") : UIImage(named: "th-Icon"))
        cellHelpIcon.image = UIImage(named: viewModel.isTL ? (isNight ? "boxquestion-white" : "boxquestion-black") : (isNight ? "blackboxicon-white" : "blackboxicon-black"))
        sensorImage.sizeToFit()
        sensorImage.image = sensorImage.image!.withRenderingMode(.alwaysTemplate)
        cellSettingName.text = (viewModel.isTL ? "Reference".localized(code) : "Black box".localized(code))
        cellSettingAddName.text = "Settings".localized(code)
        cellHelpAction(isTL: viewModel.isTL)
        
        setupTheme()
        tableView.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.timerTrue = 0
        self.timer.invalidate()
    }
    func cellHelpAction(isTL : Bool) {
        if viewModel.isTL {
            cellHelp.addTapGesture {
                print("Reference")
            }
        } else {
            cellHelp.addTapGesture { [self] in
                generator.impactOccurred()
                nextPushBlackBox()
            }
        }
    }
    func nextPushBlackBox() {
        blackBoxVC.delegate = self
        blackBoxVC.viewModel = viewModel
        navigationController?.pushViewController(blackBoxVC, animated: true)
    }
    
    
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            footer.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            cellSettingName.theme.textColor = themed{ $0.navigationTintColor }
            cellSettingAddName.theme.textColor = themed{ $0.navigationTintColor }
            sensorImage.theme.tintColor = themed{ $0.navigationTintColor }
            cellSettingSeparetor.theme.backgroundColor = themed{ $0.navigationTintColor }
            degreeIcon.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            cellSettingName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellSettingAddName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            sensorImage.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cellSettingSeparetor.backgroundColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            degreeIcon.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            footer.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
        }
        cellSettingIcon.image = UIImage(named: isNight ? "settings" : "settings-black")
    }
}
extension TLController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        navigationItem.title = "\(viewModel.isTL ? "TL" : "TH") \(nameDevice)".localized(code)
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignalCell", for: indexPath) as! SignalCell
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
            guard let rssiInt: Int = Int(RSSIMain),
                  let vtDouble : Double  = Double(vatt) else {
                cell.signalUI.image = viewModel.signal[0]
                cell.batUI.image = viewModel.battery[0]
                cell.signalUI.image = cell.signalUI.image!.withRenderingMode(.alwaysTemplate)
                cell.signalUI.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
                cell.batUI.image = cell.signalUI.image!.withRenderingMode(.alwaysTemplate)
                cell.batUI.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
                return cell
            }
            switch vtDouble {
            case 3.5 ... 5.0:
                cell.batUI.image = viewModel.battery[3]
            case 3.3 ... 3.49:
                cell.batUI.image = viewModel.battery[2]
            case 3.0 ... 3.29:
                cell.batUI.image = viewModel.battery[1]
            default:
                cell.batUI.image = viewModel.battery[0]
            }
            switch rssiInt {
            case -49...0:
                cell.signalUI.image = viewModel.signal[4]
            case -59 ... -50:
                cell.signalUI.image = viewModel.signal[3]
            case -74 ... -60:
                cell.signalUI.image = viewModel.signal[2]
            case -90 ... -75:
                cell.signalUI.image = viewModel.signal[1]
            default:
                cell.signalUI.image = viewModel.signal[0]
            }
            cell.signalUI.image = cell.signalUI.image!.withRenderingMode(.alwaysTemplate)
            cell.signalUI.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cell.batUI.image = cell.batUI.image!.withRenderingMode(.alwaysTemplate)
            cell.batUI.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cell.label.text = RSSIMain + " dBm"
            cell.labelPassword.text = vatt + " V"
            if rssiInt >= -85 {
                cell.label.textColor = viewModel.colorConnected.last
            } else {
                cell.label.textColor = viewModel.colorConnected.first
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IDDeviceCell", for: indexPath) as! IDDeviceCell
            cell.labelNumber.text = "№ " + nameDevice
            cell.labelVersion.text = "FW: " + VV
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RedLineCell", for: indexPath) as! RedLineCell
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TempCell", for: indexPath) as! TempCell
            cell.label.text = (temp ?? "0") + " °C"
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
            return cell
            
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberDeviceCell", for: indexPath) as! NumberDeviceCell
            cell.label.text = viewModel.isTL ? "Level".localized(code) :  "\(viewModel.thParametrs[indexPath.section])".localized(code)
            cell.labelPassword.text = level + (viewModel.isTL ? " lux" : " %")
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
            return cell
        } else if  indexPath.section == (viewModel.isTL ? 5 : 7) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StableDeviceCell", for: indexPath) as! StableDeviceCell
            cell.labelNumber.text = "Connected".localized(code)
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
            return cell
        }else if  indexPath.section == (viewModel.isTL ? 50 : 5) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberDeviceCell", for: indexPath) as! NumberDeviceCell
            cell.label.text = viewModel.isTL ? "\(viewModel.tlParametrs[indexPath.section])".localized(code) : "\(viewModel.thParametrs[indexPath.section])".localized(code)
            cell.labelPassword.text = (viewModel.isTL ? "" : lum + " lux")
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
            return cell
        } else if indexPath.section == (viewModel.isTL ? 10 : 11) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberDeviceCell", for: indexPath) as! NumberDeviceCell
            cell.label.text = viewModel.isTL ? "\(viewModel.tlParametrs[indexPath.section])".localized(code) : "\(viewModel.thParametrs[indexPath.section])".localized(code)
            cell.labelPassword.text = pressure + " Па"
            cell.labelPassword.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
            return cell
        }  else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberDeviceCell", for: indexPath) as! NumberDeviceCell
            cell.label.text = viewModel.isTL ? "\(viewModel.tlParametrs[indexPath.section])".localized(code) : "\(viewModel.thParametrs[indexPath.section])".localized(code)
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.backgroundColor = .clear
            let nsString = NSString(string: magnetic)
            guard let boolManetic: Bool? = nsString.boolValue else {return cell}
            cell.labelPassword.text = boolManetic! ? "Active".localized(code) : "Inactive".localized(code)
            cell.labelPassword.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)

            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.isTL ? viewModel.tlParametrs.count : viewModel.thParametrs.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return hasNotch ? (screenHeight - 90) / (viewModel.isTL ? 20 : 20) : (screenHeight - 90) / (viewModel.isTL ? 15 : 15)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension TLController: PasswordDelegate, BlackBoxTHDelegate {
    func passwordAlert() {
        delegate?.enterPaswwordAlert(isNewPassword: false)
    }
    func newPasswordAlert() {
        delegate?.enterPaswwordAlert(isNewPassword: true)
    }
    
    func blackBoxTap() {
        delegate?.buttonTap()
    }
    
    func actionSetPassword() {
        delegate?.buttonTap()
    }
    
    func buttonReloadDevice() {
        delegate?.buttonTap()
//        delegate?.enterPaswwordAlert()
    }
    func actionDeletePassword() {
        delegate?.buttonTap()
    }

    func pushSaveData() {
        nextPushBlackBox()
    }
    
    
    @objc func copyAction() {
        UIPasteboard.general.string = id
        self.showToast(message: "Сopied to clipboard".localized(code) + ": \(id)", seconds: 1.0)
    }
}
