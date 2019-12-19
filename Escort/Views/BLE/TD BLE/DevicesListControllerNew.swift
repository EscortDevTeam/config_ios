//
//  DevicesListControllerNew.swift
//  Escort
//
//  Created by Володя Зверев on 16.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import CoreBluetooth
import UIDrawer

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String()]
}
var rrsiPink = 0
var kCBAdvDataManufacturerData = ""
class DevicesListControllerNew: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, SecondVCDelegate {
    
    func secondVC_BackClicked(data: String) {
        viewShow()
    }
    var (headerView, backView) = headerSet(title: "List of available devices".localized(code), showBack: true)
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: headerHeight, width: screenWidth, height: 35))
    var refreshControl = UIRefreshControl()
    var attributedTitle = NSAttributedString()
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    let popUpVCNext = UIStoryboard(name: "MainSelf", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopupViewController // 1
    var peripherals = [CBPeripheral]()
    var peripheralsSearch = [CBPeripheral]()
    var manager:CBCentralManager? = nil
    let DeviceBLEC = DeviceBleController()
    var timer = Timer()
    var stringAll: String = ""
    var iter = false
    var parsedData:[String : AnyObject] = [:]
    var bluetoothPeripheralManager: CBPeripheralManager?
    var searchList = [String]()
    
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
                                peripherals.insert(peripheral, at: 0)
                                peripheralName.insert(peripheral.name!, at: 0)
                                tableViewData.insert(cellData(opened: false, title: "\(peripheral.name!)", sectionData: ["\(peripheral.name!)"]), at: 0)
                                print("RSSIName: \(peripheral.name!) and  RSSI: \(RSSI)")
                                RSSIMainArray.insert("\(RSSI)", at: 0)
                                if let manufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data {
                                    assert(manufacturerData.count >= 7)
                                    let nodeID = manufacturerData[2]
                                    print(String(format: "%02X", nodeID)) //->FE
                                    
                                    let state = UInt16(manufacturerData[3]) + UInt16(manufacturerData[4]) << 8
                                    let string34 = "\(String(format: "%04X", state))"
                                    print(string34) //->000D
                                    let result34 = UInt16(strtoul("0x\(string34)", nil, 16)) //уровень
                                    print(result34) //->000D
                                    adveLvl.insert(String(result34), at: 0)
                                    //c6f - is the sensor tag battery voltage
                                    //Constructing 2-byte data as big endian (as shown in the Java code)
                                    let batteryVoltage = UInt16(manufacturerData[5])
                                    let string5 = "\(String(format: "%02X", batteryVoltage))"
                                     print(string5) //->000D
                                    let result5 = UInt16(strtoul("0x\(string5)", nil, 16)) //напряжение
                                    var abn: String = String(result5)
                                    abn.insert(".", at: abn.index(abn.startIndex, offsetBy: 1))
                                    print(abn) //->000D
                                    adveVat.insert(abn, at: 0)

                                    //32- is the BLE packet counter.
                                    let packetCounter = manufacturerData[6]
                                    let string6 = "\(String(format: "%02X", packetCounter))"
                                    print(string6) //->000D
                                    let result6 = UInt16(strtoul("0x\(string6)", nil, 16)) //температура
                                    print(result6)
                                    adveTemp.insert(String(result6), at: 0)
                                    
                                    let versionCounter = manufacturerData[7]
                                    let string7 = "\(String(format: "%02X", versionCounter))"
                                    print(string7) //->000D
                                    let result7 = UInt16(strtoul("0x\(string7)", nil, 16)) //весрия
                                    var abn7: String = String(result7)
                                    abn7.insert(".", at: abn7.index(abn7.startIndex, offsetBy: 1))
                                    abn7.insert(".", at: abn7.index(abn7.startIndex, offsetBy: 3))
                                    print(abn7)
                                    adveFW.insert(String(abn7), at: 0)
                                }

                            } else {
                                peripherals.append(peripheral)
                                peripheralName.append(peripheral.name!)
                                print("RSSIName: \(peripheral.name!) and  RSSI: \(RSSI)")
                                tableViewData.append(cellData(opened: false, title: "\(peripheral.name!)", sectionData: ["\(peripheral.name!)"]))
                                RSSIMainArray.append("\(RSSI)")
                                if let manufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data {
                                    assert(manufacturerData.count >= 7)
                                    let nodeID = manufacturerData[2]
                                    print(String(format: "%02X", nodeID)) //->FE
                                    
                                    let state = UInt16(manufacturerData[3]) + UInt16(manufacturerData[4]) << 8
                                    let string34 = "\(String(format: "%04X", state))"
                                    print(string34) //->000D
                                    let result34 = UInt16(strtoul("0x\(string34)", nil, 16)) //уровень
                                    print(result34) //->000D
                                    adveLvl.append(String(result34))
                                    //c6f - is the sensor tag battery voltage
                                    //Constructing 2-byte data as big endian (as shown in the Java code)
                                    let batteryVoltage = UInt16(manufacturerData[5])
                                    let string5 = "\(String(format: "%02X", batteryVoltage))"
                                     print(string5) //->000D
                                    let result5 = UInt16(strtoul("0x\(string5)", nil, 16)) //напряжение
                                    var abn: String = String(result5)
                                    abn.insert(".", at: abn.index(abn.startIndex, offsetBy: 1))
                                    print(abn) //->000D
                                    adveVat.append(abn)

                                    //32- is the BLE packet counter.
                                    let packetCounter = manufacturerData[6]
                                    let string6 = "\(String(format: "%02X", packetCounter))"
                                    print(string6) //->000D
                                    let result6 = UInt16(strtoul("0x\(string6)", nil, 16)) //температура
                                    print(result6)
                                    adveTemp.append(String(result6))
                                    
                                    let versionCounter = manufacturerData[7]
                                    let string7 = "\(String(format: "%02X", versionCounter))"
                                    print(string7) //->000D
                                    let result7 = UInt16(strtoul("0x\(string7)", nil, 16)) //весрия
                                    var abn7: String = String(result7)
                                    abn7.insert(".", at: abn7.index(abn7.startIndex, offsetBy: 1))
                                    abn7.insert(".", at: abn7.index(abn7.startIndex, offsetBy: 3))
                                    print(abn7)
                                    adveFW.append(String(abn7))

                                }
                            }
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
                            self.manager?.stopScan()
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6), execute: {
                                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                                if let navController = self.navigationController {
                                    navController.pushViewController(DeviceBleController(), animated: true)
                                }
                                print("Connected to " +  peripheral.name!)
                                self.viewAlpha.removeFromSuperview()
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
    
    var tableViewData = [cellData]()
    weak var tableView: UITableView!

    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: -100),
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
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        searchBar.tintColor = .white
        searchBar.textColor = .white
        searchBar.keyboardType = UIKeyboardType.decimalPad
        view.addSubview(searchBar)
        viewShow()
        rightCount = 0
        manager = CBCentralManager ( delegate : self , queue : nil , options : nil )

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(DevicesListCellHeder.self, forCellReuseIdentifier: "DevicesListCellHeder")
        self.tableView.register(DevicesListCellMain.self, forCellReuseIdentifier: "DevicesListCellMain")
        self.tableView.register(DevicesListCell.self, forCellReuseIdentifier: "DevicesListCell")
        tableView.separatorStyle = .none
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.viewAlpha.removeFromSuperview()
                self.activityIndicator.stopAnimating()
            }
