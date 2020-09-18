//
//  Logging.swift
//  Escort
//
//  Created by Володя Зверев on 25.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import WebKit

var fileURLBlackBox: URL?

class LoggingController: UIViewController, UINavigationControllerDelegate {
    
    let webView = WKWebView()
    let generator = UIImpactFeedbackGenerator(style: .light)
    let picker = UIPickerView()
    let labelDays = UILabel()
    let labelHours = UILabel()
    let stack = UIStackView()
    var days = 0
    var hours = 0
    var timer = Timer()
    
    let viewAlpha = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    var input1 = UITextField()
    var input2 = UITextField()
    
    let firstTextField = UITextField()
    let secondTextField = UITextField()
    let validatePassword = UILabel()
    var saveAction = UIAlertAction()
    
    let firstTextFieldSecond = UITextField()
    let secondTextFieldSecond = UITextField()
    let validatePasswordSecond = UILabel()
    var saveActionSecond = UIAlertAction()
    var searchTextViewPortraitWidthConstraint: NSLayoutConstraint?


    override func viewDidLoad() {
        super.viewDidLoad()
        viewShow()
        setupTheme()
        registgerPickerView()
        createLabelHoursOrDays(label: labelDays, name: "days".localized(code), centerX: 1)
        createLabelHoursOrDays(label: labelHours, name: "hours".localized(code), centerX: 2)
        showPassword()
        view.addSubview(stack)
        
    }
    func cancelTap() {
        deleteLogger()
    }

    fileprivate func doneDowload() {
        cancelButton.setTitle("Save the received data".localized(code), for: .normal)
        cancelButton.titleLabel?.numberOfLines = 0
        cancelButton.titleLabel?.font = UIFont(name:"FuturaPT-Medium", size: 16)!
        cancelButton.removeTarget(nil, action: nil, for: .allEvents)
        cancelButton.addTarget(self, action: #selector(self.saveData(_ :)), for: UIControl.Event.touchUpInside)
        
        viewLogger.addSubview(cancelLabel)
        
        cancelLabel.centerXAnchor.constraint(equalTo: viewLogger.centerXAnchor).isActive = true
        cancelLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 10).isActive = true
        cancelLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cancelLabel.widthAnchor.constraint(equalToConstant: screenWidth - 70).isActive = true
        
        interestLabel.text = "Loading is complete ".localized(code) + "\(inverst)%\n" + "Processing of the downloaded data is required".localized(code)
        interestLabel.font = UIFont(name:"FuturaPT-Light", size: 20)
        interestLabel.numberOfLines = 0
        interestLabel.widthAnchor.constraint(equalToConstant: screenWidth - 70).isActive = true
        
        indicatorView.alpha = 0.0

        timer.invalidate()
    }
    
