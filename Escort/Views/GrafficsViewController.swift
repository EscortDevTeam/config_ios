//
//  DocumentBlackBoxController.swift
//  Escort
//
//  Created by Володя Зверев on 13.07.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import Charts

class GrafficsViewController: UIViewController {
    var data = LineChartData()
    var selectedIndex:IndexPath?

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var set1: LineChartDataSet = {
        let set1 = LineChartDataSet(values: yValues2, label: cheakDate[0])
        set1.mode = .linear
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.drawVerticalHighlightIndicatorEnabled = false
        set1.setColor(UIColor(rgb: 0x00A778), alpha: 1.0)
        return set1
    }()
    
    lazy var lineChartView: LineChartView = {
        let chart = LineChartView()
        chart.backgroundColor = UIColor(rgb: 0x747474)
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.rightAxis.enabled = false
        let xAxis = chart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .white
        xAxis.labelPosition = .bottom
        xAxis.labelCount = 3
        let xValuesFormatter = DateFormatter()
            xValuesFormatter.dateFormat = "dd-MM-yy HH:mm"
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: 1, dateFormatter: xValuesFormatter, referenceTimeInterval2: timeBlackBox[0])
        xAxis.valueFormatter = xValuesNumberFormatter
        
        
        let leftAxis = chart.leftAxis
        leftAxis.labelTextColor = .white
        let lvlBlackBoxInt = lvlBlackBox[0].map{Int($0)!}
        leftAxis.axisMaximum = Double(lvlBlackBoxInt.max()! + 10)
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        chart.animate(xAxisDuration: 1)
        return chart
    }()
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    
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
    
    lazy var saveView: UIImageView = {
        let back = UIImageView(image: UIImage(named: "save")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.tintColor = .white
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    lazy var saveLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Save".localized(code)
        text.textColor = UIColor(rgb: 0xFFFFFF)
        text.textAlignment = .center
        text.font = UIFont(name:"FuturaPT-Medium", size: 20)
        return text
    }()
    
    lazy var shareView: UIImageView = {
        let back = UIImageView(image: UIImage(named: "share")!)
        back.image = back.image!.withRenderingMode(.alwaysTemplate)
        back.tintColor = .white
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    lazy var shareLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.text = "Share".localized(code)
        text.textColor = UIColor(rgb: 0xFFFFFF)
        text.textAlignment = .center
        text.font = UIFont(name:"FuturaPT-Medium", size: 20)
        return text
    }()
    
    lazy var alphaView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0), width: screenWidth, height: screenHeight)
        v.alpha = 0.5
        v.backgroundColor = UIColor(rgb: 0x181818)
        return v
    }()
    var myInt = 0

    lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0) )
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yValues2.removeAll()
        var axisMaximum = 0
        var countX = 0
        for j in 0...lvlBlackBox.count - 1 {
            for i in 0...lvlBlackBox[j].count - 1 {
                yValues2.append(ChartDataEntry(x: Double(timeBlackBox[j][i]) ?? 0, y: Double(lvlBlackBox[j][i]) ?? 0))
//                print(countX)
                if Int(lvlBlackBox[j][i]) ?? 0 > axisMaximum {
                    axisMaximum = Int(lvlBlackBox[j][i]) ?? 0
                }
                countX += 1
            }
        }
        DispatchQueue.main.async { [self] in
            self.set1 = LineChartDataSet(values: self.yValues2, label: "----")
            self.set1.mode = .linear
            self.set1.drawCirclesEnabled = false
            self.set1.lineWidth = 3
//            self.set1.drawHorizontalHighlightIndicatorEnabled = false
//            self.set1.drawVerticalHighlightIndicatorEnabled = false
            self.set1.setColor(UIColor(rgb: 0x00A778), alpha: 1.0)
            self.lineChartView.leftAxis.axisMaximum = Double(axisMaximum + 10)
            self.lineChartView.animate(xAxisDuration: 1)
        }
        let someDate = Date()

        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = someDate.timeIntervalSince1970

        // convert to Integer
        myInt = Int(timeInterval)
        view.addSubview(themeBackView3)
        view.addSubview(alphaView)
        
        MainLabel.text = "Graph сhart".localized(code)
        
        view.addSubview(MainLabel)
        view.addSubview(backView)
        backView.addTapGesture{
            self.generator.impactOccurred()
            self.navigationController?.popViewController(animated: true)
        }
        setupTheme()
        setData()
        cosntrains()
        saveView.addTapGesture { [self] in
//            DispatchQueue.main.async { [self] in
//                set1 = LineChartDataSet(values: yValues2, label: "Уровень 2")
//                set1.mode = .linear
//                set1.drawCirclesEnabled = false
//                set1.lineWidth = 3
//                set1.drawHorizontalHighlightIndicatorEnabled = false
//                set1.drawVerticalHighlightIndicatorEnabled = false
//                set1.setColor(UIColor(rgb: 0x00A778), alpha: 1.0)
//                setData()
//                lineChartView.animate(xAxisDuration: 1)
//                lineChartView.data? = data
//                lineChartView.data!.notifyDataChanged()
//            }
//            print("1")
            self.saveTap()
        }
        saveLabel.addTapGesture {
            self.saveTap()
        }
        shareView.addTapGesture { [self] in
            self.shareTap()
        }
        shareLabel.addTapGesture {
            self.shareTap()
        }

    }
    
    func saveTap() {
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
        
        do {
            try contents.write(to: fileURL, atomically: false, encoding: .utf8)
            filesToShare.append(fileURL)
            self.showToast(message: "Recording was successful".localized(code) + " \(file)", seconds: 1.0)
        }
        catch {
            self.showToast(message: "Error".localized(code), seconds: 1.0)
        }
    }
    func shareTap() {
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
            
            let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        catch {
            print("Error: \(error)")
            self.showToast(message: "Error".localized(code), seconds: 1.0)

        }
    }
    func cosntrains() {
        view.addSubview(saveLabel)
        view.addSubview(shareLabel)
        view.addSubview(saveView)
        view.addSubview(shareView)
        view.addSubview(lineChartView)
        
        lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  20).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        lineChartView.topAnchor.constraint(equalTo: themeBackView3.bottomAnchor, constant: 10).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: saveView.topAnchor, constant: -20).isActive = true