//            self.mainPartShow()
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.refreshControl.endRefreshing()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
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
        searchList.removeAll()
        searching = false
        searchBar.text = ""
        peripheralName.removeAll()
        mainPassword = ""
        if hidednCell == false {
            tableView.reloadData()
        }
        scanBLEDevices()
        rightCount = 0
        headerView = headerSet(title: "List of available devices".localized(code))

    }
    
    func scanBLEDevices() {
        peripherals.removeAll()
        manager?.scanForPeripherals(withServices: nil)
        self.view.isUserInteractionEnabled = false
        var time = 0.0
        if QRCODE != "" {
            time = 9.0
        }
        //stop scanning after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0 + time) {

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
        print("Stop")
    }
    
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
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        peripherals.removeAll()
        RSSIMainArray.removeAll()
        rrsiPink = 0
        manager?.stopScan()
        tableViewData.removeAll()
        searchList.removeAll()
        peripheralName.removeAll()
        mainPassword = ""
        if QRCODE == ""{
            if tableViewData.count != 0 {
                tableView.reloadData()
            }
        }
    }
    private func viewShow() {
//        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            (self.headerView, self.backView) = headerSet(title: "List of available devices".localized(code), showBack: true)
            self.view.addSubview(self.headerView)
            self.view.addSubview(self.backView!)
            self.view.addSubview(self.viewAlpha)
            self.backView!.addTapGesture{
                self.navigationController?.popViewController(animated: true)
            }
        }
        view.addSubview(bgImage)
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if QRCODE == "" {
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.viewAlpha.removeFromSuperview()
                self.view.backgroundColor = UIColor(rgb: 0x1F2222).withAlphaComponent(1)
                self.activityIndicator.stopAnimating()
            }
