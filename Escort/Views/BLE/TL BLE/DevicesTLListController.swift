//
//  DevicesTLListController.swift
//  Escort
//
//  Created by Володя Зверев on 08.11.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//
var cellHeight = 70

import UIKit
import CoreBluetooth
import UIDrawer
import RxSwift
import RxTheme
import RealmSwift

var CBPeripheralForDisconnect : CBPeripheral!
var CBServiceForDisconnect : CBService!

struct cellDataTL {
    var opened = Bool()
    var title = String()
    var sectionData = [String()]
}

protocol ConnectedDelegate: class {
    func buttonTap()
    func enterPaswwordAlert(isNewPassword: Bool)
}

class DevicesTLListController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, ConnectedDelegate {
    let realm: Realm  = {
        return try! Realm()
    }()
    
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: headerHeight + (iphone5s ? 10 : 0), width: screenWidth, height: 35))
    var attributedTitle = NSAttributedString()
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    var peripherals = [CBPeripheral]()
    var peripheralsSearch = [CBPeripheral]()
    var manager:CBCentralManager? = nil
    var timer = Timer()
    var stringAll: String = ""
    var iter = false
    var parsedData:[String : AnyObject] = [:]
    var bluetoothPeripheralManager: CBPeripheralManager?
    var searchList = [String]()
    let generator = UIImpactFeedbackGenerator(style: .light)
    let tlVC = TLController()
    var isTL = true
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
    let cancelLabel: UILabel = {
        let cancelLabel = UILabel()
        cancelLabel.text = "Отменить"
        cancelLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelLabel.textColor = .red
        cancelLabel.clipsToBounds = false
        cancelLabel.isHidden = true
        cancelLabel.font = UIFont(name: "FuturaPT-Medium", size: 20)
        cancelLabel.layer.shadowColor = UIColor.white.cgColor
        cancelLabel.layer.shadowRadius = 5.0
        cancelLabel.layer.shadowOpacity = 0.7
        cancelLabel.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        return cancelLabel
    }()
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .red
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
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
        let key = "kCBAdvDataServiceUUIDs"
        print("advertisementData: \(advertisementData)")
        if peripheral.name != nil {
            let nameDevicesOps = peripheral.name!.components(separatedBy: ["_"])
            var searchForName = ""
            if isTL {
                searchForName = "TL"
            } else {
                searchForName = "TH"
            }
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
                                tableViewData.insert(cellData(opened: false, title: "\(peripheral.name!)", sectionData: ["\(peripheral.name!)"]), at: rrsiPink)
                                print("RSSIName: \(peripheral.name!) and  RSSI: \(RSSI)")
                                RSSIMainArray.insert("\(RSSI)", at: rrsiPink)
                            } else {
                                peripherals.append(peripheral)
                                peripheralName.append(peripheral.name!)
                                print("RSSIName: \(peripheral.name!) and  RSSI: \(RSSI)")
                                tableViewData.append(cellData(opened: false, title: "\(peripheral.name!)", sectionData: ["\(peripheral.name!)"]))
                                RSSIMainArray.append("\(RSSI)")
                            }
                            stopActivityIndicator()
                            tableView.reloadData()
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
                        if peripheral.name! == (isTL ? "TL" : "TH") + "_\(QRCODE)" {
                            print("YEEEES \(peripheral.name!)")
                            self.manager?.connect(peripheral, options: nil)
                            self.view.isUserInteractionEnabled = true
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                            self.manager?.stopScan()
                            self.startActivityIndicator()
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
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if let navController = self.navigationController {
            blackBoxStart = false
//            Access_Allowed = 0
            mainPassword = ""
            viewModel.isTL = isTL
            viewModel.passwordFirst = true
            tlVC.deviceTLVC.passwortIsEnter = false
            newPassword = true
            tlVC.viewModel = viewModel
            stopActivityIndicator()
            navController.pushViewController(tlVC, animated: true)
        }
        self.viewAlpha.isHidden = true

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
                let alert = UIAlertController(title: "Warning".localized(code), message: "Connection is lost.".localized(code) + " \(self.isTL ? "TL" : "TH") \(nameDevice)", preferredStyle: .alert)
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
        if reload != 12 {
            stringAll.removeAll()
        } else {
            interestCalculation()
        }
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
        let passZero = "SP,PN:1:2211\r"
        let passDelete = "SP,PN:1:0,"
        let passInstall = "SP,PN:1:\(mainPassword)\r"
        let enterPass = "SP,PN:1:\(mainPassword),"
        let blackBox = "GL,LL:1:\(blocks),"
        let stopBlackBox = "GS,"
        let date = NSDate()
        let timestamp = date.timeIntervalSince1970
        let blackBoxTimeUnix = "ST,TS:1:\(timestamp),"
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
        let dataBlackBox = Data(blackBox.utf8)
        let dataStopBlackBox = Data(stopBlackBox.utf8)
        let dataValueLogReload = Data(valueLogReload.utf8)
        let dataBlackBoxTimeUnix = Data(blackBoxTimeUnix.utf8)

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
        if reload == 11{
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    countStringBlackBox = 0
                    peripheral.writeValue(dataBlackBox, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
//                    peripheral.writeValue(dataReloadFN, for: characteristic, type: .withResponse)
                    reload = -1
                }
            }
        }
        if reload == 12{
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    stringAll = ""
                    peripheral.writeValue(dataStopBlackBox, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                }
            }
        }
        if reload == 13{
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataValueLogReload, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    reload = -1
                }
            }
        }
        if reload == 14 {
            for characteristic in serviceCharacteristics {
                if characteristic.properties.contains(.write) {
                    peripheral.writeValue(dataBlackBoxTimeUnix, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataR, for: characteristic, type: .withResponse)
                    reload = -1
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
                if string!.contains("\r") {
                    print(stringAll)
                    let packet = result
                    if !packet.contains("TR") {
                        if packet[0] == "L" {
                            guard 1 <= (packet.count - 5) / 5 - 1 else { return }
                            for i in 0...(packet.count - 5) / 5 - 1 {
                                print("Пакет: \(packet[1]), время: \(packet[3]), температура: \(packet[4])")
                                let blackBox = ModelBox()
                                blackBox.id = countStringBlackBox
                                blackBox.nameDevice = "TH " + nameDevice
                                let intTime: Int? = Int(packet[3])
                                blackBox.time = "\(intTime! - 120 * i)"
                                let tempeture = Double(packet[4 + 5 * i])! / 10
                                print("tempeture: \(tempeture)")
                                blackBox.temp = "\(tempeture)"
                                blackBox.pressere = packet[5 + 5 * i]
                                blackBox.lux = packet[6 + 5 * i]
                                let humidity = Double(packet[7 + 5 * i])! / 10
                                blackBox.humidity = "\(humidity)"
                                blackBox.hallSensor = packet[8 + 5 * i]
                                countStringBlackBox += 1
                                do {
                                    var config = Realm.Configuration(
                                        schemaVersion: 0,
                                        
                                        migrationBlock: { migration, oldSchemaVersion in
                                            if (oldSchemaVersion < 0) {
                                            }
                                        })
                                    config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("BD.realm")
                                    config.readOnly = true
                                    Realm.Configuration.defaultConfiguration = config
                                    
                                    try realm.write {
                                        realm.add(blackBox)
                                    }
                                } catch {
                                    print("error getting xml string: \(error)")
                                }
                            }
                        } else { return }
                    } else {
                        countPackets = "\(packet[5])"
                    }
                    countPacket = packet[1]
                    interestCalculation()
                    stringAll.removeAll()
                } else {
                    return
                }
            } else {
                print(stringAll)
                
                if result.count >= 0 {
                    if result.contains("SMO") {
                        print("SMO 0")
                        viewAlphaAlways.isHidden = true
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        if tlVC.deviceTLVC.numberOfButton == 1 {
                            tlVC.deviceTLVC.numberOfButton = 0
                            let window = UIApplication.shared.keyWindow!
                            window.rootViewController?.showToast(message: "Data has been deleted".localized(code), seconds: 1.0)
                        }
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
                    if result.contains("UH") {
                        let indexOfPerson = result.firstIndex{$0 == "UH"}
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
                    if result.contains("ATO") {
                        let window = UIApplication.shared.keyWindow!
                        window.rootViewController?.showToast(message: "Synchronization is complete".localized(code), seconds: 1.0)
                        newPassword = false
                        tlVC.deviceTLVC.tableView.reloadData()
                        tlVC.deviceTLVC.passwortIsEnter = true
                        viewAlphaAlways.isHidden = true
                        tlVC.deviceTLVC.numberOfButton = 0
                    }
                    if result.contains("APO") {
                        if zero == 1 {
                            newPassword = false
                            zero = 0
                            let window = UIApplication.shared.keyWindow!
                            window.rootViewController?.showToast(message: "Default password is already set".localized(code), seconds: 1.0)
                            newPassword = false
                        }
                        print("APO 0")
                        if let viewControllers = navigationController?.viewControllers {
                            for viewController in viewControllers {
                                if viewController.isKind(of: TLTHSettingsController.self) {
                                    if tlVC.deviceTLVC.numberOfButton == 1 {
                                        reload = 14
                                        viewAlphaAlways.isHidden = false
                                        buttonTap()
                                    } else if tlVC.deviceTLVC.numberOfButton == 2 {
                                        tlVC.deviceTLVC.tableView.reloadData()
                                        tlVC.deviceTLVC.passwortIsEnter = true
                                        newPassword = false
                                        viewAlphaAlways.isHidden = true
                                        tlVC.deviceTLVC.numberOfButton = 0
                                        tlVC.deviceTLVC.alertUpdate()
                                    } else {
                                        if tlVC.deviceTLVC.passwortIsEnter {
                                            if !newPassword {
                                                let window = UIApplication.shared.keyWindow!
                                                window.rootViewController?.showToast(message: "Password deleted successfully".localized(code), seconds: 1.0)
                                                newPassword = true
                                                mainPassword = ""
                                                tlVC.deviceTLVC.tableView.reloadData()
                                                tlVC.deviceTLVC.passwortIsEnter = false
                                                viewAlphaAlways.isHidden = true
                                            } else {
                                                let window = UIApplication.shared.keyWindow!
                                                window.rootViewController?.showToast(message: "Password set successfully".localized(code), seconds: 1.0)
                                                newPassword = false
                                                tlVC.deviceTLVC.tableView.reloadData()
                                                tlVC.deviceTLVC.passwortIsEnter = false
                                                viewAlphaAlways.isHidden = true
                                                
                                            }
                                        } else {
                                            let window = UIApplication.shared.keyWindow!
                                            window.rootViewController?.showToast(message: "Password is entered".localized(code), seconds: 1.0)
                                            newPassword = false
                                            tlVC.deviceTLVC.tableView.reloadData()
                                            tlVC.deviceTLVC.passwortIsEnter = true
                                            viewAlphaAlways.isHidden = true
                                        }
                                    }
                                }
                                if viewController.isKind(of: BlackBoxTHController.self) {
                                    tlVC.deviceTLVC.passwortIsEnter = true
                                    newPassword = false
                                    if tlVC.blackBoxVC.numberOfButton == 1  {
                                        tlVC.blackBoxVC.startLoadingBlackBox()
                                        tlVC.blackBoxVC.numberOfButton = 0
                                    }
                                    if tlVC.blackBoxVC.numberOfButton == 2  {
                                        tlVC.blackBoxVC.startLoadingBlackBox()
                                    }
                                    if tlVC.blackBoxVC.numberOfButton == 3  {
                                        tlVC.blackBoxVC.createAlertDeleteLog()
                                        tlVC.blackBoxVC.numberOfButton = 0
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
                        tlVC.deviceTLVC.popToVC()
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
                                    tlVC.deviceTLVC.tableView.reloadData()
                                    tlVC.deviceTLVC.passwortIsEnter = false
                                    viewAlphaAlways.isHidden = true
                                }
                                if viewController.isKind(of: BlackBoxTHController.self) {
                                    let window = UIApplication.shared.keyWindow!
                                    window.rootViewController?.showToast(message: "Wrong password".localized(code), seconds: 1.0)
                                    mainPassword = ""
                                }
                            }
                        }
                    }
                    if result.contains("VV") {
                        let indexOfPerson = result.firstIndex{$0 == "VV"}
                        if result.count > indexOfPerson! + 2 {
                            VV = "\(result[indexOfPerson! + 2])"
                            if VV != " " && VV != "" {
                                VV.insert(".", at: VV.index(VV.startIndex, offsetBy: 1))
                                VV.insert(".", at: VV.index(VV.startIndex, offsetBy: 3))
                                if let viewControllers = navigationController?.viewControllers {
                                    for viewController in viewControllers {
                                        if viewController.isKind(of: TLController.self) {
                                            tlVC.tableView.reloadData()
                                            tlVC.refreshControl.endRefreshing()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if result.contains("WM") {
                        let indexOfPerson = result.firstIndex{$0 == "WM"}
                        if result.count > indexOfPerson! + 2 {
                            wmMax = "\(result[indexOfPerson! + 2])"
                            if let wmMaxUINt = Int(wmMax) {
                                wmMaxInt = wmMaxUINt
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
    
    var tableViewData = [cellData]()
    weak var tableView: UITableView!
    
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
    
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant:  (iphone5s ? -80 : -100)),
            self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 1),
        ])
        tableView.refreshControl = refreshControl
        self.tableView = tableView
        tableView.backgroundColor = .clear
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        alertView.CustomTextField.delegate = self
        initialY = alertView.frame.origin.y
        
        alertViewNewPassword.CustomTextField.delegate = self
        alertViewNewPassword.CustomTextFieldSecond.delegate = self
        initialY = alertViewNewPassword.frame.origin.y

        tlVC.delegate = self
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.keyboardType = UIKeyboardType.decimalPad
        view.addSubview(searchBar)
        viewShow()
        view.addSubview(cancelLabel)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        cancelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 45).isActive = true
        
        cancelLabel.addTapGesture { [self] in
            print("Stop")
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
        MainLabel.text = "List of available devices".localized(code)
        searchBar.text = ""
        self.tableView.alpha = 0.0
        self.searchBar.endEditing(true)
        peripherals.removeAll()
        RSSIMainArray.removeAll()
        rrsiPink = 0
        manager?.stopScan()
        tableViewData.removeAll()
        tableViewData.append(cellData(opened: false, title: "123", sectionData: ["123"]))
        tableViewData.insert(cellData(opened: false, title: "1234", sectionData: ["1234"]), at: 0)
        RSSIMainArray.append("2")
        RSSIMainArray.insert("1", at: 0)
        searchList.removeAll()
        searching = false
        peripheralName.removeAll()
        cancelLabel.text = "Cancel".localized(code)
    }
    func interestCalculation() {
        guard let countPacketsInts = Double(countPackets),
              let countPacketInts = Double(countPacket) else {return}
        if countPackets == "0" {
            tlVC.blackBoxVC.deleteLogger()
            showToast(message: "Black box is emptied".localized(code), seconds: 1.0)
        } else {
            let intResult: Int = Int(100 * (countPacketInts / countPacketsInts))
            inverst = "\(intResult)"
        }
        print("lol")
        tlVC.blackBoxVC.timerStart()
    }
    
    var tr = 0
    @objc func refresh(sender:AnyObject) {
        self.startActivityIndicator()
        searchBar.text = ""
        mainPassword = ""
        timer.invalidate()
        self.searchBar.endEditing(true)
        self.view.isUserInteractionEnabled = true
        peripherals.removeAll()
        RSSIMainArray.removeAll()
        rrsiPink = 0
        manager?.stopScan()
        tableViewData.removeAll()
        tableViewData.append(cellData(opened: false, title: "123", sectionData: ["123"]))
        tableViewData.insert(cellData(opened: false, title: "1234", sectionData: ["1234"]), at: 0)
        RSSIMainArray.append("2")
        RSSIMainArray.insert("1", at: 0)
        searchList.removeAll()
        searching = false
        searchBar.text = ""
        peripheralName.removeAll()
        mainPassword = ""
        if hidednCell == false {
            tableView.reloadData()
        }
        scanBLEDevices()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
    }
    func startActivityIndicator() {
        self.viewAlpha.isHidden = false
        self.cancelLabel.isHidden = false
        cancelLabel.superview?.bringSubviewToFront(cancelLabel)
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5, animations: { [self] in
            self.tableView.alpha = 0.0
        }) { [self] (_) in
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        self.viewAlpha.isHidden = true
        self.cancelLabel.isHidden = true
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
        if hidednCell == false {
            tableView.reloadData()
        }
        rightCount = 0
        scanBLEDevices()
    }
    
    func scanBLEDevices() {
        peripherals.removeAll()
        manager?.scanForPeripherals(withServices: nil)
        self.view.isUserInteractionEnabled = true
        var time = 0.0
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
        if QRCODE == ""{
            if tableViewData.count != 0 {
                tableView.reloadData()
            }
        }
    }
    private func viewShow() {
        
        view.addSubview(themeBackView3)
        MainLabel.text = "List of available devices".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)

        self.backView.addTapGesture{
            self.generator.impactOccurred()
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(bgImage)
        activityIndicator.startAnimating()
        viewAlpha.isHidden = true
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.center = viewAlpha.center
        view.addSubview(viewAlpha)
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
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            searchBar.theme.tintColor = themed{ $0.navigationTintColor }
            searchBar.theme.backgroundColor = themed { $0.backgroundColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            searchBar.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            searchBar.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }

        if isNight {
            searchBar.textColor = .white
        } else {
            searchBar.textColor = .black
        }
    }
}
extension DevicesTLListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            manager?.scanForPeripherals(withServices: nil, options: nil)
            searching = false
            searchBar.text = ""
        }
        print(searchText)
        searchList = peripheralName.filter({$0.lowercased().contains(searchText)})
        print("searchList: \(searchList)")
//        print("peripheralName: \(peripheralName)")
        manager?.stopScan()
        searching = true
        tableView.reloadData()
        if searchText == "" {
            searchBarCancelButtonClicked(searchBar)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        manager?.scanForPeripherals(withServices: nil, options: nil)
        searching = false
        searchBar.text = ""
        self.view.endEditing(true)
        tableView.reloadData()

    }
    
}

extension DevicesTLListController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting, blurEffectStyle: isNight ? .light : .dark)
    }
}


extension DevicesTLListController: UITableViewDelegate {
    
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


extension DevicesTLListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        hidednCell = false
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
                                self.manager?.connect(self.peripherals[indexPath.section-2], options: nil)
                            } else {
                                self.manager?.connect(self.peripherals[indexPath.section-1], options: nil)
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
                    self.viewAlpha.isHidden = false
                    zeroTwo = 0
                    zero = 0
                    countNot = 0
                    print(self.searchList)
                    print("indexPath.section: \(indexPath.section)")

                    print(self.searchList[indexPath.section])
                    let index = peripheralName.firstIndex(of: "\(self.searchList[indexPath.section])")
                    print("\(index!)")
                    if self.searching {
                        self.stringAll = ""
                        self.manager?.connect(self.peripherals[index!], options: nil)
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
        self.view.endEditing(true)
        if !searching {
            if indexPath.section != 0 && indexPath.section != rrsiPink + 1 {
                if indexPath.row == 0 {
                    if tableViewData[indexPath.section].opened == true {
                        UIView.animate(withDuration: 0.1, animations: {
                            let sections = IndexSet.init(integer: indexPath.section)
                            tableView.reloadSections(sections, with: .none)
                        })
                        self.tableViewData[indexPath.section].opened = false

                    } else {
                        UIView.animate(withDuration: 0.1, animations: {
                            
                            self.tableViewData[indexPath.section].opened = false
                            let sections = IndexSet.init(integer: indexPath.section)
                            tableView.reloadSections(sections, with: .none)
                        })
                    }
                }
            }
        }
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

