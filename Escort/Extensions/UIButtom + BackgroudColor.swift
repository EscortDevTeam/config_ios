//
//  UIButtom + BackgroudColor.swift
//  Escort
//
//  Created by Володя Зверев on 08.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//
import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 10,
        bottom: 0,
        right: 10
    )
    init(placeholder string: String) {
        super.init(frame: .zero)
        attributedPlaceholder = NSAttributedString(string: string,attributes: [NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xE80000).withAlphaComponent(0.5)])
        layer.cornerRadius = 5
        textColor = .black
        backgroundColor = .white
        layer.borderColor = UIColor(rgb: 0xE7E7E7).cgColor
        layer.borderWidth = 1.0
        tintColor = .red
        keyboardAppearance = .light
        setupTheme()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    func setupTheme() {
        if #available(iOS 13.0, *) {
            self.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            self.layer.theme.borderColor = themed{ $0.navigationTintColor.cgColor }
            self.theme.textColor = themed{ $0.navigationTintColor }

        } else {
            self.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            self.layer.borderColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F).cgColor
            self.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
        self.keyboardAppearance = isNight ? .dark : .light

    }

}

var viewAlphaAlways: UIView = {
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    viewAlpha.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    let view = UIActivityIndicatorView()
    view.frame = .zero
    view.tintColor = .white
    view.frame.size = CGSize(width: 50, height: 50)
    view.layer.shadowColor = UIColor.white.cgColor
    view.layer.shadowRadius = 5.0
    view.transform = CGAffineTransform(scaleX: 2, y: 2)
    if #available(iOS 13.0, *) {
        view.style = .medium
    } else {
        view.style = .white
    }
    view.layer.shadowOpacity = 0.7
    view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    view.center = viewAlpha.center
    view.startAnimating()
    viewAlpha.addSubview(view)
    cancelLabel.center = viewAlpha.center
    viewAlpha.addSubview(cancelLabel)
    cancelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    cancelLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 45).isActive = true

//    cancelLabel.addTapGesture {
//        print("Stop")
//        UIApplication.shared.keyWindow?.rootViewController?.navigationController?.popViewController(animated: true)
//    }
    viewAlpha.isHidden = true
    return viewAlpha
}()
let cancelLabel: UILabel = {
    let cancelLabel = UILabel()
    cancelLabel.text = "Отменить"
    cancelLabel.translatesAutoresizingMaskIntoConstraints = false
    cancelLabel.textColor = .red
    cancelLabel.clipsToBounds = false
    cancelLabel.isHidden = false
    cancelLabel.font = UIFont(name: "FuturaPT-Medium", size: 20)
    cancelLabel.layer.shadowColor = UIColor.white.cgColor
    cancelLabel.layer.shadowRadius = 5.0
    cancelLabel.layer.shadowOpacity = 0.7
    cancelLabel.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    return cancelLabel
}()