//            self.mainPartShow()
            
        }
        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
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

    }
    
    var searching = false
    var searchedCountry = [String]()
    var aaa = [String]()
    let label = UILabel()

}
extension DevicesListControllerNew: UISearchBarDelegate {
    
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

extension DevicesListControllerNew: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DrawerPresentationController(presentedViewController: presented, presenting: presenting)
    }
}


extension DevicesListControllerNew: UITableViewDelegate {
    
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


extension DevicesListControllerNew: UITableViewDataSource {
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
                    cell.titleLabel.text = tableViewData[indexPath.section-1].title
                    cell.titleLabel.font = UIFont(name: "FuturaPT-Light", size: 24)
                    cell.titleRSSI.text = "\(RSSIMainArray[indexPath.section-1]) dBm"
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
                        temp = nil
                        nameDevice = ""
                        self.activityIndicator.startAnimating()
                        self.view.addSubview(self.viewAlpha)
                        zeroTwo = 0
                        zero = 0
                        countNot = 0
                        if !self.searching {
                            self.manager?.connect(self.peripherals[indexPath.section-1], options: nil)
                        }
                        self.view.isUserInteractionEnabled = false
                        self.manager?.stopScan()
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                            if let navController = self.navigationController {
                                navController.pushViewController(DeviceBleController(), animated: true)
                            }
                            self.viewAlpha.removeFromSuperview()
                        })
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
                    temp = nil
                    nameDevice = ""
                    self.activityIndicator.startAnimating()
                    self.view.addSubview(self.viewAlpha)
                    zeroTwo = 0
                    zero = 0
                    countNot = 0
                    print(self.searchList)
                    print("indexPath.section: \(indexPath.section)")

                    print(self.searchList[indexPath.section])
                    let index = peripheralName.firstIndex(of: "\(self.searchList[indexPath.section])")
                    print("\(index!)")
                    if self.searching {
                        self.manager?.connect(self.peripherals[index!], options: nil)
                    }
                    self.view.isUserInteractionEnabled = false
                    self.manager?.stopScan()
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                        if let navController = self.navigationController {
                            navController.pushViewController(DeviceBleController(), animated: true)
                        }
                        self.viewAlpha.removeFromSuperview()
                    })
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DevicesListCell", for: indexPath) as! DevicesListCell
//            cell.titleLabel.text = tableViewData[indexPath.section].sectionData[indexPath.row - 1]
//            cell.macAdres.text = "MAC = F6:F6:F6:F6:F6:F6"
            cell.FW.text = "F.W. = \(adveFW[indexPath.section-1])"
            cell.FW.textColor = .white
            cell.T.text = "Temperature = \(adveTemp[indexPath.section-1]) C°"
            cell.T.textColor = .white
            cell.Lvl.text = "Level = \(adveLvl[indexPath.section-1])"
            cell.Lvl.textColor = .white
            cell.Vbat.text = "Vbatt = \(adveVat[indexPath.section-1]) V"
            cell.Vbat.textColor = .white
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
                            
                            self.tableViewData[indexPath.section].opened = true
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