    func timerStart() {
        timer =  Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            self.interestLabel.text = "\(inverst)%"
            self.blocksLabel.text = "\(countPacket) / \(countPackets)"
            if inverst == "100" {
                self.doneDowload()
            }
            if countPackets == "-1" {
                self.deleteLogger()
                let alert = UIAlertController(title: "Warning".localized(code), message: "Black box is emptied".localized(code), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                                switch action.style{
                                                case .default:
                                                    print("OK")
                                                case .cancel:
                                                    print("cancel")
                                                case .destructive:
                                                    print("destructive")
                                                @unknown default:
                                                    fatalError()
                                                }}))
                self.present(alert, animated: true)
                timer.invalidate()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("interactivePopGestureRecognizer")
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        days = Int.random(in: 0...30)
        hours = Int.random(in: 0...24)
        picker.selectRow(days, inComponent: 0, animated: true)
        picker.selectRow(hours, inComponent: 1, animated: true)
        pickerView(picker, didSelectRow: days, inComponent: 0)
        pickerView(picker, didSelectRow: hours, inComponent: 1)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }

    @objc private func onButtonClick(_ sender: UIButton) {
        cheakStartLogging = true
        timeBlackBox.removeAll()
        lvlBlackBox.removeAll()
        reload = 11
        inverst = "0"
        print("reload: \(reload) and blocks \(blocks)")
        createLogger()
    }
    
    @objc private func getAllButtonClick(_ sender: UIButton) {
        cheakStartLogging = true
        timeBlackBox.removeAll()
        lvlBlackBox.removeAll()
        blocks = 720
        reload = 11
        inverst = "0"
        print("reload all: \(reload) and blocks \(blocks)")
        createLogger()
    }
    
    @objc private func DeleteButtonClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete?".localized(code), message: "Are you sure you want to delete all records?".localized(code), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No".localized(code), style: .default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Yes".localized(code),
                                      style: .destructive,
                                      handler: {(_: UIAlertAction!) in
                                        timeBlackBox.removeAll()
                                        lvlBlackBox.removeAll()
                                        reload = 13
                                        inverst = "0"
                                        self.deleteCheck()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @objc func stopButtonClick(_ sender: UIButton) {
        pickerView(picker, didSelectRow: days, inComponent: 0)
        pickerView(picker, didSelectRow: hours, inComponent: 1)
        reload = 12
        doneDowload()
        print("delete: \(reload)")
    }
    
    @objc private func saveData(_ sender: UIButton) {
        if timeBlackBox.count != 0 {
            navigationController?.pushViewController(GrafficsViewController(), animated: true)
            programSetCell()
            print("save all: \(reload)")
            let file = "Black box".localized(code) + " №\(nameDevice) \(cheakDate[0]).csv"
            var contents = ""
            for i in 0...timeBlackBox.count - 1 {
                for j in (0...timeBlackBox[i].count - 1).reversed() {
                    contents = contents + "\(timeBlackBox[i][j]), \(lvlBlackBox[i][j])\n"
                }
            }
            let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let fileURL = dir.appendingPathComponent(file)
            fileURLBlackBox = fileURL
            var filesToShare = [Any]()
            //        webView.frame =  CGRect(x: 0, y: headerHeight-10, width: screenWidth, height: screenHeight-(headerHeight-10))
            //        view.addSubview(webView)
            do {
                //                            try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: nil)
                try contents.write(to: fileURL, atomically: false, encoding: .utf8)
                filesToShare.append(fileURL)
                
                //            let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                //            self.present(activityViewController, animated: true, completion: nil)
            }
            catch {
                print("Error: \(error)")
                self.showToast(message: "Error".localized(code), seconds: 1.0)
                
            }
        } else {
            showToast(message: "Failure to load the data from black box".localized(code), seconds: 1.0)
        }
    }
    fileprivate func programSetCell() {
        cheakDate.removeAll()
        cheakDateAgain.removeAll()
        indexDate.removeAll()
        for i in 0...timeBlackBox.count - 1 {
            let index = timeBlackBox[i].first!.dropLast(9)
            cheakDateAgain.append(String(index))
            if !cheakDate.contains(cheakDateAgain[i]) {
                cheakDate.append(cheakDateAgain[i])
                indexDate.append(i)
            }
        }
        print(cheakDate)
    }
    func deleteCheck() {
        self.activityIndicator.startAnimating()
        self.viewAlpha.addSubview(self.activityIndicator)
        self.view.addSubview(self.viewAlpha)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.view.isUserInteractionEnabled = true
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.viewAlpha.removeFromSuperview()
            self.input1.removeFromSuperview()
            self.input2.removeFromSuperview()
            if deleteChek == true {
                let alert = UIAlertController(title: "Success".localized(code), message: "Data has been deleted".localized(code), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("OK")
                    case .cancel:
                        print("cancel")
                    case .destructive:
                        print("destructive")
                    @unknown default:
                        fatalError()
                    }}))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Warning".localized(code), message: "Failure to delete the data".localized(code), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("OK")
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
    }
    
    lazy var viewLogger: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x747474)
        view.layer.cornerRadius = 10

        return view
    }()
    lazy var viewAlphaLogger: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.backgroundColor = UIColor(rgb: 0x181818).withAlphaComponent(0.8)
        return view
    }()
    
    lazy var indicatorView: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: UIColor(rgb: 0x00D196))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var blocksLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0 / 0"
        label.textAlignment = .right
        label.font = UIFont(name:"FuturaPT-Light", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var interestLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0%"
        label.textAlignment = .center
        label.font = UIFont(name:"FuturaPT-Medium", size: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cancelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "Cancel".localized(code)
        label.textAlignment = .center
        label.font = UIFont(name:"FuturaPT-Medium", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var DownloadDataForLastLabel: UILabel = {
        let label = UILabel()
        label.textColor = isNight ? UIColor.white : UIColor.black
        label.text = "Download data for the last".localized(code)
        label.textAlignment = .center
        label.font = UIFont(name:"FuturaPT-Medium", size: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var getButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: .zero, height: 50)))
        button.setTitle("Show".localized(code), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(rgb: 0xE80000)
        button.titleLabel?.font = UIFont(name:"FuturaPT-Medium", size: 20)!
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onButtonClick(_:)), for: UIControl.Event.touchUpInside)
       return button
    }()
    
    lazy var getAllButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: .zero, height: 50)))
        button.setTitle("Show all".localized(code), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(rgb: 0xE80000)
        button.titleLabel?.font = UIFont(name:"FuturaPT-Medium", size: 20)!
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(getAllButtonClick(_:)), for: UIControl.Event.touchUpInside)

       return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stop".localized(code), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(rgb: 0x00A778)
        button.titleLabel?.font = UIFont(name:"FuturaPT-Medium", size: 20)!
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(stopButtonClick(_:)), for: UIControl.Event.touchUpInside)
       return button
    }()
    
    lazy var deleteAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete all".localized(code), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor(rgb: 0xE80000)
        button.titleLabel?.font = UIFont(name:"FuturaPT-Medium", size: 20)!
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(DeleteButtonClick(_:)), for: UIControl.Event.touchUpInside)
       return button
    }()
    
    lazy var backView: UIImageView = {
        let backView = UIImageView()
        backView.frame = CGRect(x: 0, y: dIy + dy + (hasNotch ? dIPrusy+30 : 40) - (iphone5s ? 10 : 0), width: 50, height: 40)
        let back = UIImageView(image: UIImage(named: "back")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.frame = CGRect(x: 8, y: 0 , width: 8, height: 19)
        back.center.y = backView.bounds.height/2
        backView.addSubview(back)
        return backView
    }()
   
    lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-24), height: 40))
        text.text = "Select connection type".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17.0 : 19.0))
        return text
    }()

    lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0) )
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activity.style = .medium
        } else {
            activity.style = .gray
        }
        activity.center = view.center
        activity.hidesWhenStopped = true
        activity.startAnimating()
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)

        return activity
    }()
}

