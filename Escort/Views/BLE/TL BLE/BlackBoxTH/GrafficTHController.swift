//
//  GrafficTHController.swift
//  Escort
//
//  Created by Володя Зверев on 15.02.2021.
//  Copyright © 2021 pavit.design. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class GrafficTHController: UIViewController {
    var data = LineChartData()
    var selectedIndex:IndexPath?
    var parametrValues:  Results<ModelBox>?
    var viewModel: ViewModelDevice = ViewModelDevice()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var set1: LineChartDataSet = {
        let set1 = LineChartDataSet(entries: yValues2, label: cheakDate[0])
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
        chart.layer.cornerRadius = 10
        chart.clipsToBounds = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.rightAxis.enabled = false
        let xAxis = chart.xAxis
        xAxis.labelFont = UIFont(name: "FuturaPT-Light", size: 11)!
        xAxis.labelTextColor = .white
        xAxis.labelPosition = .bothSided
        xAxis.labelCount = 3
        xAxis.axisMinimum = 0
        xAxis.granularity = 0

        let xValuesFormatter = DateFormatter()
        xValuesFormatter.dateFormat = "dd.MM.yy HH:mm"
        let timeStart = ((parametrValues?.last?.time)! as NSString).intValue
        let xValuesNumberFormatter = ChartXAxisFormatter(referenceTimeInterval: TimeInterval(timeStart), dateFormatter: xValuesFormatter)
        xValuesNumberFormatter.dateFormatter = xValuesFormatter
        xAxis.valueFormatter = xValuesNumberFormatter
        
        let leftAxis = chart.leftAxis
        leftAxis.labelTextColor = .white
        var lvlBlackBoxInt: [Double] = []
        for i in 0...parametrValues!.count - 1 {
            let intHum = Double((parametrValues?[i].temp)!)
            lvlBlackBoxInt.append(intHum!)
        }
        leftAxis.axisMaximum = Double(lvlBlackBoxInt.max()! + 10)
        leftAxis.axisMinimum = Double(lvlBlackBoxInt.min()! - 10)
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
    lazy var paramatrLabel: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        let string = viewModel.blackBoxTHParametrs[0]
        text.text = "\(string)".localized(code)
        text.textColor = UIColor.white
        text.textAlignment = .center
        text.font = UIFont(name:"FuturaPT-Medium", size: screenHeight / 35)
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
        registerCell()
        selectedIndex = IndexPath(item: 0, section: 0)
        yValues2.removeAll()
        var axisMaximum = 0
        var countX = 0
        for i in 0...parametrValues!.count - 1 {
            let referenceTimeInterval = ((parametrValues?.last!.time)! as NSString).doubleValue
            let timeParametr = ((parametrValues?[(parametrValues!.count - 1) - i].time)! as NSString).doubleValue
            let xValue = (timeParametr - referenceTimeInterval) / (3600 * 24)

            yValues2.append(ChartDataEntry(x: Double(xValue) , y: Double((parametrValues?[i].temp)!) ?? 0))
//                print(countX)
            if Int((parametrValues?[i].temp)!) ?? 0 > axisMaximum {
                    axisMaximum = Int((parametrValues?[i].temp)!) ?? 0
                }
                countX += 1
        }
//
//        DispatchQueue.main.async { [self] in
//            self.set1 = LineChartDataSet(values: self.yValues2, label: "----")
//            self.set1.mode = .linear
//            self.set1.drawCirclesEnabled = false
//            self.set1.lineWidth = 3
////            self.set1.drawHorizontalHighlightIndicatorEnabled = false
////            self.set1.drawVerticalHighlightIndicatorEnabled = false
//            self.set1.setColor(UIColor(rgb: 0x00A778), alpha: 1.0)
//            self.lineChartView.leftAxis.axisMaximum = Double(axisMaximum + 10)
//            self.lineChartView.animate(xAxisDuration: 1)
//        }
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
        guard let timeFirts = parametrValues?.first?.time else {return}
        let file = "Black box".localized(code) + " №\("TH " + nameDevice) \(viewModel.unixTimeStringtoStringFull(unixTime: timeFirts)).csv"
        var contents = "TH_\(nameDevice), \("Date".localized(code)), \("Temperature".localized(code)), \("Luminosity".localized(code)), \("Humidity".localized(code)), \("Hall sensor triggering".localized(code))\n"
        for i in 0...parametrValues!.count - 1 {
            guard let id = parametrValues?[i].id else {return}
            contents = contents + " \(id),"
            guard let time = parametrValues?[i].time else {return}
            contents = contents + " \(viewModel.unixTimeStringtoStringFull(unixTime: time)),"
            guard let temp = parametrValues?[i].temp else {return}
            contents = contents + " \(temp),"
            guard let lux = parametrValues?[i].lux else {return}
            contents = contents + " \(lux),"
            guard let humidity = parametrValues?[i].humidity else {return}
            contents = contents + " \(humidity),"
            guard let hallSensor = parametrValues?[i].hallSensor else {return}
            contents = contents + " \(hallSensor)\n"
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
        guard let timeFirts = parametrValues?.first?.time else {return}
        let file = "Black box".localized(code) + " №\("TH " + nameDevice) \(viewModel.unixTimeStringtoStringFull(unixTime: timeFirts)).csv"
        var contents = "TH_\(nameDevice), \("Date".localized(code)), \("Temperature".localized(code)), \("Luminosity".localized(code)), \("Humidity".localized(code)), \("Hall sensor triggering".localized(code))\n"
        for i in 0...parametrValues!.count - 1 {
            guard let id = parametrValues?[i].id else {return}
            contents = contents + " \(id),"
            guard let time = parametrValues?[i].time else {return}
            contents = contents + " \(viewModel.unixTimeStringtoStringFull(unixTime: time)),"
            guard let temp = parametrValues?[i].temp else {return}
            contents = contents + " \(temp),"
            guard let lux = parametrValues?[i].lux else {return}
            contents = contents + " \(lux),"
            guard let humidity = parametrValues?[i].humidity else {return}
            contents = contents + " \(humidity),"
            guard let hallSensor = parametrValues?[i].hallSensor else {return}
            contents = contents + " \(hallSensor)\n"
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
        view.addSubview(collectionView)
        view.addSubview(paramatrLabel)
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: saveView.topAnchor, constant: -20).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        paramatrLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  20).isActive = true
        paramatrLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        paramatrLabel.topAnchor.constraint(equalTo: themeBackView3.bottomAnchor, constant: 10).isActive = true
        paramatrLabel.bottomAnchor.constraint(equalTo: lineChartView.topAnchor, constant: -10).isActive = true

        lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  20).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        lineChartView.topAnchor.constraint(equalTo: paramatrLabel.bottomAnchor, constant: 10).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20).isActive = true

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
    func registerCell() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GrafficsParametrCell.self, forCellWithReuseIdentifier: "GrafficsParametrCell")
    }
    var yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 1, y: 110),
    ]
    var yValues2: [ChartDataEntry] = [
        
    ]
    
    func setData() {
        DispatchQueue.main.async { [self] in
            self.set1 = LineChartDataSet(entries: self.yValues2, label: "Temperature".localized(code))
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
//            paramatrLabel.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
//            paramatrLabel.textColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}

extension GrafficTHController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GrafficsParametrCell", for: indexPath) as! GrafficsParametrCell
//        for i in 0...cheakDate.count {
//            if timeBlackBox[indexPath.row].first! != cheakDate[i] {
        cell.textLabel.text = "\(viewModel.blackBoxTHParametrs[indexPath.row])".localized(code)
        if selectedIndex == indexPath {
            cell.viewMainList.backgroundColor = UIColor(rgb: 0x00A778)
        } else {
            cell.viewMainList.backgroundColor = .gray
        }
//                cheakDate.append(timeBlackBox[indexPath.row].first!)
//                collectionView.reloadData()
//            }
//        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.blackBoxTHParametrs.count
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return UICollectionViewFlowLayout.automaticSize
//    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath
        let nameParametr = viewModel.blackBoxTHParametrs[indexPath.row]
        paramatrLabel.text = "\(nameParametr)".localized(code)
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        yValues2.removeAll()
        var countX = 0
        var lvlBlackBoxInt: [Double] = []
        if indexPath.row == 0 {
            for i in 0...parametrValues!.count - 1 {
                let referenceTimeInterval = ((parametrValues?.last!.time)! as NSString).doubleValue
                let timeParametr = ((parametrValues?[(parametrValues!.count - 1) - i].time)! as NSString).doubleValue
                let xValue = (timeParametr - referenceTimeInterval) / (3600 * 24)
                yValues2.append(ChartDataEntry(x: Double(xValue) , y: Double((parametrValues?[i].temp)!) ?? 0))
                let intHum = Double((parametrValues?[i].temp)!)
                if let doubleHum = intHum  {
                    lvlBlackBoxInt.append(doubleHum)
                }
                countX += 1
            }
        } else if indexPath.row == 1 {
            for i in 0...parametrValues!.count - 1 {
                let referenceTimeInterval = ((parametrValues?.last!.time)! as NSString).doubleValue
                let timeParametr = ((parametrValues?[(parametrValues!.count - 1) - i].time)! as NSString).doubleValue
                let xValue = (timeParametr - referenceTimeInterval) / (3600 * 24)
                yValues2.append(ChartDataEntry(x: Double(xValue) , y: Double((parametrValues?[i].lux)!) ?? 0))
                let intHum = Double((parametrValues?[i].lux)!)
                if let doubleHum = intHum  {
                    lvlBlackBoxInt.append(doubleHum)
                }
                countX += 1
            }
        } else if indexPath.row == 2 {
            for i in 0...parametrValues!.count - 1 {
                let referenceTimeInterval = ((parametrValues?.last!.time)! as NSString).doubleValue
                let timeParametr = ((parametrValues?[(parametrValues!.count - 1) - i].time)! as NSString).doubleValue
                let xValue = (timeParametr - referenceTimeInterval) / (3600 * 24)
                yValues2.append(ChartDataEntry(x: Double(xValue) , y: Double((parametrValues?[i].humidity)!) ?? 0))
                let intHum = Double((parametrValues?[i].humidity)!)
                if let doubleHum = intHum  {
                    lvlBlackBoxInt.append(doubleHum)
                }
                countX += 1
            }
        }  else if indexPath.row == 3 {
            for i in 0...parametrValues!.count - 1 {
                let referenceTimeInterval = ((parametrValues?.last!.time)! as NSString).doubleValue
                let timeParametr = ((parametrValues?[(parametrValues!.count - 1) - i].time)! as NSString).doubleValue
                let xValue = (timeParametr - referenceTimeInterval) / (3600 * 24)
                yValues2.append(ChartDataEntry(x: Double(xValue) , y: Double((parametrValues?[i].hallSensor)!) ?? 0))
                let intHum = Double((parametrValues?[i].hallSensor)!)
                if let doubleHum = intHum  {
                    lvlBlackBoxInt.append(doubleHum)
                }
                countX += 1
            }
        }
        DispatchQueue.main.async { [self] in
            set1 = LineChartDataSet(entries: yValues2, label: "\(viewModel.blackBoxTHParametrs[indexPath.row])".localized(code))
            set1.lineWidth = 3
            set1.drawHorizontalHighlightIndicatorEnabled = false
            set1.drawVerticalHighlightIndicatorEnabled = false
            set1.setColor(UIColor(rgb: 0x00A778), alpha: 1.0)
            set1.mode = .linear
            set1.drawCirclesEnabled = false
            data = LineChartData(dataSet: set1)
            data.setDrawValues(false)
            lineChartView.data = data
            lineChartView.leftAxis.axisMaximum = Double(lvlBlackBoxInt.max()! + 10)
            lineChartView.leftAxis.axisMinimum = Double(lvlBlackBoxInt.min()! - 10)
            lineChartView.animate(xAxisDuration: 1)
//                lineChartView.data? = data
//                lineChartView.data!.notifyDataChanged()
        }
    }
}

class ChartXAxisFormatter: NSObject {
    fileprivate var dateFormatter: DateFormatter?
    fileprivate var referenceTimeInterval: TimeInterval?

    convenience init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}


extension ChartXAxisFormatter: IAxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
        let referenceTimeInterval = referenceTimeInterval
        else {
            return ""
        }

        let date = Date(timeIntervalSince1970: value * 3600 * 24 + referenceTimeInterval)
        return dateFormatter.string(from: date)
    }

}
