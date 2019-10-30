//
//  DevicesListController.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 10.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit
import CoreBluetooth

class DevicesListController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, SecondVCDelegate {
    func secondVC_BackClicked(data: String) {
        print("data22: \(data)")
        updateLangues(code: code)
        viewShow()
    }
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    let searchBar = UISearchBar(frame: CGRect(x: 0, y: headerHeight, width: screenWidth, height: 35))
    var refreshControl = UIRefreshControl()
    var attributedTitle = NSAttributedString()
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    var serviceUUIDMain = "6E400001-B5A3-F393-E0A9-"
    let popUpVC = UIStoryboard(name: "MenuSelf", bundle: nil).instantiateViewController(withIdentifier: "popUpVCid") as! PopupTwoVC // 1

//    let serviceUUID = CBUUID(string:"6E400001-B5A3-F393-E0A9-FFEEDDC18C3B")
    var peripherals = [CBPeripheral]()
    var manager:CBCentralManager? = nil
    var parentView: DeviceBleController!
    var periheral:CBPeripheral?
    let DeviceBLEC = DeviceBleController()
    var timer = Timer()
    var stringAll: String = ""
    
    var parsedData:[String : AnyObject] = [:]

    
    func updateLangues(code: String){
        popUpVC.parsedData = parsedData
        DeviceBLEC.parsedData = parsedData
        if let name0 = parsedData["9"] {
            let dict = name0 as? [String: Any]
            switch code {
            case "ru":
                if let name1 = dict!["title_ru"]{
                    openDevices = name1 as! String
                }
                print(code)
            case "en":
                if let name1 = dict!["title_en"]{
                    print(name1 as! NSString)
                    openDevices = name1 as! String
                }
                print(code)
            case "pr":
                if let name1 = dict!["title_pr"]{
                    print(name1 as! NSString)
                    openDevices = name1 as! String
                }
                print(code)
            case "es":
                if let name1 = dict!["title_es"]{
                    print(name1 as! NSString)
                    openDevices = name1 as! String
                }
                print(code)
            default:
                print("")
            }
        }
        if let name0 = parsedData["41"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        self.DeviceBLEC.setting = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        self.DeviceBLEC.setting = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        self.DeviceBLEC.setting = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        self.DeviceBLEC.setting = name1 as! String
                    }
                default:
                    print("")
                }
        }
        if let name0 = parsedData["42"] {
            let dict = name0 as? [String: Any]
            switch code {
            case "ru":
                if let name1 = dict!["title_ru"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.features = name1 as! String
                    settingDop = name1 as! String
                }
            case "en":
                if let name1 = dict!["title_en"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.features = name1 as! String
                    settingDop = name1 as! String
                }
            case "pr":
                if let name1 = dict!["title_pr"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.features = name1 as! String
                    settingDop = name1 as! String
                }
            case "es":
                if let name1 = dict!["title_es"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.features = name1 as! String
                    settingDop = name1 as! String
                }
            default:
                print("")
            }
        }
        if let name0 = parsedData["43"] {
                            let dict = name0 as? [String: Any]
                            switch code {
                            case "ru":
                                if let name1 = dict!["title_ru"]{
                                    print(name1 as! NSString)
                                    reference = name1 as! String
                                }
                                print(code)
                            case "en":
                                if let name1 = dict!["title_en"]{
                                    print(name1 as! NSString)
                                    reference = name1 as! String
                                }
                                print(code)
                            case "pr":
                                if let name1 = dict!["title_pr"]{
                                    print(name1 as! NSString)
                                    reference = name1 as! String
                                }
                                print(code)
                            case "es":
                                if let name1 = dict!["title_es"]{
                                    print(name1 as! NSString)
                                    reference = name1 as! String
                                }
                                print(code)
                            default:
                                print("")
                            }
                        }
        if let name0 = parsedData["65"] {
                            let dict = name0 as? [String: Any]
                            switch code {
                            case "ru":
                                if let name1 = dict!["title_ru"]{
                                    print(name1 as! NSString)
                                    self.DeviceBLEC.levelLabel = name1 as! String
                                }
                                print(code)
                            case "en":
                                if let name1 = dict!["title_en"]{
                                    print(name1 as! NSString)
                                    self.DeviceBLEC.levelLabel = name1 as! String
                                }
                                print(code)
                            case "pr":
                                if let name1 = dict!["title_pr"]{
                                    print(name1 as! NSString)
                                    self.DeviceBLEC.levelLabel = name1 as! String
                                }
                                print(code)
                            case "es":
                                if let name1 = dict!["title_es"]{
                                    print(name1 as! NSString)
                                    self.DeviceBLEC.levelLabel = name1 as! String
                                }
                                print(code)
                            default:
                                print("")
                            }
        }
        if let name0 = parsedData["40"] {
            let dict = name0 as? [String: Any]
            switch code {
            case "ru":
                if let name1 = dict!["title_ru"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.connected = name1 as! String
                }
                print(code)
            case "en":
                if let name1 = dict!["title_en"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.connected = name1 as! String
                }
                print(code)
            case "pr":
                if let name1 = dict!["title_pr"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.connected = name1 as! String
                }
                print(code)
            case "es":
                if let name1 = dict!["title_es"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.connected = name1 as! String
                }
                print(code)
            default:
                print("")
            }
        }
        if let name0 = parsedData["39"] {
            let dict = name0 as? [String: Any]
            switch code {
            case "ru":
                if let name1 = dict!["title_ru"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.DontConnected = name1 as! String
                }
                print(code)
            case "en":
                if let name1 = dict!["title_en"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.DontConnected = name1 as! String
                }
                print(code)
            case "pr":
                if let name1 = dict!["title_pr"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.DontConnected = name1 as! String
                }
                print(code)
            case "es":
                if let name1 = dict!["title_es"]{
                    print(name1 as! NSString)
                    self.DeviceBLEC.DontConnected = name1 as! String
                }
                print(code)
            default:
                print("")
            }
        }
        if let name0 = parsedData["56"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        self.DeviceBLEC.statusDeviceYES = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        self.DeviceBLEC.statusDeviceYES = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                        self.DeviceBLEC.statusDeviceYES = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        self.DeviceBLEC.statusDeviceYES = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["85"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        self.DeviceBLEC.statusDeviceNO = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        self.DeviceBLEC.statusDeviceNO = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                        self.DeviceBLEC.statusDeviceNO = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        self.DeviceBLEC.statusDeviceNO = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["47"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        wait = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        wait = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                        wait = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        wait = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["79"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        maxLevel = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        maxLevel = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                       maxLevel = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        maxLevel = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["78"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        minLevel = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        minLevel = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                       minLevel = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        minLevel = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["80"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        fitr = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        fitr = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                       fitr = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        fitr = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["82"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        paramDevice = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        paramDevice = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                       paramDevice = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        paramDevice = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["84"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        setFull = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        setFull = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                       setFull = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        setFull = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["83"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        setNothing = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        setNothing = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                       setNothing = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        setNothing = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["11"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        settingMain = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        settingMain = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                       settingMain = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        settingMain = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["101"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        manualInput = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        manualInput = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                       manualInput = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        manualInput = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["106"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        reloadName = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        reloadName = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                       reloadName = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        reloadName = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["105"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        print(name1 as! NSString)
                        set = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        print(name1 as! NSString)
                        set = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        print(name1 as! NSString)
                        set = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        print(name1 as! NSString)
                        set = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["125"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        password = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        password = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        password = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        password = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["96"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        passwordForChange = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        passwordForChange = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        passwordForChange = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        passwordForChange = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["98"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        enterValue = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        enterValue = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        enterValue = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        enterValue = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["128"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        info = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        info = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        info = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        info = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["121"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        fullIfYes = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        fullIfYes = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        fullIfYes = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        fullIfYes = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["126"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        nothingIfYes = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        nothingIfYes = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        nothingIfYes = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        nothingIfYes = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["122"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        fullIfNo = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        fullIfNo = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        fullIfNo = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        fullIfNo = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["123"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        nothingIfNo = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        nothingIfNo = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        nothingIfNo = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        nothingIfNo = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["58"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        valueYes = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        valueYes = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        valueYes = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        valueYes = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["59"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        valueNo = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        valueNo = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        valueNo = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        valueNo = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["114"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        failReloud = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        failReloud = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        failReloud = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        failReloud = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["60"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        ifFull = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        ifFull = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        ifFull = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        ifFull = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["49"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        bufer = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        bufer = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        bufer = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        bufer = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["44"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        passNotifStringYes = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        passNotifStringYes = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        passNotifStringYes = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        passNotifStringYes = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["45"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        passNotifStringNo = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        passNotifStringNo = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        passNotifStringNo = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        passNotifStringNo = name1 as! String
                    }
                default:
                    print("")
            }
        }
        if let name0 = parsedData["131"] {
            let dict = name0 as? [String: Any]
            switch code {
                case "ru":
                    if let name1 = dict!["title_ru"]{
                        attention = name1 as! String
                    }
                case "en":
                    if let name1 = dict!["title_en"]{
                        attention = name1 as! String
                    }
                case "pr":
                    if let name1 = dict!["title_pr"]{
                        attention = name1 as! String
                    }
                case "es":
                    if let name1 = dict!["title_es"]{
                        attention = name1 as! String
                    }
                default:
                    print("")
            }
        }



    }
    
    func centralManagerDidUpdateState (_ central : CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
//            manager?.scanForPeripherals(withServices: nil)
            let peripheralsArray = Array(peripherals)
            print(peripheralsArray)
            print("Bluetooth Работает.")
        }
        else {
            print("Bluetooth Недоступен.")
            let alert = UIAlertController(title: "Включите Bluetooth", message: "Необходимо включить Bluetooth для обнаружения устройств поблизости", preferredStyle: .alert)
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
                let abc = advertisementData[key] as? [CBUUID]
                guard let uniqueID = abc?.first?.uuidString else { return }
                _ = uniqueID.components(separatedBy: ["-"])
                if(!peripherals.contains(peripheral)) {
                    peripherals.append(peripheral)
                }
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        DeviceBLEC.RSSIMain = "\(RSSI)"
    }
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral) {
            peripheral.delegate = self
            let nameD = peripheral.name!
//            print(nameD)
            let nameDOps = nameD.components(separatedBy: ["_"])
//            print(nameDOps[1])
            DeviceBLEC.nameDevice = nameDOps[1]
//         timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            timer =  Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { (timer) in
                peripheral.discoverServices(nil)
            }
        }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
                for service in peripheral.services! {
                    stringAll = ""
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        let value = "GD\r"
        let valueAll = "GA\r"
        let valueReload = "PR,PW:1:\(mainPassword)\r"
        let FullReload = "SH,PW:1:\(mainPassword)\r"
        let NothingReload = "SL,PW:1:\(mainPassword)\r"
        let sdVal = "SD,HK:1:1024\r"
        let sdValTwo = "SD,HK:1:\(full)"
        let sdValThree = "SD,LK:1:\(nothing)"
        let sdParam = "SW,WM:1:\(wmPar)"
        let sdParamYet = ",PW:1:\(mainPassword)\r"
        let passZero = "SP,PN:1:0\r"
        let passDelete = "SP,PN:1:0"
        let passInstall = "SP,PN:1:\(mainPassword)\r"
        let enterPass = "SP,PN:1:\(mainPassword)"
        let r = "\r"
        
        print("sdParam: \(sdParam)")
        print("sdValTwo: \(sdValTwo)")
        print("passInstall: \(passInstall)")
        
        let data = withUnsafeBytes(of: value) { Data($0) }
        let dataAll = withUnsafeBytes(of: valueAll) { Data($0) }
        let dataReload = withUnsafeBytes(of: valueReload) { Data($0) }
        let dataFullReload = withUnsafeBytes(of: FullReload) { Data($0) }
        let dataNothingReload = withUnsafeBytes(of: NothingReload) { Data($0) }
        let dataSdVal = withUnsafeBytes(of: sdVal) { Data($0) }
        let dataSdValTwo = Data(sdValTwo.utf8)
        let dataSdValThree = Data(sdValThree.utf8)
        let dataSdParam = Data(sdParam.utf8)
        let dataSdParamYet = withUnsafeBytes(of: sdParamYet) { Data($0) }
        let dataPassZero = withUnsafeBytes(of: passZero) { Data($0) }
        let dataPassDelete = Data(passDelete.utf8)
        let dataPassInstall = Data(passInstall.utf8)
        let dataPassEnter = Data(enterPass.utf8)
        let dataR = Data(r.utf8)

        
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
                    reload = 0
                }
            }
        }
        if reload == 2{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataFullReload, for: characteristic, type: .withResponse)
                    reload = 0
                }
            }
        }
        if reload == 3{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataNothingReload, for: characteristic, type: .withResponse)
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
                    peripheral.writeValue(dataSdValTwo, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
                    peripheral.writeValue(dataSdValThree, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)

                    reload = 0
                }
            }
        }
        if reload == 6{
            for characteristic in service.characteristics! {
                if characteristic.properties.contains(.write) {
                    print("Свойство \(characteristic.uuid): .write")
                    peripheral.writeValue(dataSdParam, for: characteristic, type: .withoutResponse)
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
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
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
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
                    peripheral.writeValue(dataSdParamYet, for: characteristic, type: .withResponse)
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
                if result.contains("UT") {
                    let indexOfPerson = result.firstIndex{$0 == "UT"}
                    temp = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("UL") {
                    let indexOfPerson = result.firstIndex{$0 == "UL"}
                    DeviceBLEC.level = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("VB") {
                    let indexOfPerson = result.firstIndex{$0 == "VB"}
                    DeviceBLEC.vatt = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("UD") {
                    let indexOfPerson = result.firstIndex{$0 == "UD"}
                    print(indexOfPerson!)
                    DeviceBLEC.id = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("LK") {
                    let indexOfPerson = result.firstIndex{$0 == "LK"}
                    print(indexOfPerson!)
                    nothing = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("HK") {
                    let indexOfPerson = result.firstIndex{$0 == "HK"}
                    print(indexOfPerson!)
                    full = "\(result[indexOfPerson! + 2])"
                }
                if result.contains("US") {
                    let indexOfPerson = result.firstIndex{$0 == "US"}
                    print(indexOfPerson!)
                    cnt = "\(result[indexOfPerson! + 2])"
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
                    DeviceBLEC.VV = "\(result[indexOfPerson! + 2])"
                    DeviceBLEC.VV.insert(".", at: DeviceBLEC.VV.index(DeviceBLEC.VV.startIndex, offsetBy: 1))
                    DeviceBLEC.VV.insert(".", at: DeviceBLEC.VV.index(DeviceBLEC.VV.startIndex, offsetBy: 3))
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
        print("didWriteValueFor \(characteristic.uuid.uuidString)")
        print(DeviceBLEC.sendData)
        print("Succeeded!")
        print(characteristic.properties)
        print(characteristic.value ?? "не найдено")
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
        viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        searchBar.delegate = self
        manager = CBCentralManager ( delegate : self , queue : nil , options : nil )
        viewShow()
        updateLangues(code: code)
    }
    
    var tr = 0
    var container2 = UIView(frame: CGRect(x: 20, y: 50, width: Int(screenWidth-40), height: 70))
    @objc func refresh(sender:AnyObject) {
        
        scanBLEDevices()
        activityIndicator.startAnimating()
        self.view.addSubview(viewAlpha)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
        attributedTitle = NSAttributedString(string: wait, attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        popUpVC.delegate = self
        if tr != 0{
            viewShow()
            tr += 1
        }
        updateLangues(code: code)
        scanBLEDevices()
        rightCount = 0
        searchBarCancelButtonClicked(searchBar)
    }

    func scanBLEDevices() {
        let uuid = NSUUID().uuidString.lowercased()
        print("uuid: \(uuid)")
        peripherals.removeAll()
        manager?.scanForPeripherals(withServices: nil)
        self.view.isUserInteractionEnabled = false
            //stop scanning after 5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.stopScanForBLEDevices()
                print("Stop")
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
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()

    private func viewShow() {
        view.subviews.forEach({ $0.removeFromSuperview() })
        view.backgroundColor = UIColor(rgb: 0x1F2222)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let (headerView, backView) = headerSet(title: "\(openDevices)", showBack: true)
            self.view.addSubview(headerView)
            self.view.addSubview(backView!)
            self.view.addSubview(self.viewAlpha)
            backView!.addTapGesture{
                self.navigationController?.popViewController(animated: true)
                self.view.subviews.forEach({ $0.removeFromSuperview() })
                while let subview = self.scrollView.subviews.last {
                    subview.removeFromSuperview()
                }
            }
        }
        view.addSubview(bgImage)
        viewAlpha.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            self.viewAlpha.removeFromSuperview()
            self.view.backgroundColor = UIColor(rgb: 0x1F2222).withAlphaComponent(1)
            self.activityIndicator.stopAnimating()
            self.mainPartShow()
            
        }
        
    }

    var searching = false
    var searchedCountry = [String]()
    var aaa = [String]()

    private func mainPartShow() {
        
        aaa.removeAll()
        let hamburger = UIImageView(image: UIImage(named: "Hamburger.png")!)
        let hamburgerPlace = UIView()
            var yHamb = screenHeight/22
            if screenHeight >= 750{
                yHamb = screenHeight/18
            }
            hamburgerPlace.frame = CGRect(x: screenWidth-50, y: yHamb, width: 35, height: 35)
            hamburger.frame = CGRect(x: screenWidth-45, y: yHamb, width: 25, height: 25)

            view.addSubview(hamburger)
            view.addSubview(hamburgerPlace)
        

            hamburgerPlace.addTapGesture {
            self.searchBar.endEditing(true)
            self.addChild(self.popUpVC) // 2
            self.popUpVC.view.frame = self.view.frame  // 3
            self.view.addSubview(self.popUpVC.view) // 4
            self.popUpVC.didMove(toParent: self) // 5
            print("Успешно")
        }
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
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

        let cellHeight = 60
        var y = headerHeight - 70
        var yS = headerHeight - 70
        

        for (i, peripheral) in data.enumerated() {
//             while let subview = container2.subviews.first {
//                 subview.removeFromSuperview()
//             }
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
            
            let btn = UIView(frame: CGRect(x: Int(screenWidth-140-40), y: 8, width: 140, height: 44))
            btn.backgroundColor = UIColor(rgb: 0xCF2121)
            btn.layer.cornerRadius = 22
            
            let connect = UILabel(frame: CGRect(x: Int(btn.frame.origin.x), y: Int(btn.frame.origin.y), width: Int(btn.frame.width), height: Int(btn.frame.height)))
            connect.text = "Connect"
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
                    container2.addSubview(connect)
                    container2.addSubview(separator)
                    scrollViewS.addSubview(container2)
                    
                    yS = yS + CGFloat(cellHeight)
                    
                }


            } else {
                
                container2.addSubview(btn)
                container2.addSubview(connect)
                container2.addSubview(title)
                container2.addSubview(separator)
                scrollView.addSubview(container2)
                

            }
            connect.addTapGesture {
                temp = nil
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
                        navController.pushViewController(self.DeviceBLEC, animated: true)
                    }
                    print("Connected to " +  peripheral.name!)
                    self.viewAlpha.removeFromSuperview()
                    self.view.subviews.forEach({ $0.removeFromSuperview() })
                    while let subview = self.scrollView.subviews.last {
                        subview.removeFromSuperview()
                    }
                })
            }
            
            y = y + CGFloat(cellHeight)
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