extension LoggingController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 31
        } else {
            return 24
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row)"
        } else {
            return "\(row)"
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as! UILabel?
        if label == nil {
            label = UILabel()
            label?.textColor = isNight ? UIColor.white : UIColor.black
        }
        switch component {
        case 0:
            label?.text = "\(row)"
            label?.font = UIFont(name:"FuturaPT-Light", size: 45)
            label?.textAlignment = .center
            return label!
        case 1:
            label?.text = "\(row)"
            label?.font = UIFont(name:"FuturaPT-Light", size: 45)
            label?.textAlignment = .center
            return label!
        default:
            return label!
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            switch row {
            case 0,5...20,25...30:
                labelDays.text = "days".localized(code)
            case 1,21:
                labelDays.text = "day_1".localized(code)
            case 2...4,22...24:
                labelDays.text = "day".localized(code)
            default:
                print("default")
            }
            days = row
            blocks = days * 24 + hours
            if blocks >= 720 {
                blocks = 720
            }
            if hours == 0 && days == 0 {
                picker.selectRow(1, inComponent: 1, animated: true)
                hours = 1
                blocks = days * 24 + hours
            } else if days == 30 && hours != 0 {
                picker.selectRow(0, inComponent: 1, animated: true)
                hours = 0
                blocks = days * 24 + hours
            }
        } else {
            switch row {
            case 5...20:
                labelHours.text = "hours".localized(code)
            case 1,21:
                labelHours.text = "hour_1".localized(code)
            case 2...5,22...24:
                labelHours.text = "hour".localized(code)
            default:
                print("default")
            }
            hours = row
            blocks = days * 24 + hours
            if blocks >= 720 {
                blocks = 720
            }
            if hours == 0 && days == 0 {
                picker.selectRow(1, inComponent: 1, animated: true)
                hours = 1
                blocks = days * 24 + hours
            } else if days == 30 && hours != 0 {
                picker.selectRow(0, inComponent: 1, animated: true)
                hours = 0
                blocks = days * 24 + hours
            }
        }
    }
}
extension LoggingController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            print(destinationURL)
//            self.pdfURL = destinationURL
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
