//
//  DevicesListController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 10.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import CoreBluetooth
import UIDrawer


class DevicesListController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, SecondVCDelegate {
    
    func secondVC_BackClicked(data: String) {
        viewShow()
    }
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: headerHeight, width: screenWidth, height: 35))
    var refreshControl = UIRefreshControl()
    var attributedTitle = NSAttributedString()
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    let popUpVCNext = UIStoryboard(name: "MainSelf", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopupViewController // 1
    var peripherals = [CBPeripheral]()
    var manager:CBCentralManager? = nil
    let DeviceBLEC = DeviceBleController()
    var timer = Timer()
    var stringAll: String = ""
    var iter = false
    var parsedData:[String : AnyObject] = [:]
    var bluetoothPeripheralManager: CBPeripheralManager?
    
    func centralManagerDidUpdateState (_ central : CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            let peripheralsArray = Array(peripherals)
            print(peripheralsArray)
            print("ON Работает.")
        }
        else {
            print("Bluetooth OFF.")
            let alert = UIAlertController(title: "Bluetooth off".localized(code), message: "For further work, you must enable Bluetooth".localized(code), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    self.navigationController?.popViewController(animated: true)
                    self.view.subviews.forEach({ $0.removeFromSuperview() })
                    
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
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let key = "kCBAdvDataServiceUUIDs"
        print("advertisementData: \(advertisementData)")
        if peripheral.name != nil {
            let nameDevicesOps = peripheral.name!.components(separatedBy: ["_"])
            if nameDevicesOps[0] == "TD" && nameDevicesOps[1] != "UPDATE" {
                if QRCODE == "" {
                    let abc = advertisementData[key] as? [CBUUID]
                    guard let uniqueID = abc?.first?.uuidString else { return }
                    _ = uniqueID.components(separatedBy: ["-"])
                    if(!peripherals.contains(peripheral)) {
                        if RSSI != 127{
                            peripherals.append(peripheral)
                            RSSIMainArray.append("\(RSSI)")
                            peripheralName.append(peripheral.name!)
                            print("RSSIName: \(peripheral.name!) and  RSSI: \(RSSI)")
                        }
                    }
                } else {
                    let abc = advertisementData[key] as? [CBUUID]
                    guard let uniqueID = abc?.first?.uuidString else { return }
                    _ = uniqueID.components(separatedBy: ["-"])
                    if(!peripherals.contains(peripheral)) {
                        if peripheral.name! == "TD_\(QRCODE)" {
                            nameDevice = ""
                            print("YEEEES \(peripheral.name!)")
                            temp = nil
                            self.activityIndicator.startAnimating()
                            self.view.addSubview(self.viewAlpha)
                            zeroTwo = 0
                            zero = 0
                            countNot = 0
                            self.manager?.connect(peripheral, options: nil)
                            self.view.isUserInteractionEnabled = false
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                            stopScanForBLEDevices()
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                                if let navController = self.navigationController {
                                    navController.pushViewController(DeviceBleController(), animated: true)
                                }
                                print("Connected to " +  peripheral.name!)
                                self.viewAlpha.removeFromSuperview()
                                self.view.subviews.forEach({ $0.removeFromSuperview() })
                                while let subview = self.scrollView.subviews.last {
                                    subview.removeFromSuperview()
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        RSSIMain = "\(RSSI)"
    }
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
//        let nameD = peripheral.name!
//        let nameDOps = nameD.components(separatedBy: ["_"])
//        nameDevice = nameDOps[1]
        timer =  Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (timer) in
            peripheral.discoverServices(nil)
            if peripheral.state == CBPeripheralState.connected {
                print("connectedP")
                checkQR = true
            }
            if peripheral.state == CBPeripheralState.disconnected {
                print("disconnectedP")
                if warning == true{
                    timer.invalidate()
                    self.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    timer.invalidate()
                    self.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                    let alert = UIAlertController(title: "Warning".localized(code), message: "Connection is lost.".localized(code), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            self.dismiss(animated: true, completion: nil)
                            self.dismiss(animated: true, completion: nil)
                            let  vc =  self.navigationController?.viewControllers.filter({$0 is DeviceSelectController}).first
                            self.navigationController?.popToViewController(vc!, animated: true)
                            self.view.subviews.forEach({ $0.removeFromSuperview() })
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
                warning = false
            }
            if peripheral.state == CBPeripheralState.connecting {
                print("connectingP")
            }
            if peripheral.state == CBPeripheralState.disconnecting {
                print("disconnectingP")
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            stringAll = ""
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        let valueAll = "GA\r"
        let valueReload = "PR,PW:1:\(mainPassword)"
        let FullReload = "SH,PW:1:"
        let NothingReload = "SL,PW:1:"
        let ReloadFN = "\(mainPassword)\r"
        let sdVal = "SD,HK:1:1024\r"
        let sdValTwo = "SD,HK:1:\(full)"
        let sdValThree = "SD,LK:1:\(nothing)"
        let sdValTwo1 = "SD,HK:1:\(full),"
        let sdValThree1 = "SD,LK:1:\(nothing),"
        let sdParam = "SW,WM:1:\(wmPar),"
        let sdParamYet = "PW:1:\(mainPassword)"
        let passZero = "SP,PN:1:0\r"
        let passDelete = "SP,PN:1:0,"
        let passInstall = "SP,PN:1:\(mainPassword)\r"
        let enterPass = "SP,PN:1:\(mainPassword),"
        let r = "\r"
        
        print("sdParam: \(sdParam)")
        print("sdValTwo: \(sdValTwo)")
        print("passInstall: \(passInstall)")
        
        let dataAll = withUnsafeBytes(of: valueAll) { Data($0) }
        let dataReload = Data(valueReload.utf8)
        let dataFullReload = Data(FullReload.utf8)
        let dataNothingReload = Data(NothingReload.utf8)
        let dataSdVal = withUnsafeBytes(of: sdVal) { Data($0) }
        let dataSdValTwo = Data(sdValTwo.utf8)
        let dataSdValThree = Data(sdValThree.utf8)
        let dataSdValTwo1 = Data(sdValTwo1.utf8)
        let dataSdValThree1 = Data(sdValThree1.utf8)
        let dataSdParam = Data(sdParam.utf8)
        let dataSdParamYet = Data(sdParamYet.utf8)
        let dataPassZero = Data(passZero.utf8)
        let dataPassDelete = Data(passDelete.utf8)
        let dataPassInstall = Data(passInstall.utf8)
        let dataPassEnter = Data(enterPass.utf8)
        let dataR = Data(r.utf8)
        let dataReloadFN = Data(ReloadFN.utf8)
        
        for characteristic in service.characteristics! {
            if characteristic.properties.contains(.notify) {
                print("Свойство \(characteristic.uuid): .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        for characteristic in service.characteristics! {
            if characteristic.properties.contains(.write) {
                print("Свойство \(characteristic.uuid): .write")
                peripheral.writeValue(dataAll, for: characteristic, type: .withResponse)
            }
        }
        if zero == 0 {
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataPassZero, for: characteristic, type: .withResponse)
                    zero = 1
                    zeroTwo = 0
                }
            }
        }
        if reload == 1{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataReload, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 2{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataFullReload, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataReloadFN, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 3{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataNothingReload, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataReloadFN, for: characteristic, type: .withResponse)
                    
                    reload = 0
                }
            }
        }
        if reload == 4{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataSdVal, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 5{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataSdValTwo, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataSdValThree, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    
                    reload = 0
                }
            }
        }
        if reload == 10{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataSdValTwo1, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataSdValThree1, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    
                    reload = 0
                }
            }
        }
        if reload == 6{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataSdParam, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    print("\(sdParam)")
                    reload = 0
                    print("dataSdParam: \(dataSdParam)")
                    print("dataSdParamYet: \(dataSdParamYet)")
                }
            }
        }
        if reload == 7{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataPassDelete, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    
                    reload = 0
                }
            }
        }
        if reload == 8{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataPassInstall, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 9{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataPassEnter, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    
                    reload = 0
                }
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
    }
    
    let string: String = ""
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        peripheral.readRSSI()
        print("READ: \(characteristic)")
        let rxData = characteristic.value
        if let rxData = rxData {
            let numberOfBytes = rxData.count
            var rxByteArray = [UInt8](repeating: 0, count: numberOfBytes)
            (rxData as NSData).getBytes(&rxByteArray, length: numberOfBytes)
            let string = String(data: Data(rxByteArray), encoding: .utf8)
            stringAll = stringAll + string!
            let result = stringAll.components(separatedBy: [":",",","\r"])
            if result.count >= 35 {
                print(result)
                if result.contains("SE") {
                    let indexOfPerson = result.firstIndex{$0 == "SE"}
                    print(indexOfPerson!)
                    nameDevice = "\(result[indexOfPerson! + 2])"
                    nameDeviceT = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("UT") {
                    let indexOfPerson = result.firstIndex{$0 == "UT"}
                    temp = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("UL") {
                    let indexOfPerson = result.firstIndex{$0 == "UL"}
                    level = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("VB") {
                    let indexOfPerson = result.firstIndex{$0 == "VB"}
                    vatt = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("UD") {
                    let indexOfPerson = result.firstIndex{$0 == "UD"}
                    print(indexOfPerson!)
                    id = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("LK") {
                    let indexOfPerson = result.firstIndex{$0 == "LK"}
                    print(indexOfPerson!)
                    nothing = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("HK") {
                    let indexOfPerson = result.firstIndex{$0 == "HK"}
                    print(indexOfPerson!)
                    print(warning)
                    full = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("US") {
                    let indexOfPerson = result.firstIndex{$0 == "US"}
                    print(indexOfPerson!)
                    cnt = "\(result[indexOfPerson! + 2])"
                    if iter == false {
                        cnt1 = result[indexOfPerson! + 2]
                        iter = true
                    } else {
                        cnt2 = result[indexOfPerson! + 2]
                    }
                }
                if result.contains("APO") {
                    passNotif = 0
                    passwordSuccess = true
                    print("APO 0")
                }
                if result.contains("ADO") {
                    passNotif = 0
                    passwordSuccess = true
                    errorWRN = false
                    print("ADO 0")
                }
                if result.contains("WRN") {
                    passNotif = 1
                    passwordSuccess = false
                    print("WRN 1")
                    
                }
                if result.contains("VV") {
                    let indexOfPerson = result.firstIndex{$0 == "VV"}
                    VV = "\(result[indexOfPerson! + 2])"
                    VV.insert(".", at: VV.index(VV.startIndex, offsetBy: 1))
                    VV.insert(".", at: VV.index(VV.startIndex, offsetBy: 3))
                }
                if result.contains("WRN") {
                    errorWRN = true
                }
                if result.contains("WM") {
                    let indexOfPerson = result.firstIndex{$0 == "WM"}
                    if result.count >= indexOfPerson!+2{
                        wmMax = "\(result[indexOfPerson! + 2])"
                        if let wmMaxUINt = Int(wmMax) {
                            wmMaxInt = wmMaxUINt
                        }
                    }
                }
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("error: \(error)")
            return
        }

    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
        
    }
    private func centralManager(
        central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: NSError?) {
        scanBLEDevices()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        searchBar.delegate = self
        manager = CBCentralManager ( delegate : self , queue : nil , options : nil )
        viewShow()
    }
    
    var tr = 0
    var container2 = UIView(frame: CGRect(x: 20, y: 50, width: Int(screenWidth-40), height: 70))
    @objc func refresh(sender:AnyObject) {
        RSSIMainArray = []
        peripheralName = []
        scanBLEDevices()
        activityIndicator.startAnimating()
        self.view.addSubview(viewAlpha)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.viewAlpha.removeFromSuperview()
                self.activityIndicator.stopAnimating()
            }
            self.mainPartShow()
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.refreshControl.endRefreshing()
            while let subview = self.scrollView.subviews.last {
                subview.removeFromSuperview()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        searchBar.text = ""
        mainPassword = ""
        searchBarCancelButtonClicked(searchBar)
        self.searchBar.endEditing(true)
        self.view.isUserInteractionEnabled = true
        attributedTitle = NSAttributedString(string: "Wait".localized(code), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        popUpVCNext.delegate = self
        if tr != 0{
            viewShow()
            tr += 1
        }
        scanBLEDevices()
        rightCount = 0
        searchBarCancelButtonClicked(searchBar)
    }
    
    func scanBLEDevices() {
        peripherals.removeAll()
        manager?.scanForPeripherals(withServices: nil)
        self.view.isUserInteractionEnabled = false
        var time = 0.0
        if QRCODE != "" {
            time = 7.0
        }
        //stop scanning after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0 + time) {
            self.stopScanForBLEDevices()
            print("Stop")
            if QRCODE != "" {
                if checkPopQR == false {
                    self.timer.invalidate()
                    self.navigationController?.popViewController(animated: true)
                    checkPopQR = true
                }
            }
            self.view.isUserInteractionEnabled = true
        }
    }
    func stopScanForBLEDevices() {
        manager?.stopScan()
    }
    
    fileprivate lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    fileprivate lazy var scrollViewS: UIScrollView = {
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
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.center = view.center
        activity.color = .white
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    
    fileprivate lazy var hamburger: UIImageView = {
        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
        hamburger.image = hamburger.image!.withRenderingMode(.alwaysTemplate)

        return hamburger
    }()
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        while let subview = self.scrollView.subviews.last {
            subview.removeFromSuperview()
        }
    }
    private func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let (headerView, backView) = headerSet(title: "List of available devices".localized(code), showBack: true)
            self.view.addSubview(headerView)
            self.view.addSubview(backView!)
            self.view.addSubview(self.viewAlpha)
            backView!.addTapGesture{
                self.navigationController?.popViewController(animated: true)
            }
        }
        view.addSubview(bgImage)
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            if QRCODE == "" {
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.viewAlpha.removeFromSuperview()
                self.view.backgroundColor = UIColor(rgb: 0x1F2222).withAlphaComponent(1)
                self.activityIndicator.stopAnimating()
            }
            self.mainPartShow()
            
        }
        
    }
    
    var searching = false
    var searchedCountry = [String]()
    var aaa = [String]()
    
    private func mainPartShow() {
        
        aaa.removeAll()
        let hamburgerPlace = UIView()
        var yHamb = screenHeight/22
        if screenWidth == 414 {
            yHamb = screenHeight/20
        }
        if screenHeight >= 750{
            yHamb = screenHeight/16
            if screenWidth == 375 {
                yHamb = screenHeight/19
            }
        }
        hamburgerPlace.frame = CGRect(x: screenWidth-50, y: yHamb, width: 35, height: 35)
        hamburger.frame = CGRect(x: screenWidth-45, y: yHamb, width: 25, height: 25)

        view.addSubview(hamburger)
        view.addSubview(hamburgerPlace)
        
        
        hamburgerPlace.addTapGesture {
            let viewController = MenuControllerDontLanguage()
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = self
            self.present(viewController, animated: true)
        }
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = false
        searchBar.tintColor = .white
        searchBar.textColor = .white
        searchBar.keyboardType = UIKeyboardType.decimalPad
        view.addSubview(searchBar)
        
        print("peripherals: \(peripherals)")
        let data = peripherals
        
        scrollView.addSubview(refreshControl)
        view.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight + 40).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        let cellHeight = 70
        var y = 0
        var yS = 0
        
        
        for (i, peripheral) in data.enumerated() {
            manager?.cancelPeripheralConnection(peripheral)
            container2 = UIView(frame: CGRect(x: 20, y: Int(y), width: Int(screenWidth-40), height: 70))
            //            container2.separatorColor = .clear
            container2.backgroundColor = .clear
            
            
            let title = UILabel(frame: CGRect(x: 0, y: 20, width: Int(screenWidth/2), height: 20))
            title.text = peripheral.name
            let abc = peripheral.name!
            if aaa.contains(abc) {
                
            } else {
                aaa.append(abc)
                //                aaa.shuffle()
                print("searchedCountry: \(aaa)")
            }
            
            
            title.textColor = .white
            title.font = UIFont(name:"FuturaPT-Light", size: 24.0)
            
            let titleRSSI = UILabel(frame: CGRect(x: 30, y: 50, width: Int(screenWidth/2), height: 10))
            peripheral.readRSSI()
            titleRSSI.text = "\(RSSIMainArray[i]) dBm"
            titleRSSI.textColor = .white
            titleRSSI.font = UIFont(name:"FuturaPT-Light", size: 14.0)
            
            let titleRSSIImage = UIImageView(frame: CGRect(x: 5, y: 50, width: 17, height: 11))
            titleRSSIImage.image = #imageLiteral(resourceName: "dBm")
            
            let btn = UIView(frame: CGRect(x: Int(screenWidth-140-40), y: 12, width: 140, height: 44))
            btn.backgroundColor = UIColor(rgb: 0xCF2121)
            btn.layer.cornerRadius = 22
            
            let connect = UILabel(frame: CGRect(x: Int(btn.frame.origin.x), y: Int(btn.frame.origin.y), width: Int(btn.frame.width), height: Int(btn.frame.height)))
            connect.text = "Connect".localized(code)
            connect.textColor = .white
            connect.font = UIFont(name:"FuturaPT-Medium", size: 18.0)
            connect.textAlignment = .center
            
            let separator = UIView(frame: CGRect(x: 0, y: cellHeight, width: Int(screenWidth-40), height: 1))
            separator.backgroundColor = UIColor(rgb: 0x959595)
            
            
            
            
            if searching{
                if searchedCountry.contains(title.text!) {
                    view.addSubview(scrollViewS)
                    
                    scrollViewS.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
                    scrollViewS.topAnchor.constraint(equalTo: view.topAnchor, constant: headerHeight + 40).isActive = true
                    scrollViewS.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
                    scrollViewS.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                    scrollView.removeFromSuperview()
                    
                    container2.frame = CGRect(x: 20, y: Int(yS), width: Int(screenWidth-40), height: cellHeight+10)
                    view.addSubview(scrollViewS)
                    container2.addSubview(btn)
                    container2.addSubview(title)
                    container2.addSubview(titleRSSI)
                    container2.addSubview(titleRSSIImage)
                    container2.addSubview(connect)
                    container2.addSubview(separator)
                    scrollViewS.addSubview(container2)
                    
                    yS = yS + cellHeight
                    
                }
                
                
            } else {
                
                container2.addSubview(btn)
                container2.addSubview(connect)
                container2.addSubview(title)
                container2.addSubview(titleRSSI)
                container2.addSubview(titleRSSIImage)
                container2.addSubview(separator)
                scrollView.addSubview(container2)
                
                
            }
            connect.addTapGesture {
                temp = nil
                nameDevice = ""
                DeviceIndex = i
                self.activityIndicator.startAnimating()
                self.view.addSubview(self.viewAlpha)
                zeroTwo = 0
                zero = 0
                countNot = 0
                self.manager?.connect(peripheral, options: nil)
                self.view.isUserInteractionEnabled = false
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    if let navController = self.navigationController {
                        navController.pushViewController(DeviceBleController(), animated: true)
                    }
                    print("Connected to " +  peripheral.name!)
                    self.viewAlpha.removeFromSuperview()
                    self.view.subviews.forEach({ $0.removeFromSuperview() })
                    while let subview = self.scrollView.subviews.last {
                        subview.removeFromSuperview()
                    }
                })
            }
            
            y = y + cellHeight
        }
        if data.count > 10 {
            scrollView.contentSize = CGSize(width: Int(screenWidth), height: data.count * cellHeight+40)
            
        } else {
            scrollView.contentSize = CGSize(width: Int(screenWidth), height: Int(screenHeight-39))
        }
        if data.count > 10 {
            scrollViewS.contentSize = CGSize(width: Int(screenWidth), height: data.count * cellHeight+40)
            
        } else {
            scrollViewS.contentSize = CGSize(width: Int(screenWidth), height: Int(screenHeight-39))
        }
        tr = 1
        //delete keyboard
        scrollView.addTapGesture {
            self.searchBar.endEditing(true)
            print("scrollView")
        }
        scrollViewS.addTapGesture {
            self.searchBar.endEditing(true)
            print("scrollViewS")
        }
        
    }
}
extension DevicesListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedCountry = aaa.filter({$0.lowercased().contains(searchText)})
        searching = true
        scrollViewS.subviews.forEach({ $0.removeFromSuperview() })
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        if searchText == "" {
            searchBarCancelButtonClicked(searchBar)
        }
        
        mainPartShow()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        scrollViewS.subviews.forEach({ $0.removeFromSuperview() })
        scrollView.subviews.forEach({ $0.removeFromSuperview() })
        searching = false
        searchBar.text = ""
        mainPartShow()
    }
    
}

extension CBPeripheralState {
    
    // MARK: - CustomStringConvertible
    public var description: String {
        switch self {
        case .connected:
            return LocalizedString("Connected", comment: "The connected state")
        case .connecting:
            return LocalizedString("Connecting", comment: "The in-progress connecting state")
        case .disconnected:
            return LocalizedString("Disconnected", comment: "The disconnected state")
        case .disconnecting:
            return LocalizedString("Disconnecting", comment: "The in-progress disconnecting state")
        @unknown default:
            fatalError()
        }
    }
}

extension DevicesListController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