//        saveLabel.leadingAnchor.constraint(equalTo: saveView.leadingAnchor).isActive = true
        saveLabel.centerXAnchor.constraint(equalTo: saveView.centerXAnchor).isActive = true
        saveLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        saveLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        saveView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65).isActive = true
        saveView.bottomAnchor.constraint(equalTo: saveLabel.topAnchor, constant: -3).isActive = true
        saveView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        saveView.heightAnchor.constraint(equalToConstant: 35).isActive = true

        
        shareView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65).isActive = true
        shareView.bottomAnchor.constraint(equalTo: saveLabel.topAnchor, constant: -3).isActive = true
        shareView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        shareView.heightAnchor.constraint(equalToConstant: 35).isActive = true

//        shareLabel.trailingAnchor.constraint(equalTo: shareView.trailingAnchor).isActive = true
        shareLabel.centerXAnchor.constraint(equalTo: shareView.centerXAnchor).isActive = true
        shareLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        shareLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        shareLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    var yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 1, y: 110),
    ]
    var yValues2: [ChartDataEntry] = [
        
    ]
    
    func setData() {
        DispatchQueue.main.async { [self] in
            self.set1 = LineChartDataSet(values: self.yValues2, label: "Level")
            self.set1.mode = .linear
            self.set1.drawCirclesEnabled = false
            self.set1.lineWidth = 3
            self.set1.drawHorizontalHighlightIndicatorEnabled = false
            self.set1.drawVerticalHighlightIndicatorEnabled = false
            self.set1.setColor(UIColor(rgb: 0x00A778), alpha: 1.0)
            data = LineChartData(dataSet: set1)
            data.setDrawValues(false)
            lineChartView.data = data
            lineChartView.animate(xAxisDuration: 1)
        }
        
    }
    
    func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}

