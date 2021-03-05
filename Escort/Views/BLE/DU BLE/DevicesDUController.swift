//
//  DeviceDUController.swift
//  Escort
//
//  Created by Володя Зверев on 03.02.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//


import UIKit
import CoreBluetooth
import UIDrawer
import RxSwift
import RxTheme

struct cellDataDU {
    var opened = Bool()
    var title = String()
    var sectionData = [String()]
}

class DevicesDUController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, ConnectedDelegate {
    
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    let searchController = UISearchController(searchResultsController: nil)
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: headerHeight + (iphone5s ? 10 : 0), width: screenWidth, height: 35))
    var attributedTitle = NSAttributedString()
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    var peripherals = [CBPeripheral]()
    var peripheralsSearch = [CBPeripheral]()
    var manager:CBCentralManager? = nil
    var timer = Timer()
    var timerConnection = Timer()
    var stringAll: String = ""
    var iter = false
    var parsedData:[String : AnyObject] = [:]
    var bluetoothPeripheralManager: CBPeripheralManager?
    var searchList = [String]()
    let generator = UIImpactFeedbackGenerator(style: .light)
    let duVC = DeviceDUBleController()
    let viewModel: ViewModelDevice = ViewModelDevice()
    var initialY: CGFloat!

    
    lazy var alertView: CustomAlert = {
        let alertView: CustomAlert = CustomAlert.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    
    lazy var alertViewNewPassword: CustomNewPasswordAlert = {
        let alertView: CustomNewPasswordAlert = CustomAlert.loadFromNib()
        alertView.delegate = self
        return alertView
    }()
    let visualEffectView: UIVisualEffectView = {
//        let blurEffect = UIBlurEffect(style: .dark)
       let view = UIVisualEffectView()
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            initialY = alertView.frame.origin.y
            initialY = alertViewNewPassword.frame.origin.y
            
            alertView.center.y = (screenHeight - CGFloat(keyboardSize.height)) / 2
            alertViewNewPassword.center.y = (screenHeight - CGFloat(keyboardSize.height)) / 2

        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        alertView.frame.origin.y = screenHeight / 2
        alertViewNewPassword.center.y = screenHeight / 2
    }
    let connectDaviceLabel: UILabel = {
        let connectDaviceLabel = UILabel()
        connectDaviceLabel.text = "Подключение"
        connectDaviceLabel.translatesAutoresizingMaskIntoConstraints = false
        connectDaviceLabel.textColor = .white
        connectDaviceLabel.clipsToBounds = false
        connectDaviceLabel.isHidden = true
        connectDaviceLabel.font = UIFont(name: "FuturaPT-Medium", size: 20)
        return connectDaviceLabel
    }()
    
//    let cancelLabel: UILabel = {
//        let cancelLabel = UILabel()
//        cancelLabel.text = "Отменить"
//        cancelLabel.translatesAutoresizingMaskIntoConstraints = false
//        cancelLabel.textColor = .red
//        cancelLabel.clipsToBounds = false
//        cancelLabel.isHidden = true
//        cancelLabel.font = UIFont(name: "FuturaPT-Medium", size: 20)
//        cancelLabel.layer.shadowColor = UIColor.white.cgColor
//        cancelLabel.layer.shadowRadius = 5.0
//        cancelLabel.layer.shadowOpacity = 0.7
//        cancelLabel.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//        return cancelLabel
//    }()
    var refreshControl: UIRefreshControl? = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .red
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
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
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        DispatchQueue.global(qos: .background).sync {
            let key = "kCBAdvDataServiceUUIDs"
            print("advertisementData: \(advertisementData)")
            if peripheral.name != nil {
                let nameDevicesOps = peripheral.name!.components(separatedBy: ["_"])
                let searchForName = "DU"
                if nameDevicesOps[0] == searchForName && nameDevicesOps[1] != "UPDATE" {
                    if QRCODE == "" {
                        print("advertisementData[kCBAdvDataManufacturerData]): \(kCBAdvDataManufacturerData)")
                        let abc = advertisementData[key] as? [CBUUID]
                        guard let uniqueID = abc?.first?.uuidString else { return }
                        _ = uniqueID.components(separatedBy: ["-"])
                        if(!peripherals.contains(peripheral)) {
                            if RSSI != 127{
                                let orderNum: NSNumber? = RSSI
                                let orderNumberInt  = orderNum?.intValue
                                if -71 < orderNumberInt! {
                                    rrsiPink = rrsiPink + 1
                                    print("rrsiPink:\(rrsiPink) \(orderNumberInt!)")
                                    peripherals.insert(peripheral, at:  rrsiPink - 1)
                                    peripheralName.insert(peripheral.name!, at: rrsiPink - 1)
                                    tableViewData.insert(cellDataDU(opened: false, title: "\(peripheral.name!)", sectionData: ["\(peripheral.name!)"]), at: rrsiPink)
                                    print("RSSIName: \(peripheral.name!) and  RSSI: \(RSSI)")
                                    RSSIMainArray.insert("\(RSSI)", at: rrsiPink)
                                } else {
                                    peripherals.append(peripheral)
                                    peripheralName.append(peripheral.name!)
                                    print("RSSIName: \(peripheral.name!) and  RSSI: \(RSSI)")
                                    tableViewData.append(cellDataDU(opened: false, title: "\(peripheral.name!)", sectionData: ["\(peripheral.name!)"]))
                                    RSSIMainArray.append("\(RSSI)")
                                }
                                DispatchQueue.main.async { [self] in
                                    stopActivityIndicator()
                                    tableView.reloadData()
                                }
                            }
                        } else {
                            if RSSI != 127{
                                print("Снова RSSIName: \(peripheral.name!) and  RSSI: \(RSSI)")
                                if let i = peripherals.firstIndex(of: peripheral) {
                                    RSSIMainArray[i] = "\(RSSI)"
                                }
                                tableView.reloadData()
                                
                            }
                        }
                    } else {
                        let abc = advertisementData[key] as? [CBUUID]
                        guard let uniqueID = abc?.first?.uuidString else { return }
                        _ = uniqueID.components(separatedBy: ["-"])
                        if(!peripherals.contains(peripheral)) {
                            if peripheral.name! == "DU" + "_\(QRCODE)" {
                                print("YEEEES \(peripheral.name!)")
                                self.connectDaviceLabel.text = "Подключение к " + peripheral.name!
                                self.manager?.connect(peripheral, options: nil)
                                qrcodeConnecting(peripheral: peripheral)
                                self.startActivityIndicator()
                            }
                        }
                    }
                }
            }
        }
    }
    func qrcodeConnecting(peripheral: CBPeripheral) {
        timerConnection = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
            if peripheral.state == CBPeripheralState.connecting {
                print("again connecting")
                self.manager?.connect(peripheral, options: nil)
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        RSSIMain = "\(RSSI)"
    }
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral) {
        timerConnection.invalidate()
        QRCODE = ""
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if let navController = self.navigationController {
            blackBoxStart = false
            mainPassword = ""
            viewModel.passwordFirst = true
            duVC.deviceTLVC.passwortIsEnter = false
            newPassword = true
            duVC.viewModel = viewModel
            stopActivityIndicator()
            navController.pushViewController(duVC, animated: true)
        }
        viewAlphaAlways.isHidden = true

//        self.cancelLabel.isHidden = true
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        timer =  Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (timer) in
            if peripheral.state == CBPeripheralState.disconnected {
                timer.invalidate()
                self.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
                let  vc =  self.navigationController?.viewControllers.filter({$0 is DeviceNewSelectController}).first
                self.navigationController?.popToViewController(vc!, animated: true)
                let alert = UIAlertController(title: "Warning".localized(code), message: "Connection is lost.".localized(code) + " DU \(nameDevice)", preferredStyle: .alert)
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
                let window = UIApplication.shared.keyWindow!
                window.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            stringAll = ""
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func buttonTap() {
        stringAll.removeAll()
        if CBPeripheralForDisconnect != nil {
            peripheral(CBPeripheralForDisconnect, didDiscoverCharacteristicsFor: CBServiceForDisconnect, error: nil)
        }
    }
    func enterPaswwordAlert(isNewPassword: Bool) {
        if isNewPassword {
            setAlertNew()
            animateInNew()
        } else {
            setAlert()
            animateIn()
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        CBPeripheralForDisconnect = peripheral
        CBServiceForDisconnect = service
        let valueAll = "GA\r"
        let valueLogReload = "SM,LM:1:1,"
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
        let setMode = "SW,WM:1:\(actualMode),"
        let setParamSTH = "SD,HK:1:\(valH),"
        let setParamSTL = "SD,LK:1:\(valL),"
        let setParamZaderV = "ST,TO:1:\(zaderV),"
        let setParamZaderVi = "ST,TF:1:\(zaderVi),"

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
        let dataSetMode = Data(setMode.utf8)
        let dataSetParamSTL = Data(setParamSTL.utf8)
        let dataSetParamSTH = Data(setParamSTH.utf8)
        let dataSetParamZaderV = Data(setParamZaderV.utf8)
        let dataSetParamZaderVi = Data(setParamZaderVi.utf8)

        guard let serviceCharacteristics = service.characteristics else {return}
        for characteristic in serviceCharacteristics {
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        if reload == 0 {
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataAll, for: characteristic, type: .withResponse)
                }
            }
        }
        if reload == 20 {
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataPassZero, for: characteristic, type: .withResponse)
                    reload = 0
                    zero = 1
                }
            }
        }
        if reload == 1 {
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataReload, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 2{
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataFullReload, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataReloadFN, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 3{
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataNothingReload, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataReloadFN, for: characteristic, type: .withResponse)
                    
                    reload = 0
                }
            }
        }
        if reload == 4{
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataSdVal, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 5{
            for characteristic in serviceCharacteristics {
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
            for characteristic in serviceCharacteristics {
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
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataSdParam, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 7{
            for characteristic in serviceCharacteristics {
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
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataPassInstall, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 9{
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataPassEnter, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    
                    reload = 0
                }
            }
        }
        if reload == 21 {
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataSetMode, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 22 {
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataSetParamSTL, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataSetParamSTH, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 23 {
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataSetParamSTL, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataSetParamZaderV, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataSetParamZaderVi, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 24 {
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataSetParamSTL, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    
                    peripheral.writeValue(dataSetParamSTH, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    
                    peripheral.writeValue(dataSetParamZaderV, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    
                    peripheral.writeValue(dataSetParamZaderVi, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
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
            let result = stringAll.components(separatedBy: [":",";","=",",","\r","\n"])
            if blackBoxStart {
            
            } else {
                print(stringAll)
                
                if result.count >= 0 {
                    if result.contains("SMO") {
                        print("SMO 0")
                        viewAlphaAlways.isHidden = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                        if tlVC.deviceTLVC.numberOfButton == 1 {
//                            tlVC.deviceTLVC.numberOfButton = 0
//                            let window = UIApplication.shared.keyWindow!
//                            window.rootViewController?.showToast(message: "Data has been deleted".localized(code), seconds: 1.0)
//                        }
                    }
                    //                print(result)
                    if result.contains("SE") {
                        let indexOfPerson = result.firstIndex{$0 == "SE"}
                        if result.count > indexOfPerson! + 2 {
                            nameDevice = "\(result[indexOfPerson! + 2])"
                            nameDeviceT = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("UT") {
                        let indexOfPerson = result.firstIndex{$0 == "UT"}
                        if result.count > indexOfPerson! + 2 {
                            temp = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("UL") {
                        let indexOfPerson = result.firstIndex{$0 == "UL"}
                        if result.count > indexOfPerson! + 2 {
                            level = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("UN") {
                        let indexOfPerson = result.firstIndex{$0 == "UN"}
                        if result.count > indexOfPerson! + 2 {
                            level = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("UP") {
                        let indexOfPerson = result.firstIndex{$0 == "UP"}
                        if result.count > indexOfPerson! + 2 {
                            pressure = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("VB") {
                        let indexOfPerson = result.firstIndex{$0 == "VB"}
                        if result.count > indexOfPerson! + 2 {
                            vatt = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("UD") {
                        let indexOfPerson = result.firstIndex{$0 == "UD"}
                        if result.count > indexOfPerson! + 2 {
                            id = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("LK") {
                        let indexOfPerson = result.firstIndex{$0 == "LK"}
                        if result.count > indexOfPerson! + 2 {
                            nothing = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("HK") {
                        let indexOfPerson = result.firstIndex{$0 == "HK"}
                        if result.count > indexOfPerson! + 2 {
                            full = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("TF") {
                        let indexOfPerson = result.firstIndex{$0 == "TF"}
                        if result.count > indexOfPerson! + 2 {
                            zaderVi = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("TO") {
                        let indexOfPerson = result.firstIndex{$0 == "TO"}
                        if result.count > indexOfPerson! + 2 {
                            zaderV = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("LM") {
                        let indexOfPerson = result.firstIndex{$0 == "LM"}
                        if result.count > indexOfPerson! + 2 {
                            lum = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("HS") {
                        let indexOfPerson = result.firstIndex{$0 == "HS"}
                        if result.count > indexOfPerson! + 2 {
                            magnetic = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("UL") {
                        let indexOfPerson = result.firstIndex{$0 == "UL"}
                        if result.count > indexOfPerson! + 2 {
                            modeS = "\(result[indexOfPerson! + 2])"
                        }
                    }
                    if result.contains("WM") {
                        let indexOfPerson = result.firstIndex{$0 == "WM"}
                        if result.count > indexOfPerson! + 2 {
                            let mode = "\(result[indexOfPerson! + 2])"
                            guard let intMode = Int(mode),
                                  let intModeS = Int(modeS) else {return}
                            modeLabel = viewModel.detectDuModeString(intMode: intMode, intModeS: intModeS)[0]
                            modeS = viewModel.detectDuModeString(intMode: intMode, intModeS: intModeS)[1]
                        }
                    }
                    if result.contains("ADO") {
                        print("ADO 0")
                        buttonTap()
                        let window = UIApplication.shared.keyWindow!
                        window.rootViewController?.showToast(message: "Settings saved".localized(code), seconds: 1.0)
                    }
                    if result.contains("ADE") {
                        print("ADE 0")
                        buttonTap()
                        let window = UIApplication.shared.keyWindow!
                        window.rootViewController?.showToast(message: "Couldn't save settings".localized(code), seconds: 1.0)
                    }
                    if result.contains("AWO") {
                        buttonTap()
                        let window = UIApplication.shared.keyWindow!
                        window.rootViewController?.showToast(message: "Mode is set successfully".localized(code), seconds: 1.0)
                    }
                    if result.contains("AWE") {
                        print("AWE 0")
                        let window = UIApplication.shared.keyWindow!
                        window.rootViewController?.showToast(message: "Mode setting failure. Try again".localized(code), seconds: 1.0)
                        viewAlphaAlways.isHidden = true
                    }
                    if result.contains("ATO") {
                        let window = UIApplication.shared.keyWindow!
                        window.rootViewController?.showToast(message: "Synchronization is complete".localized(code), seconds: 1.0)
                        newPassword = false
//                        tlVC.deviceTLVC.tableView.reloadData()
//                        tlVC.deviceTLVC.passwortIsEnter = true
//                        viewAlphaAlways.isHidden = true
//                        tlVC.deviceTLVC.numberOfButton = 0
                    }
                    if result.contains("APO") {
                        if zero == 1 {
                            newPassword = true
                            zero = 0
                        }
                        print("APO 0")
                        if let viewControllers = navigationController?.viewControllers {
                            for viewController in viewControllers {
                                if viewController.isKind(of: TLTHSettingsController.self) {
                                    if duVC.deviceTLVC.numberOfButton == 1 {
                                        reload = 14
                                        viewAlphaAlways.isHidden = false
                                        buttonTap()
                                    } else if duVC.deviceTLVC.numberOfButton == 2 {
                                        duVC.deviceTLVC.tableView.reloadData()
                                        duVC.deviceTLVC.passwortIsEnter = true
                                        newPassword = false
                                        viewAlphaAlways.isHidden = true
                                        duVC.deviceTLVC.numberOfButton = 0
                                        duVC.deviceTLVC.alertUpdate()
                                    } else {
                                        if duVC.deviceTLVC.passwortIsEnter {
                                            if !newPassword {
                                                let window = UIApplication.shared.keyWindow!
                                                window.rootViewController?.showToast(message: "Password deleted successfully".localized(code), seconds: 1.0)
                                                newPassword = true
                                                mainPassword = ""
                                                duVC.deviceTLVC.tableView.reloadData()
                                                duVC.deviceTLVC.passwortIsEnter = false
                                                viewAlphaAlways.isHidden = true
                                            } else {
                                                let window = UIApplication.shared.keyWindow!
                                                window.rootViewController?.showToast(message: "Password set successfully".localized(code), seconds: 1.0)
                                                newPassword = false
                                                duVC.deviceTLVC.tableView.reloadData()
                                                duVC.deviceTLVC.passwortIsEnter = false
                                                viewAlphaAlways.isHidden = true

                                            }
                                        } else {
                                            let window = UIApplication.shared.keyWindow!
                                            window.rootViewController?.showToast(message: "Password is entered".localized(code), seconds: 1.0)
                                            newPassword = false
                                            duVC.deviceTLVC.tableView.reloadData()
                                            duVC.deviceTLVC.passwortIsEnter = true
                                            viewAlphaAlways.isHidden = true
                                        }
                                    }
                                }
                                if viewController.isKind(of: DeviceDUSettingsController.self) {
                                    let window = UIApplication.shared.keyWindow!
                                    window.rootViewController?.showToast(message: "Password is entered".localized(code), seconds: 1.0)
                                    duVC.deviceDUSettings.passwortIsEnter = true
                                    duVC.deviceTLVC.passwortIsEnter = true
                                    newPassword = false
                                    if duVC.deviceDUSettings.numberOfButton == 1  {
                                        reload = 21
                                        buttonTap()
                                        duVC.deviceDUSettings.numberOfButton = 0
                                    } else if duVC.deviceDUSettings.numberOfButton == 2  {
                                        reload = 22
                                        buttonTap()
                                        duVC.deviceDUSettings.numberOfButton = 0
                                    }
                                }
                            }
                        }
                        
                    }
                    if result.contains("APR") {
                        print("APR 0")
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        viewAlphaAlways.isHidden = true
                        nameDevice = ""
                        temp = nil
                        checkUpdate = "Update"
                        manager?.cancelPeripheralConnection(CBPeripheralForDisconnect)
                        self.timer.invalidate()
                        duVC.deviceTLVC.popToVC()
                    }

                    if result.contains("WRN") {
                        if zero == 1 {
                            let window = UIApplication.shared.keyWindow!
                            window.rootViewController?.showToast(message: "Sensor is password-protected".localized(code), seconds: 1.0)
                            newPassword = false
                            zero = 0
                        }
                        print("WRN 1")
                        if let viewControllers = navigationController?.viewControllers {
                            for viewController in viewControllers {
                                if viewController.isKind(of: TLTHSettingsController.self) {
                                    let window = UIApplication.shared.keyWindow!
                                    window.rootViewController?.showToast(message: "Wrong password".localized(code), seconds: 1.0)
                                    mainPassword = ""
                                    duVC.deviceTLVC.tableView.reloadData()
                                    duVC.deviceTLVC.passwortIsEnter = false
                                    viewAlphaAlways.isHidden = true
                                }
                                if viewController.isKind(of: DeviceDUSettingsController.self) {
                                    let window = UIApplication.shared.keyWindow!
                                    window.rootViewController?.showToast(message: "Wrong password".localized(code), seconds: 1.0)
                                    mainPassword = ""
                                    duVC.deviceDUSettings.tableView.reloadData()
                                    duVC.deviceTLVC.passwortIsEnter = false
                                    duVC.deviceDUSettings.passwortIsEnter = false
                                    viewAlphaAlways.isHidden = true
                                }
//                                if viewController.isKind(of: BlackBoxTHController.self) {
//                                    let window = UIApplication.shared.keyWindow!
//                                    window.rootViewController?.showToast(message: "Wrong password".localized(code), seconds: 1.0)
//                                    mainPassword = ""
//                                }
                            }
                        }
                    }
                    if result.contains("VV") {
                        let indexOfPerson = result.firstIndex{$0 == "VV"}
                        if result.count > indexOfPerson! + 2 {
                            VV = "\(result[indexOfPerson! + 2])"
                            if VV != " " && VV != "" && VV.count > 2 {
                                VV.insert(".", at: VV.index(VV.startIndex, offsetBy: 1))
                                VV.insert(".", at: VV.index(VV.startIndex, offsetBy: 3))
                                if let viewControllers = navigationController?.viewControllers {
                                    for viewController in viewControllers {
                                        if viewController.isKind(of: DeviceDUBleController.self) {
                                            duVC.tableView.reloadData()
                                            duVC.refreshControl.endRefreshing()
                                        }
                                        if viewController.isKind(of: DeviceDUSettingsController.self) {
                                            viewAlphaAlways.isHidden = true
                                            duVC.deviceDUSettings.reloadSettings()
                                        }
                                    }
                                }
                            }
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
    
    var tableViewData = [cellDataDU]()
    weak var tableView: UITableView!

    
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 1),
        ])
        self.tableView = tableView
        tableView.backgroundColor = .clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func popTo() {
        self.generator.impactOccurred()
        self.navigationController?.popViewController(animated: true)
    }
    func createRefreshControl() {
        self.tableView.addSubview(refreshControl!)

    }

    @objc func adjustForKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            let contentInset:UIEdgeInsets = UIEdgeInsets.zero
            tableView.contentInset = contentInset
        } else {
            guard let userInfo = notification.userInfo else { return }
            var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            var contentInset:UIEdgeInsets = self.tableView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            tableView.contentInset = contentInset
//            tableView.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom - 80, right: 0)
        }
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRefreshControl()
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        // 2
        definesPresentationContext = true
        extendedLayoutIncludesOpaqueBars = true

        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search devices"
//        navigationItem.hidesSearchBarWhenScrolling = true

        searchController.searchBar.keyboardType = .numberPad

        // 4                    
        navigationItem.searchController = searchController
        // 5
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        alertView.CustomTextField.delegate = self
        initialY = alertView.frame.origin.y
        
        alertViewNewPassword.CustomTextField.delegate = self
        alertViewNewPassword.CustomTextFieldSecond.delegate = self
        initialY = alertViewNewPassword.frame.origin.y

        duVC.delegate = self
//        searchBar.delegate = self
//        searchBar.searchBarStyle = .minimal
//        searchBar.showsCancelButton = false
//        searchBar.keyboardType = UIKeyboardType.decimalPad
//        view.addSubview(searchBar)
        viewShow()
        view.addSubview(connectDaviceLabel)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

//        cancelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        cancelLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 45).isActive = true
        
        connectDaviceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectDaviceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -45).isActive = true

        
        cancelLabel.addTapGesture { [self] in
            print("Stop")
            stopActivityIndicator()
            self.navigationController?.popViewController(animated: true)
        }
        rightCount = 0
        manager = CBCentralManager ( delegate : self , queue : nil , options : nil )

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(DevicesListCellHeder.self, forCellReuseIdentifier: "DevicesListCellHeder")
        self.tableView.register(DevicesListCellMain.self, forCellReuseIdentifier: "DevicesListCellMain")
        self.tableView.register(DevicesListCell.self, forCellReuseIdentifier: "DevicesListCell")
        tableView.separatorStyle = .none
        
        visualEffectView.addTapGesture {
            self.navigationController?.view.endEditing(true)
        }
        
        setupTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationCusmotizing(nav: navigationController!, navItem: navigationItem, title: "List of available devices")
        searchController.searchBar.setValue("Cancel".localized(code), forKey: "cancelButtonText")
        searchBar.text = ""
        self.tableView.alpha = 0.0
        self.searchBar.endEditing(true)
        peripherals.removeAll()
        RSSIMainArray.removeAll()
        rrsiPink = 0
        manager?.stopScan()
        tableViewData.removeAll()
        tableViewData.append(cellDataDU(opened: false, title: "123", sectionData: ["123"]))
        tableViewData.insert(cellDataDU(opened: false, title: "1234", sectionData: ["1234"]), at: 0)
        RSSIMainArray.append("2")
        RSSIMainArray.insert("1", at: 0)
        searchList.removeAll()
        searching = false
        peripheralName.removeAll()
        cancelLabel.text = "Cancel".localized(code)
        connectDaviceLabel.text = ""
        setupTheme()
    }
    
    @objc func refresh() {
        print("123000001")
        self.startActivityIndicator()
        mainPassword = ""
        timer.invalidate()
        self.view.isUserInteractionEnabled = true
        peripherals.removeAll()
        RSSIMainArray.removeAll()
        rrsiPink = 0
        manager?.stopScan()
        tableViewData.removeAll()
        tableViewData.append(cellDataDU(opened: false, title: "123", sectionData: ["123"]))
        tableViewData.insert(cellDataDU(opened: false, title: "1234", sectionData: ["1234"]), at: 0)
        RSSIMainArray.append("2")
        RSSIMainArray.insert("1", at: 0)
        searchList.removeAll()
        searching = false
        peripheralName.removeAll()
        mainPassword = ""
        tableView.reloadData()
        scanBLEDevices()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl?.endRefreshing()
        }
    }
    func startActivityIndicator() {
        viewAlphaAlways.isHidden = false
        cancelLabel.isHidden = false
        self.connectDaviceLabel.isHidden = false
        view.superview?.bringSubviewToFront(cancelLabel)
        connectDaviceLabel.superview?.bringSubviewToFront(connectDaviceLabel)
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.tableView.alpha = 0.0
        }) { [self] (_) in
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        viewAlphaAlways.isHidden = true
        cancelLabel.isHidden = true
        self.connectDaviceLabel.isHidden = true
        self.connectDaviceLabel.text = ""
        tableView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.tableView.alpha = 1.0
        }) { [self] (_) in
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.view.isUserInteractionEnabled = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if CBPeripheralForDisconnect != nil {
            manager?.cancelPeripheralConnection(CBPeripheralForDisconnect)
        }
        self.startActivityIndicator()
        mainPassword = ""
        timer.invalidate()
        mainPassword = ""
        tableView.reloadData()
        rightCount = 0
        scanBLEDevices()
    }
    
    func scanBLEDevices() {
        peripherals.removeAll()
        manager?.scanForPeripherals(withServices: nil)
        self.view.isUserInteractionEnabled = true
    }
    func stopScanForBLEDevices() {
        manager?.stopScan()
        print("Stop")
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.alpha = 0.3
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
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        peripherals.removeAll()
        RSSIMainArray.removeAll()
        rrsiPink = 0
        manager?.stopScan()
        tableViewData.removeAll()
        searchList.removeAll()
        peripheralName.removeAll()
//        if QRCODE == ""{
        if tableViewData.count != 0 {
            tableView.reloadData()
        }
//        }
    }
    private func viewShow() {
        
//        view.addSubview(themeBackView3)
//        MainLabel.text = "List of available devices".localized(code)
//        view.addSubview(MainLabel)
//        view.addSubview(backView)
        
        view.addSubview(bgImage)
        activityIndicator.startAnimating()
        viewAlphaAlways.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if QRCODE == "" {
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                self.view.backgroundColor = UIColor(rgb: 0x1F2222).withAlphaComponent(1)
            }
        }
    }
    
    var searching = false
    var searchedCountry = [String]()
    var aaa = [String]()
    let label = UILabel()
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            searchController.searchBar.theme.tintColor = themed{ $0.navigationTintColor }
            searchController.searchBar.theme.backgroundColor = themed { $0.backgroundColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            searchController.searchBar.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            searchController.searchBar.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
        }
        if isNight {
            searchController.searchBar.textColor = .white
        } else {
            searchController.searchBar.textColor = .black
        }
    }
}
extension DevicesDUController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        manager?.scanForPeripherals(withServices: nil, options: nil)
        searchBar.text = ""
        searching = false
        print("clickcancel")
        self.searchController.searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText == "" {
//            searchBarCancelButtonClicked(searchBar)
//        }
    }
    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
        
        let searchText = searchController.searchBar.text
        if searchText != "" {
            searchList = peripheralName.filter({$0.lowercased().contains(searchText!)})
            print("searchList: \(searchList)")

            //        print("peripheralName: \(peripheralName)")
            manager?.stopScan()
            searching = true
            refreshControl?.endRefreshing()
            tableView.reloadData()
        } else {
            searching = false
//            searchController.searchBar.text = ""
        }
//        if searchText == "" {
//            searchBarCancelButtonClicked(searchBar)
//        }
    }
    
}

extension DevicesDUController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark)
    }
}


extension DevicesDUController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !searching {
            if indexPath.section == 0 || indexPath.section == rrsiPink+1 {
                return 60
            } else {
                if indexPath.row == 0 {
                    return 73
                } else {
                    return 65
                }
            }
        } else {
            return 73
        }
    }
}


extension DevicesDUController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        if indexPath.row == 0 {
            if !searching {
                if indexPath.section == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellHeder", for: indexPath) as! DevicesListCellHeder
                    cell.titleLabel.text = "Nearby devices".localized(code)
                    cell.titleLabel.font = UIFont(name: "FuturaPT-Medium", size: 20)
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                    
                } else if indexPath.section == rrsiPink+1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellHeder", for: indexPath) as! DevicesListCellHeder
                    cell.titleLabel.text = "Low signal devices".localized(code)
                    cell.titleLabel.font = UIFont(name: "FuturaPT-Medium", size: 20)

                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    return cell
                } else {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellMain", for: indexPath) as! DevicesListCellMain
                    cell.titleLabel.text = tableViewData[indexPath.section].title
                    cell.titleLabel.font = UIFont(name: "FuturaPT-Light", size: 24)
                    cell.btnConnet.setTitle("Connect".localized(code), for: .normal)
                    cell.titleRSSI.text = "\(RSSIMainArray[indexPath.section]) dBm"
                    cell.backgroundColor = .clear
                    cell.selectionStyle = .none
                    if indexPath.section == rrsiPink {
                        cell.separetor.isHidden = true
                    } else {
                        cell.separetor.isHidden = false
                    }
                    if indexPath.section == 1  || indexPath.section == rrsiPink + 2{
                        cell.separetor2.isHidden = true
                    } else {
                        cell.separetor2.isHidden = false
                    }
                    cell.backgroundColor = .clear
                    cell.btnConnet.addTapGesture {
                        self.generator.impactOccurred()
                        temp = nil
                        nameDevice = ""
                        VV = ""
                        level = ""
                        RSSIMain = ""
                        vatt = ""
                        id = ""
                        zeroTwo = 0
                        zero = 0
                        countNot = 0
                        if !self.searching {
                            self.stringAll = ""
                            if indexPath.section > rrsiPink {
                                self.searchBarCancelButtonClicked(self.searchController.searchBar)
                                self.manager?.connect(self.peripherals[indexPath.section-2], options: nil)
                                self.connectDaviceLabel.text = "Подключение к " + self.peripherals[indexPath.section-2].name!
                            } else {
                                self.searchBarCancelButtonClicked(self.searchController.searchBar)
                                self.manager?.connect(self.peripherals[indexPath.section-1], options: nil)
                                self.connectDaviceLabel.text = "Подключение к " + self.peripherals[indexPath.section-1].name!
                            }
                        }
                        self.view.isUserInteractionEnabled = true
                        self.manager?.stopScan()
                        self.startActivityIndicator()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
//                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                            if let navController = self.navigationController {
//                                navController.pushViewController(TLController(), animated: true)
//                            }
//                        })
                    }
                    return cell
                }
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellMain", for: indexPath) as! DevicesListCellMain
                cell.separetor.isHidden = false
                cell.titleLabel.text = searchList[indexPath.section]
                cell.titleLabel.font = UIFont(name: "FuturaPT-Light", size: 24)

                cell.backgroundColor = .clear
                cell.selectionStyle = .none
//                cell.titleRSSI.text = "\(RSSIMainArray[indexPath.section]) dBm"
                cell.btnConnet.addTapGesture {
                    self.generator.impactOccurred()
                    temp = nil
                    nameDevice = ""
                    viewAlphaAlways.isHidden = false
                    zeroTwo = 0
                    zero = 0
                    countNot = 0
                    print(self.searchList)
                    print("indexPath.section: \(indexPath.section)")

                    print(self.searchList[indexPath.section])
                    let index = peripheralName.firstIndex(of: "\(self.searchList[indexPath.section])")
                    print("\(index!)")
                    if self.searching {
                        self.searchBarCancelButtonClicked(self.searchController.searchBar)
                        self.stringAll = ""
                        self.manager?.connect(self.peripherals[index!], options: nil)
                        self.connectDaviceLabel.text = "Подключение к " + self.peripherals[index!].name!
                    }
                    self.view.isUserInteractionEnabled = true
                    self.manager?.stopScan()
                    self.startActivityIndicator()
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
//                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                        if let navController = self.navigationController {
//                            navController.pushViewController(TLController(), animated: true)
//                        }
//                    })
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCell", for: indexPath) as! DevicesListCell
//            cell.titleLabel.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
//            cell.macAdres.text = "MAC = F6:F6:F6:F6:F6:F6"
            cell.FW.text = "F.W. = \(adveFW[indexPath.section-1])"
            cell.T.text = "Temperature = \(adveTemp[indexPath.section-1]) C°"
            cell.Lvl.text = "Level = \(adveLvl[indexPath.section-1])"
            cell.Vbat.text = "Vbatt = \(adveVat[indexPath.section-1]) V"
            cell.backgroundColor = .clear
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searching {
            if tableViewData[section].opened == true {
                return tableViewData[section].sectionData.count + 1
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if !searching {
            return tableViewData.count
        } else {
            return searchList.count
        }
    }
}













//
//import UIKit
//import CoreBluetooth
//
//struct cellDataDU {
//    var opened = Bool()
//    var title = String()
//    var sectionData = [String()]
//}
////var rrsiPink = 0
////var kCBAdvDataManufacturerData = ""
//class DevicesDUController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
//
//    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
//    let searchBar = UISearchBar(frame: CGRect(x: 0, y: headerHeight + (iphone5s ? 10 : 0), width: screenWidth, height: 35))
//    var refreshControl = UIRefreshControl()
//    var attributedTitle = NSAttributedString()
//    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//    var peripherals = [CBPeripheral]()
//    var peripheralsSearch = [CBPeripheral]()
//    var manager:CBCentralManager? = nil
//    var timer = Timer()
//    var stringAll: String = ""
//    var iter = false
//    var parsedData:[String : AnyObject] = [:]
//    var bluetoothPeripheralManager: CBPeripheralManager?
//    var searchList = [String]()
//    let generator = UIImpactFeedbackGenerator(style: .light)
//
//    func centralManagerDidUpdateState (_ central : CBCentralManager) {
//        if central.state == CBManagerState.poweredOn {
//            let peripheralsArray = Array(peripherals)
//            print(peripheralsArray)
//            print("ON Работает.")
//        }
//        else {
//            print("Bluetooth OFF.")
//            let alert = UIAlertController(title: "Bluetooth off".localized(code), message: "For further work, you must enable Bluetooth".localized(code), preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                switch action.style{
//                case .default:
//                    print("default")
//                    self.navigationController?.popViewController(animated: true)
//                    self.view.subviews.forEach({ $0.removeFromSuperview() })
//
//                case .cancel:
//                    print("cancel")
//
//                case .destructive:
//                    print("destructive")
//
//
//                @unknown default:
//                    fatalError()
//                }}))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        let key = "kCBAdvDataServiceUUIDs"
//        print("advertisementData: \(advertisementData)")
//        if peripheral.name != nil {
//            let nameDevicesOps = peripheral.name!.components(separatedBy: ["_"])
//            if nameDevicesOps[0] == "DU" && nameDevicesOps[1] != "UPDATE" {
//                if QRCODE == "" {
//                    print("advertisementData[kCBAdvDataManufacturerData]): \(kCBAdvDataManufacturerData)")
//                    let abc = advertisementData[key] as? [CBUUID]
//                    guard let uniqueID = abc?.first?.uuidString else { return }
//                    _ = uniqueID.components(separatedBy: ["-"])
//                    if(!peripherals.contains(peripheral)) {
//                        if RSSI != 127{
//                            let orderNum: NSNumber? = RSSI
//                            let orderNumberInt  = orderNum?.intValue
//                            if -71 < orderNumberInt! {
//                                rrsiPink = rrsiPink + 1
//                                print("rrsiPink:\(rrsiPink) \(orderNumberInt!)")
//                                peripherals.insert(peripheral, at: 0)
//                                peripheralName.insert(peripheral.name!, at: 0)
//                                tableViewData.insert(cellDataDU(opened: false, title: "\(peripheral.name!)", sectionData: ["\(peripheral.name!)"]), at: 1)
//                                print("RSSIName: \(peripheral.name!) and  RSSI: \(RSSI)")
//                                RSSIMainArray.insert("\(RSSI)", at: 1)
//                                if let manufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data {
//                                    assert(manufacturerData.count >= 7)
//                                    let nodeID = manufacturerData[2]
//                                    print(String(format: "%02X", nodeID)) //->FE
//
//                                    let state = UInt16(manufacturerData[3]) + UInt16(manufacturerData[4]) << 8
//                                    let string34 = "\(String(format: "%04X", state))"
//                                    print(string34) //->000D
//                                    let result34 = UInt16(strtoul("0x\(string34)", nil, 16)) //уровень
//                                    print(result34) //->000D
//                                    adveLvl.insert(String(result34), at: 0)
//                                    //c6f - is the sensor tag battery voltage
//                                    //Constructing 2-byte data as big endian (as shown in the Java code)
//                                    let batteryVoltage = UInt16(manufacturerData[5])
//                                    let string5 = "\(String(format: "%02X", batteryVoltage))"
//                                     print(string5) //->000D
//                                    let result5 = UInt16(strtoul("0x\(string5)", nil, 16)) //напряжение
////                                    var abn: String = String(result5)
////                                    abn.insert(".", at: abn.index(abn.startIndex, offsetBy: 1))
////                                    print(abn) //->000D
//                                    adveVat.insert(String(result5), at: 0)
//
//                                    //32- is the BLE packet counter.
//                                    let packetCounter = manufacturerData[6]
//                                    let string6 = "\(String(format: "%02X", packetCounter))"
//                                    print(string6) //->000D
//                                    let result6 = UInt16(strtoul("0x\(string6)", nil, 16)) //температура
//                                    print(result6)
//                                    adveTemp.insert(String(result6), at: 0)
//
//                                    let versionCounter = manufacturerData[7]
//                                    let string7 = "\(String(format: "%02X", versionCounter))"
//                                    print(string7) //->000D
//                                    let result7 = UInt16(strtoul("0x\(string7)", nil, 16)) //весрия
//                                    var abn7: String = String(result7)
//                                    abn7.insert(".", at: abn7.index(abn7.startIndex, offsetBy: 1))
////                                    abn7.insert(".", at: abn7.index(abn7.startIndex, offsetBy: 3))
//                                    print(abn7)
//                                    adveFW.insert(String(abn7), at: 0)
//                                } else {
//                                    adveLvl.insert("...", at: 0)
//                                    adveVat.insert("...", at: 0)
//                                    adveTemp.insert("...", at: 0)
//                                    adveFW.insert("...", at: 0)
//                                }
//
//                            } else {
//                                peripherals.append(peripheral)
//                                peripheralName.append(peripheral.name!)
//                                print("RSSIName: \(peripheral.name!) and  RSSI: \(RSSI)")
//                                tableViewData.append(cellDataDU(opened: false, title: "\(peripheral.name!)", sectionData: ["\(peripheral.name!)"]))
//                                RSSIMainArray.append("\(RSSI)")
//                                if let manufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data {
//                                    assert(manufacturerData.count >= 7)
//                                    let nodeID = manufacturerData[2]
//                                    print(String(format: "%02X", nodeID)) //->FE
//
//                                    let state = UInt16(manufacturerData[3]) + UInt16(manufacturerData[4]) << 8
//                                    let string34 = "\(String(format: "%04X", state))"
//                                    print(string34) //->000D
//                                    let result34 = UInt16(strtoul("0x\(string34)", nil, 16)) //уровень
//                                    print(result34) //->000D
//                                    adveLvl.append(String(result34))
//                                    //c6f - is the sensor tag battery voltage
//                                    //Constructing 2-byte data as big endian (as shown in the Java code)
//                                    let batteryVoltage = UInt16(manufacturerData[5])
//                                    let string5 = "\(String(format: "%02X", batteryVoltage))"
//                                     print(string5) //->000D
//                                    let result5 = UInt16(strtoul("0x\(string5)", nil, 16)) //напряжение
////                                    var abn: String = String(result5)
////                                    abn.insert(".", at: abn.index(abn.startIndex, offsetBy: 1))
////                                    print(abn) //->000D
//                                    adveVat.append(String(result5))
//
//                                    //32- is the BLE packet counter.
//                                    let packetCounter = manufacturerData[6]
//                                    let string6 = "\(String(format: "%02X", packetCounter))"
//                                    print(string6) //->000D
//                                    let result6 = UInt16(strtoul("0x\(string6)", nil, 16)) //температура
//                                    print(result6)
//                                    adveTemp.append(String(result6))
//
//                                    let versionCounter = manufacturerData[7]
//                                    let string7 = "\(String(format: "%02X", versionCounter))"
//                                    print(string7) //->000D
//                                    let result7 = UInt16(strtoul("0x\(string7)", nil, 16)) //весрия
//                                    var abn7: String = String(result7)
//                                    abn7.insert(".", at: abn7.index(abn7.startIndex, offsetBy: 1))
////                                    abn7.insert(".", at: abn7.index(abn7.startIndex, offsetBy: 3))
//                                    print(abn7)
//                                    adveFW.append(String(abn7))
//
//                                } else {
//                                    adveLvl.append("...")
//                                    adveVat.append("...")
//                                    adveTemp.append("...")
//                                    adveFW.append("...")
//                                }
//                            }
//                            tableView.reloadData()
//
//                        }
//                    } else {
//                        if RSSI != 127{
//                            print("Снова RSSIName: \(peripheral.name!) and  RSSI: \(RSSI)")
//                            if let i = peripherals.firstIndex(of: peripheral) {
//                                RSSIMainArray[i] = "\(RSSI)"
//                            }
//                            tableView.reloadData()
//
//                        }
//                    }
//                } else {
//                    let abc = advertisementData[key] as? [CBUUID]
//                    guard let uniqueID = abc?.first?.uuidString else { return }
//                    _ = uniqueID.components(separatedBy: ["-"])
//                    if(!peripherals.contains(peripheral)) {
//                        if peripheral.name! == "DU_\(QRCODE)" {
//                            nameDevice = ""
//                            print("YEEEES \(peripheral.name!)")
//                            temp = nil
//                            self.activityIndicator.startAnimating()
//                            self.view.addSubview(self.viewAlpha)
//                            zeroTwo = 0
//                            zero = 0
//                            countNot = 0
//                            self.manager?.connect(peripheral, options: nil)
//                            self.view.isUserInteractionEnabled = false
//                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//                            self.manager?.stopScan()
//                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
//                                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                                if let navController = self.navigationController {
//                                    navController.pushViewController(DeviceDUBleController(), animated: true)
//                                    QRCODE = ""
//                                }
//                                print("Connected to " +  peripheral.name!)
//                                self.viewAlphaAlways.removeFromSuperview()
//                            })
//                        }
//                    }
//                }
//            }
//        }
//    }
//    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
//        RSSIMain = "\(RSSI)"
//    }
//    func centralManager(
//        _ central: CBCentralManager,
//        didConnect peripheral: CBPeripheral) {
//
//        peripheral.delegate = self
////        let nameD = peripheral.name!
////        let nameDOps = nameD.components(separatedBy: ["_"])
////        nameDevice = nameDOps[1]
//        timer =  Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (timer) in
//            peripheral.discoverServices(nil)
//            if peripheral.state == CBPeripheralState.connected {
//                print("connectedP")
//                checkQR = true
//            }
//            if peripheral.state == CBPeripheralState.disconnected {
//                print("disconnectedP")
//                if warning == true{
//                    timer.invalidate()
//                    self.dismiss(animated: true, completion: nil)
//                    self.dismiss(animated: true, completion: nil)
//                } else {
//                    timer.invalidate()
//                    self.dismiss(animated: true, completion: nil)
//                    self.dismiss(animated: true, completion: nil)
//                    let alert = UIAlertController(title: "Warning".localized(code), message: "Connection is lost.".localized(code), preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                        switch action.style{
//                        case .default:
//                            print("default")
//                            self.dismiss(animated: true, completion: nil)
//                            self.dismiss(animated: true, completion: nil)
//                            let  vc =  self.navigationController?.viewControllers.filter({$0 is DeviceNewSelectController}).first
//                            self.navigationController?.popToViewController(vc!, animated: true)
//                            self.view.subviews.forEach({ $0.removeFromSuperview() })
////                            self.navigationController?.popViewController(animated: true)
//                        case .cancel:
//                            print("cancel")
//                        case .destructive:
//                            print("destructive")
//                        @unknown default:
//                            fatalError()
//                        }}))
//                    self.present(alert, animated: true, completion: nil)
//                }
//                warning = false
//            }
//            if peripheral.state == CBPeripheralState.connecting {
//                print("connectingP")
//            }
//            if peripheral.state == CBPeripheralState.disconnecting {
//                print("disconnectingP")
//            }
//        }
//    }
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        for service in peripheral.services! {
//            stringAll = ""
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        a = peripheral
//        let valueAll = "GA\r"
//        let valueReload = "PR,PW:1:\(mainPassword)"
//        let FullReload = "SH,PW:1:"
//        let NothingReload = "SL,PW:1:"
//        let ReloadFN = "\(mainPassword)\r"
//        let sdVal = "SD,HK:1:1024\r"
//        let sdValTwo = "SD,HK:1:\(full)"
//        let sdValThree = "SD,LK:1:\(nothing)"
//        let sdValTwo1 = "SD,HK:1:\(full),"
//        let sdValThree1 = "SD,LK:1:\(nothing),"
//        let sdParam = "SW,WM:1:\(wmPar),"
//        let sdParamYet = "PW:1:\(mainPassword)"
//        let passZero = "SP,PN:1:0\r"
//        let passDelete = "SP,PN:1:0,"
//        let passInstall = "SP,PN:1:\(mainPassword)\r"
//        let enterPass = "SP,PN:1:\(mainPassword),"
//        let r = "\r"
//        let setZero = "SA,PW:1:\(mainPassword)\r"
//        let setMode = "SW,WM:1:\(modeLabel),"
//        let setParamSTH = "SD,HK:1:\(valH),"
//        let setParamSTL = "SD,LK:1:\(valL),"
//        let setParamZaderV = "ST,TO:1:\(zaderV),"
//        let setParamZaderVi = "ST,TF:1:\(zaderVi),"
//
//        print("sdParam: \(sdParam)")
//        print("sdValTwo: \(sdValTwo)")
//        print("passInstall: \(passInstall)")
//
//        let dataAll = withUnsafeBytes(of: valueAll) { Data($0) }
//        let dataReload = Data(valueReload.utf8)
//        let dataFullReload = Data(FullReload.utf8)
//        let dataNothingReload = Data(NothingReload.utf8)
//        let dataSdVal = withUnsafeBytes(of: sdVal) { Data($0) }
//        let dataSdValTwo = Data(sdValTwo.utf8)
//        let dataSdValThree = Data(sdValThree.utf8)
//        let dataSdValTwo1 = Data(sdValTwo1.utf8)
//        let dataSdValThree1 = Data(sdValThree1.utf8)
//        let dataSdParam = Data(sdParam.utf8)
//        let dataSdParamYet = Data(sdParamYet.utf8)
//        let dataPassZero = Data(passZero.utf8)
//        let dataPassDelete = Data(passDelete.utf8)
//        let dataPassInstall = Data(passInstall.utf8)
//        let dataPassEnter = Data(enterPass.utf8)
//        let dataR = Data(r.utf8)
//        let dataReloadFN = Data(ReloadFN.utf8)
//        let setZeroReload = Data(setZero.utf8)
//        let dataSetMode = Data(setMode.utf8)
//        let dataSetParamSTL = Data(setParamSTL.utf8)
//        let dataSetParamSTH = Data(setParamSTH.utf8)
//        let dataSetParamZaderV = Data(setParamZaderV.utf8)
//        let dataSetParamZaderVi = Data(setParamZaderVi.utf8)
//
//
//
//        for characteristic in service.characteristics! {
//            if characteristic.properties.contains(.notify) {
//                print("Свойство \(characteristic.uuid): .notify")
//                peripheral.setNotifyValue(true, for: characteristic)
//            }
//        }
//        for characteristic in service.characteristics! {
//            if characteristic.properties.contains(.write) {
//                print("Свойство \(characteristic.uuid): .write")
//                peripheral.writeValue(dataAll, for: characteristic, type: .withResponse)
//            }
//        }
//        if zero == 0 {
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataPassZero, for: characteristic, type: .withResponse)
//                    zero = 1
//                    zeroTwo = 0
//                }
//            }
//        }
//        if reload == 1{
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataReload, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    reload = 0
//                }
//            }
//        }
//        if reload == 2{
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataFullReload, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataReloadFN, for: characteristic, type: .withResponse)
//                    reload = 0
//                }
//            }
//        }
//        if reload == 3{
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataNothingReload, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataReloadFN, for: characteristic, type: .withResponse)
//
//                    reload = 0
//                }
//            }
//        }
//        if reload == 4{
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataSdVal, for: characteristic, type: .withResponse)
//                    reload = 0
//                }
//            }
//        }
//        if reload == 5{
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataSdValTwo, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataSdValThree, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//
//                    reload = 0
//                }
//            }
//        }
//        if reload == 10{
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataSdValTwo1, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataSdValThree1, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//
//                    reload = 0
//                }
//            }
//        }
//        if reload == 6{
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataSdParam, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    print("\(sdParam)")
//                    reload = 0
//                    print("dataSdParam: \(dataSdParam)")
//                    print("dataSdParamYet: \(dataSdParamYet)")
//                }
//            }
//        }
//        if reload == 7{
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataPassDelete, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//
//                    reload = 0
//                }
//            }
//        }
//        if reload == 8{
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataPassInstall, for: characteristic, type: .withResponse)
//                    reload = 0
//                }
//            }
//        }
//        if reload == 9{
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataPassEnter, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//
//                    reload = 0
//                }
//            }
//        }
//        if reload == 20 {
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(setZeroReload, for: characteristic, type: .withResponse)
//                    reload = 0
//                }
//            }
//        }
//        if reload == 21 {
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataSetMode, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    reload = 0
//                }
//            }
//        }
//        if reload == 22 {
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataSetParamSTL, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataSetParamSTH, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    reload = 0
//                }
//            }
//        }
//        if reload == 23 {
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataSetParamSTL, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataSetParamZaderV, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataSetParamZaderVi, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    reload = 0
//                }
//            }
//        }
//        if reload == 24 {
//            for characteristic in service.characteristics! {
//                if characteristic.properties.contains(.write) {
//                    print("Свойство \(characteristic.uuid): .write")
//                    peripheral.writeValue(dataSetParamSTL, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//
//                    peripheral.writeValue(dataSetParamSTH, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//
//                    peripheral.writeValue(dataSetParamZaderV, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//
//                    peripheral.writeValue(dataSetParamZaderVi, for: characteristic, type: .withoutResponse)
//                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    reload = 0
//                }
//            }
//        }
//
//    }
//    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
//    }
//
//    let string: String = ""
//    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//        peripheral.readRSSI()
//        print("READ: \(characteristic)")
//        let rxData = characteristic.value
//        if let rxData = rxData {
//            let numberOfBytes = rxData.count
//            var rxByteArray = [UInt8](repeating: 0, count: numberOfBytes)
//            (rxData as NSData).getBytes(&rxByteArray, length: numberOfBytes)
//            let string = String(data: Data(rxByteArray), encoding: .utf8)
//            stringAll = stringAll + string!
//            let result = stringAll.components(separatedBy: [":",",","\r"])
//            if result.count >= 35 {
//                print(result)
//                if result.contains("SE") {
//                    let indexOfPerson = result.firstIndex{$0 == "SE"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        print(indexOfPerson!)
//                        nameDevice = "\(result[indexOfPerson! + 2])"
//                        nameDeviceT = "\(result[indexOfPerson! + 2])"
//                    }
//                }
//                if result.contains("UT") {
//                    let indexOfPerson = result.firstIndex{$0 == "UT"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        temp = "\(result[indexOfPerson! + 2])"
//                    }
//                }
//                if result.contains("UN") {
//                    let indexOfPerson = result.firstIndex{$0 == "UN"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        level = "\(result[indexOfPerson! + 2])"
//                    }
//                }
//                if result.contains("VB") {
//                    let indexOfPerson = result.firstIndex{$0 == "VB"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        vatt = "\(result[indexOfPerson! + 2])"
//                    }
//                }
//                if result.contains("UD") {
//                    let indexOfPerson = result.firstIndex{$0 == "UD"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        print(indexOfPerson!)
//                        if indexOfPerson! + 2 <= result.count-1 {
//                            id = "\(result[indexOfPerson! + 2])"
//                        }
//                    }
//                }
//                if result.contains("LK") {
//                    let indexOfPerson = result.firstIndex{$0 == "LK"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        print(indexOfPerson!)
//                        valL = "\(result[indexOfPerson! + 2])"
//                    }
//                }
//                if result.contains("WM") {
//                    let indexOfPerson = result.firstIndex{$0 == "WM"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        print(indexOfPerson!)
//                        modeLabel = "\(result[indexOfPerson! + 2])"
//                    }
//                }
//                if result.contains("UL") {
//                    let indexOfPerson = result.firstIndex{$0 == "UL"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        print(indexOfPerson!)
//                        modeS = "\(result[indexOfPerson! + 2])"
//                    }
//                }
//                if result.contains("HK") {
//                    let indexOfPerson = result.firstIndex{$0 == "HK"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        print(indexOfPerson!)
//                        print(warning)
//                        valH = "\(result[indexOfPerson! + 2])"
//                    }
//                }
//                if result.contains("TO") {
//                    let indexOfPerson = result.firstIndex{$0 == "TO"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        print(indexOfPerson!)
//                        zaderV = "\(result[indexOfPerson! + 2])"
//                    }
//                }
//                if result.contains("TF") {
//                    let indexOfPerson = result.firstIndex{$0 == "TF"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        print(indexOfPerson!)
//                        zaderVi = "\(result[indexOfPerson! + 2])"
//                    }
//                }
//                if result.contains("US") {
//                    let indexOfPerson = result.firstIndex{$0 == "US"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        print(indexOfPerson!)
//                        cnt = "\(result[indexOfPerson! + 2])"
//                        if iter == false {
//                            cnt1 = result[indexOfPerson! + 2]
//                            iter = true
//                        } else {
//                            cnt2 = result[indexOfPerson! + 2]
//                        }
//                    }
//                }
//                if result.contains("APO") {
//                    passNotif = 0
//                    passwordSuccess = true
//                    print("APO 0")
//                }
//                if result.contains("ADO") {
//                    passNotif = 0
//                    passwordSuccess = true
//                    errorWRN = false
//                    print("ADO 0")
//                }
//                if result.contains("WRN") {
//                    passNotif = 1
//                    passwordSuccess = false
//                    print("WRN 1")
//
//                }
//                if result.contains("VV") {
//                    let indexOfPerson = result.firstIndex{$0 == "VV"}
//                    if indexOfPerson! + 2 <= result.count - 1 {
//                        VV = "\(result[indexOfPerson! + 2])"
//                        if VV.count >= 3 {
//                            VV.insert(".", at: VV.index(VV.startIndex, offsetBy: 1))
//                            VV.insert(".", at: VV.index(VV.startIndex, offsetBy: 3))
//                        }
//                    }
//                }
//                if result.contains("WRN") {
//                    errorWRN = true
//                }
//                if result.contains("ASA") {
//                    checkASA = true
//                }
//                if result.contains("AWO") {
//                    checkMode = true
//                }
//            }
//        }
//    }
//    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
//        if let error = error {
//            print("error: \(error)")
//            return
//        }
//
//    }
//    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
//        print(error!)
//
//    }
//    private func centralManager(
//        central: CBCentralManager,
//        didDisconnectPeripheral peripheral: CBPeripheral,
//        error: NSError?) {
//        scanBLEDevices()
//
//    }
//
//    var tableViewData = [cellDataDU]()
//    weak var tableView: UITableView!
//
//    fileprivate lazy var themeBackView3: UIView = {
//        let v = UIView()
//        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0))
//        v.layer.shadowRadius = 3.0
//        v.layer.shadowOpacity = 0.2
//        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
//        return v
//    }()
//    fileprivate lazy var MainLabel: UILabel = {
//        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-70), height: 40))
//        text.text = "Type of bluetooth sensor".localized(code)
//        text.textColor = UIColor(rgb: 0x272727)
//        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
//        return text
//    }()
//    fileprivate lazy var backView: UIImageView = {
//        let backView = UIImageView()
//        backView.frame = CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+30 : 40) - (iphone5s ? 10 : 0), width: 50, height: 40)
//        let back = UIImageView(image: UIImage(named: "back")!)
//        back.image = back.image!.withRenderingMode(.alwaysTemplate)
//        back.frame = CGRect(x: 8, y: 0 , width: 8, height: 19)
//        back.center.y = backView.bounds.height/2
//        backView.addSubview(back)
//        return backView
//    }()
//
//    override func loadView() {
//        super.loadView()
//
//        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(tableView)
//        NSLayoutConstraint.activate([
//            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: (iphone5s ? -80 : -100)),
//            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
//            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
//            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 1),
//        ])
//        self.tableView = tableView
//        tableView.backgroundColor = .clear
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
//
//    fileprivate lazy var hamburger: UIImageView = {
//        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
//        hamburger.image = hamburger.image!.withRenderingMode(.alwaysTemplate)
//
//        return hamburger
//    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        viewAlphaAlways.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        searchBar.delegate = self
//        searchBar.searchBarStyle = .minimal
//        searchBar.showsCancelButton = true
//        searchBar.keyboardType = UIKeyboardType.decimalPad
//        view.addSubview(searchBar)
//        viewShow()
//        rightCount = 0
//        manager = CBCentralManager ( delegate : self , queue : nil , options : nil )
//        stringAll = ""
//        self.tableView.dataSource = self
//        self.tableView.delegate = self
//        self.tableView.register(DevicesListCellHeder.self, forCellReuseIdentifier: "DevicesListCellHeder")
//        self.tableView.register(DevicesListCellMain.self, forCellReuseIdentifier: "DevicesListCellMain")
//        self.tableView.register(DevicesListCell.self, forCellReuseIdentifier: "DevicesListCell")
//        tableView.separatorStyle = .none
//        setupTheme()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        passNotif = 0
//        viewAlphaAlways.addSubview(activityIndicator)
//        view.addSubview(viewAlpha)
//        self.view.isUserInteractionEnabled = false
//        activityIndicator.startAnimating()
//        if QRCODE == "" {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//                self.activityIndicator.stopAnimating()
//                self.viewAlphaAlways.removeFromSuperview()
//                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                self.view.isUserInteractionEnabled = true
//
//            }
//        } else {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
//                if QRCODE != "" {
//                    if checkPopQR == false {
//                        self.timer.invalidate()
//                        self.navigationController?.popViewController(animated: true)
//                        checkPopQR = true
//                    }
//                }
//                self.view.isUserInteractionEnabled = true
//            }
//        }
//
//    }
//
//    var tr = 0
//    var container2 = UIView(frame: CGRect(x: 20, y: 50, width: Int(screenWidth-40), height: 70))
//    @objc func refresh(sender:AnyObject) {
//        RSSIMainArray = []
//        peripheralName = []
//        scanBLEDevices()
//        activityIndicator.startAnimating()
//        self.view.addSubview(viewAlpha)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                self.viewAlphaAlways.removeFromSuperview()
//                self.activityIndicator.stopAnimating()
//            }
////            self.mainPartShow()
//
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            self.refreshControl.endRefreshing()
//        }
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        if a != nil {
//            manager?.cancelPeripheralConnection(a)
//        }
//        searchBar.text = ""
//        mainPassword = ""
//        timer.invalidate()
//        self.searchBar.endEditing(true)
//        self.view.isUserInteractionEnabled = true
//        peripherals.removeAll()
//        RSSIMainArray.removeAll()
//        rrsiPink = 0
//        manager?.stopScan()
//        tableViewData.removeAll()
//        tableViewData.append(cellDataDU(opened: false, title: "123", sectionData: ["123"]))
//        tableViewData.insert(cellDataDU(opened: false, title: "1234", sectionData: ["1234"]), at: 0)
//        RSSIMainArray.append("2")
//        RSSIMainArray.insert("1", at: 0)
//
//
////        tableViewData.append(cellDataDU(opened: false, title: "1234", sectionData: ["1234"]))
//        searchList.removeAll()
//        searching = false
//        searchBar.text = ""
//        peripheralName.removeAll()
//        mainPassword = ""
//        if hidednCell == false {
//            tableView.reloadData()
//        }
//        scanBLEDevices()
//        rightCount = 0
//
//    }
//
//    func scanBLEDevices() {
//        peripherals.removeAll()
//        manager?.scanForPeripherals(withServices: nil)
//        self.view.isUserInteractionEnabled = false
//        var time = 0.0
//        if QRCODE != "" {
//            time = 12.0
//        }
//        //stop scanning after 5 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 + time) {
//
//            if QRCODE != "" {
//                if checkPopQR == false {
//                    self.timer.invalidate()
//                    self.navigationController?.popViewController(animated: true)
//                    checkPopQR = true
//                }
//            }
//            self.view.isUserInteractionEnabled = true
//        }
//    }
//    func stopScanForBLEDevices() {
//        manager?.stopScan()
//        print("Stop")
//    }
//
//    fileprivate lazy var bgImage: UIImageView = {
//        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
//        img.alpha = 0.3
//        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
//        return img
//    }()
//
//    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
//        let activity = UIActivityIndicatorView()
//        if #available(iOS 13.0, *) {
//            activity.style = .medium
//        } else {
//            activity.style = .white
//        }
//        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
//        activity.center = view.center
//        activity.color = .white
//        activity.hidesWhenStopped = true
//        activity.startAnimating()
//        return activity
//    }()
//    override func viewDidDisappear(_ animated: Bool) {
//        print("viewDidDisappear")
//        peripherals.removeAll()
//        RSSIMainArray.removeAll()
//        rrsiPink = 0
//        manager?.stopScan()
//        tableViewData.removeAll()
//        searchList.removeAll()
//        peripheralName.removeAll()
//        mainPassword = ""
//        if QRCODE == ""{
//            if tableViewData.count != 0 {
//                tableView.reloadData()
//            }
//        }
//    }
//    private func viewShow() {
//
//        view.addSubview(themeBackView3)
//        MainLabel.text = "List of available devices".localized(code)
//        view.addSubview(MainLabel)
//        view.addSubview(backView)
//
//
//        self.backView.addTapGesture{
//            self.generator.impactOccurred()
//            self.navigationController?.popViewController(animated: true)
//        }
//
//        view.addSubview(bgImage)
//        activityIndicator.startAnimating()
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            if QRCODE == "" {
//                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
////                self.view.backgroundColor = UIColor(rgb: 0x1F2222).withAlphaComponent(1)
//            }
//        }
//    }
//
//    var searching = false
//    var searchedCountry = [String]()
//    var aaa = [String]()
//    let label = UILabel()
//    fileprivate func setupTheme() {
//        if #available(iOS 13.0, *) {
//            view.theme.backgroundColor = themed { $0.backgroundColor }
//            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
//            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
//            searchBar.theme.tintColor = themed{ $0.navigationTintColor }
//            searchBar.theme.backgroundColor = themed { $0.backgroundColor }
//            backView.theme.tintColor = themed{ $0.navigationTintColor }
//        } else {
//            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
//            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
//            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
//            searchBar.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
//            searchBar.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
//            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
//        }
//
//        if isNight {
//            searchBar.textColor = .white
//        } else {
//            searchBar.textColor = .black
//        }
//    }
//}
//extension DevicesDUController: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText == ""{
//            manager?.scanForPeripherals(withServices: nil, options: nil)
//            searching = false
//            searchBar.text = ""
//        }
//        print(searchText)
//        searchList = peripheralName.filter({$0.lowercased().contains(searchText)})
//        print("searchList: \(searchList)")
////        print("peripheralName: \(peripheralName)")
//        manager?.stopScan()
//        searching = true
//        tableView.reloadData()
//        if searchText == "" {
//            searchBarCancelButtonClicked(searchBar)
//        }
//    }
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        manager?.scanForPeripherals(withServices: nil, options: nil)
//        searching = false
//        searchBar.text = ""
//        self.view.endEditing(true)
//        tableView.reloadData()
//
//    }
//
//}
//
//extension DevicesDUController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if !searching {
//            if indexPath.section == 0 || indexPath.section == rrsiPink+1 {
//                return 60
//            } else {
//                if indexPath.row == 0 {
//                    return 73
//                } else {
//                    return 65
//                }
//            }
//        } else {
//            return 73
//        }
//    }
//}
//
//
//extension DevicesDUController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(indexPath)
//        hidednCell = false
//        if indexPath.row == 0 {
//            if !searching {
//                if indexPath.section == 0 {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellHeder", for: indexPath) as! DevicesListCellHeder
//                    cell.titleLabel.text = "Nearby devices".localized(code)
//                    cell.titleLabel.font = UIFont(name: "FuturaPT-Medium", size: (iphone5s ? 18 : 20))
//                    cell.backgroundColor = .clear
//                    cell.selectionStyle = .none
//                    return cell
//
//                } else if indexPath.section == rrsiPink+1 {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellHeder", for: indexPath) as! DevicesListCellHeder
//                    cell.titleLabel.text = "Low signal devices".localized(code)
//                    cell.titleLabel.font = UIFont(name: "FuturaPT-Medium", size: (iphone5s ? 18 : 20))
//
//                    cell.backgroundColor = .clear
//                    cell.selectionStyle = .none
//                    return cell
//                } else {
//
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellMain", for: indexPath) as! DevicesListCellMain
//                    cell.titleLabel.text = tableViewData[indexPath.section].title
//                    cell.titleLabel.font = UIFont(name: "FuturaPT-Light", size: 24)
//                    cell.titleRSSI.text = "\(RSSIMainArray[indexPath.section]) dBm"
//                    cell.btnConnet.setTitle("Connect".localized(code), for: .normal)
//                    cell.backgroundColor = .clear
//                    cell.selectionStyle = .none
//                    if indexPath.section == rrsiPink {
//                        cell.separetor.isHidden = true
//                    } else {
//                        cell.separetor.isHidden = false
//                    }
//                    if indexPath.section == 1  || indexPath.section == rrsiPink + 2{
//                        cell.separetor2.isHidden = true
//                    } else {
//                        cell.separetor2.isHidden = false
//                    }
//                    cell.backgroundColor = .clear
//                    cell.btnConnet.addTapGesture {
//                        self.generator.impactOccurred()
//                        temp = nil
//                        nameDevice = ""
//                        VV = ""
//                        level = ""
//                        RSSIMain = ""
//                        vatt = ""
//                        id = ""
//                        self.activityIndicator.startAnimating()
//                        self.view.addSubview(self.viewAlpha)
//                        zeroTwo = 0
//                        zero = 0
//                        countNot = 0
//                        if !self.searching {
//                            self.stringAll = ""
//                            if indexPath.section > rrsiPink {
//                                self.manager?.connect(self.peripherals[indexPath.section-2], options: nil)
//                            } else {
//                                self.manager?.connect(self.peripherals[indexPath.section-1], options: nil)
//                            }
//                        }
//                        self.view.isUserInteractionEnabled = false
//                        self.manager?.stopScan()
//                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
//                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                            if let navController = self.navigationController {
//                                navController.pushViewController(DeviceDUBleController(), animated: true)
//                            }
//                            self.viewAlphaAlways.removeFromSuperview()
//                        })
//                    }
//                    return cell
//                }
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCellMain", for: indexPath) as! DevicesListCellMain
//                cell.separetor.isHidden = false
//                cell.titleLabel.text = searchList[indexPath.section]
//                cell.titleLabel.font = UIFont(name: "FuturaPT-Light", size: 24)
//
//                cell.backgroundColor = .clear
//                cell.selectionStyle = .none
////                cell.titleRSSI.text = "\(RSSIMainArray[indexPath.section]) dBm"
//                cell.btnConnet.addTapGesture {
//                    self.generator.impactOccurred()
//                    temp = nil
//                    nameDevice = ""
//                    self.activityIndicator.startAnimating()
//                    self.view.addSubview(self.viewAlpha)
//                    zeroTwo = 0
//                    zero = 0
//                    countNot = 0
//                    print(self.searchList)
//                    print("indexPath.section: \(indexPath.section)")
//
//                    print(self.searchList[indexPath.section])
//                    let index = peripheralName.firstIndex(of: "\(self.searchList[indexPath.section])")
//                    print("\(index!)")
//                    if self.searching {
//                        self.stringAll = ""
//                        self.manager?.connect(self.peripherals[index!], options: nil)
//                    }
//                    self.view.isUserInteractionEnabled = false
//                    self.manager?.stopScan()
//                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
//                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//                        if let navController = self.navigationController {
//                            navController.pushViewController(DeviceDUBleController(), animated: true)
//                        }
//                        self.viewAlphaAlways.removeFromSuperview()
//                    })
//                }
//                return cell
//            }
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCell", for: indexPath) as! DevicesListCell
////            cell.titleLabel.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
////            cell.macAdres.text = "MAC = F6:F6:F6:F6:F6:F6"
//            if adveLvl[indexPath.section-1] == "0" {
//                adveLvl[indexPath.section-1] = "Транспортный"
//            }
//            if adveLvl[indexPath.section-1] == "4" {
//                adveLvl[indexPath.section-1] = "Верт. вращ."
//            }
//            if adveLvl[indexPath.section-1] == "5" {
//                adveLvl[indexPath.section-1] = "Гор. вращ."
//            }
//            if adveLvl[indexPath.section-1] == "6" {
//                adveLvl[indexPath.section-1] = "Контроль угла"
//            }
//            if adveLvl[indexPath.section-1] == "9" {
//                adveLvl[indexPath.section-1] = "Ковш"
//            }
//            if adveLvl[indexPath.section-1] == "10" {
//                adveLvl[indexPath.section-1] = "Отвал"
//            }
////            cell.FW.text = "F.W. = \(adveFW[indexPath.section-1])"
//            cell.FW.text = "F.W. = 1.0.2"
//
//            cell.T.text = "Vbat = 3.5 V"
//            cell.Lvl.text = "Mode = \(adveLvl[indexPath.section-1])"
//            cell.Vbat.text = "Угол = \(adveVat[indexPath.section-1])°"
//            cell.backgroundColor = .clear
//            return cell
//        }
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.view.endEditing(true)
//        if !searching {
//            if indexPath.section != 0 && indexPath.section != rrsiPink + 1 {
//                if indexPath.row == 0 {
//                    if tableViewData[indexPath.section].opened == true {
//                            let sections = IndexSet.init(integer: indexPath.section)
//                            tableView.reloadSections(sections, with: .none)
//                        self.tableViewData[indexPath.section].opened = false
//
//                    } else {
//
//                            self.tableViewData[indexPath.section].opened = false
//                            let sections = IndexSet.init(integer: indexPath.section)
//                            tableView.reloadSections(sections, with: .none)
//                    }
//                }
//            }
//        }
//    }
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if !searching {
//            if tableViewData[section].opened == true {
//                return tableViewData[section].sectionData.count + 1
//            } else {
//                return 1
//            }
//        } else {
//            return 1
//        }
//    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if !searching {
//            return tableViewData.count
//        } else {
//            return searchList.count
//        }
//    }
//}
