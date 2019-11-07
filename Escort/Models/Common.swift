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
var maxLevel = "Макс. уровень"
var minLevel = "Мин. уровень"
var fitr = "Фильтрация"
var paramDevice = "Записать параметры в устройство"
var setFull = "Полный"
var setNothing = "Пустой"
var settingMain = "Настройки TD BLE"
var settingDop = "Доп. возможности"
var manualInput = "Ручной ввод конфигурации"
var reloadName = "Перезагрузка TD-BLE"
var set = "Установить"
var password = "Пароль"
var passwordForChange = "Пароль на изменение настроек"
var enterValue = "Введите значение..."
var reference = "Справка"
var info = "Здесь скоро появится справочная информация, мы над этим работаем."
var typeBLE: String = "Тип bluetooth датчика"
var typeUSB: String = "Тип проводного датчика"
var boolBLE: Bool = true
var code = "CodeLangu".localized
var langu = "Language".localized(code)
var languMain = "Language".localized(code)
var openDevices = "Доступные устройства"
var wait = "Обновление..."
var fullIfYes = "Значение Полный успешно изменено"
var nothingIfYes = "Значение Пустой успешно изменено"
var valueYes = "Значение успешно откалибровано"
var fullIfNo = "Значение Полный изменить не удалось"
var nothingIfNo = "Значение Пустой изменить не удалось"
var valueNo = "Не удалось откалибровать значение"
var mainPassword = ""
var errorWRN = false
var failReloud = "Не удалось перезагрузить"
var ifFull = "Полный должен быть больше Пустой"
var bufer = "Скопировано в буфер"
var wmPar = "1"
var wmMax = "0"
var wmMaxInt = 0
var countNot = 0
var passNotif = 0
var passwordSuccess = false
var passNotifStringNo = "На датчике пароль не установлен"
var passNotifStringYes = "На датчике установлен пароль"
var attention = "Внимание"
var termocompetition = "Отключить термокомпенсацию"
var temp : String?
var enterP = "Ввести"
var deleteP = "Удалить"
var passwordHave = false
var warning = false
var RSSIMainArray: [String] = []
let screenWidth = UIScreen.main.bounds.width, screenHeight = UIScreen.main.bounds.height
let headerHeight = screenWidth * screenHeight / 3500
var peripheralName: [String] = []
func headerSet(title: String) -> UIView {
    return headerSet(title: title, showBack: false).0
}

func headerSet(title: String, showBack: Bool) -> (UIView, UIView?) {

    let v = UIView()
    let bg = UIImageView(image: UIImage(named: "header-bg.png")!)
    bg.frame = CGRect(x: 0, y: 0, width: screenWidth, height: headerHeight)
    v.addSubview(bg)

    let dy: Int = screenWidth == 320 ? 0 : 10

    let backView = UIView(frame: CGRect(x: 0, y: dy + (hasNotch ? 45 : 25), width: 80, height: 40))
    let back = UIImageView(image: UIImage(named: "back.png")!)
    back.frame = CGRect(x: 8, y: 0, width: 8, height: 19)
    backView.addSubview(back)
    
    let text = UILabel(frame: CGRect(x: 24, y: 10 + dy, width: Int(screenWidth-60), height: 48 + (hasNotch ? 40 : 0)))
    text.text = title
    text.textColor = UIColor(rgb: 0x272727)
    text.font = UIFont(name:"BankGothicBT-Medium", size: 19.0)
    v.addSubview(text)

    return (v, showBack ? backView : nil)
}

var hasNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    return false
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
