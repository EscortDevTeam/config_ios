//
//  Common.swift
//  Escort
//
//  Created by Pavel Vladimiroff on 02.07.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//

import UIKit

var item = 0
var itemColor = 0
var zero = 0
var zeroTwo = 0
var reload = 0
var reloadBack = 0
var IsBLE: Bool = false
var DeviceTypeIndex = 0
var DeviceIndex = 0
var statusDeviceY = "Не стабилен"
var typeBLE: String = "Тип bluetooth датчика"
var typeUSB: String = "Тип проводного датчика"
var boolBLE: Bool = true
var code = "CodeLangu".localized
var langu = "Language".localized(code)
var languMain = "Language".localized(code)
var mainPassword = ""
var errorWRN = false
var wmPar = "1"
var wmMax = "0"
var wmMaxInt = 0
var countNot = 0
var passNotif = 0
var passwordSuccess = false
var temp : String?
var passwordHave = false
var warning = false
var RSSIMainArray: [String] = []
var RSSIMainArrayRSSI: [String] = []
let screenWidth = UIScreen.main.bounds.width, screenHeight = UIScreen.main.bounds.height
let headerHeight = screenWidth * screenHeight / 3500
var peripheralName: [String] = []
var rightCount = 0
var nameDevice = ""
var nameDeviceT = ""
var RSSIMain = "0"
var QRCODE = ""
var level = ""
var id = ""
var VV: String = ""
var vatt: String = ""
var checkQR = false
var checkPopQR = false
var stepTar = 0
var startVTar = 0
var checkMenu = false
var itemsT: [String] = []
var levelnumberT: [String] = []
var itemsC: [String] = []
var levelnumberC: [String] = []
var tarNew = true
var sliv = true
var sandboxFileURLPath: URL? = nil
var chekOpen = true
var adveTemp: [String] = []
var adveLvl: [String] = []
var adveVat: [String] = []
var adveFW: [String] = []
var isNight = false
var hidednCell = false
func headerSet(title: String) -> UIView {
    return headerSet(title: title, showBack: false).0
}


func headerSet(title: String, showBack: Bool) -> (UIView, UIView?) {

    let v = UIView()
    let bg = UIImageView(image: UIImage(named: "header-bg.png")!)
    bg.frame = CGRect(x: 0, y: 0, width: screenWidth, height: headerHeight)
    v.addSubview(bg)
    print(screenWidth)
    print(screenHeight)

    let dy: Int = screenWidth == 320 ? 0 : 10
    let dIy: Int = screenWidth == 375 ? -15 : 0
    let dIPrusy: Int = screenWidth == 414 ? -12 : 0

    let backView = UIView(frame: CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+40 : 50), width: 80, height: 40))
    let back = UIImageView(image: UIImage(named: "back.png")!)
    back.frame = CGRect(x: 8, y: 0, width: 8, height: 19)
    backView.addSubview(back)
    
    let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy, width: Int(screenWidth-60), height: 40))
    text.text = title
    text.textColor = UIColor(rgb: 0x272727)
    text.font = UIFont(name:"BankGothicBT-Medium", size: 19.0)
    v.addSubview(text)

    return (v, showBack ? backView : nil)
}

func headerSetMenu(title: String, showBack: Bool) -> (UIView, UIView?) {

    let v = UIView()
    let bg = UIImageView(image: UIImage(named: "header-bg.png")!)
    bg.frame = CGRect(x: 0, y: 0, width: screenWidth, height: headerHeight)
    v.addSubview(bg)
    print(screenWidth)
    let dy: Int = screenWidth == 320 ? 0 : 10
    let dIy: Int = screenWidth == 375 ? -15 : 0
    let dIPrusy: Int = screenWidth == 414 ? -12 : 0

    let backView = UIView(frame: CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+40 : 50), width: 80, height: 40))
    let back = UIImageView(image: UIImage(named: "back.png")!)
    back.frame = CGRect(x: 8, y: 0, width: 8, height: 19)
    backView.addSubview(back)
    
    let text = UILabel(frame: CGRect(x: 0, y: dIy + (hasNotch ? dIPrusy+20 : 20) + dy, width: Int(screenWidth), height: 40))
    text.text = title
    text.textAlignment = .center
    text.textColor = UIColor(rgb: 0x272727)
    text.font = UIFont(name:"BankGothicBT-Medium", size: 30.0)
    v.addSubview(text)

    return (v, showBack ? backView : nil)
}

var hasNotch: Bool {
    if screenHeight > 800 {
        return false
    }
    return true
}

//Цвет UISearchBar
extension UISearchBar {

    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as?
UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }

        set (newValue) {
            if let textField = self.value(forKey: "searchField") as?
UITextField  {
                textField.textColor = newValue
            }
        }
    }
}


var parsedData:[String : AnyObject] = [:]

extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            self.swapAt(i, j)
        }
    }
}
extension String {

    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }

    func isValid(regex: RegularExpressions) -> Bool { return isValid(regex: regex.rawValue) }
    func isValid(regex: String) -> Bool { return range(of: regex, options: .regularExpression) != nil }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }

    func makeAColl() {
        guard   isValid(regex: .phone),
                let url = URL(string: "tel://\(self.onlyDigits())"),
                UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension String {
func localized(_ lang:String) ->String {

    let path = Bundle.main.path(forResource: lang, ofType: "lproj")
    let bundle = Bundle(path: path!)

    return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
}}
