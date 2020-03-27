//
//  PDF.swift
//  Escort
//
//  Created by Володя Зверев on 07.02.2020.
//  Copyright © 2020 Escort All rights reserved.
//

import UIKit
import TPPDF
import WebKit

class PDF: UIViewController {
    let generator = UIImpactFeedbackGenerator(style: .light)
    let webView = WKWebView()
    fileprivate lazy var themeBackView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: (hasNotch ? 20 : 45), width: screenWidth, height: headerHeight-(hasNotch ? 35 : 67))
        v.layer.cornerRadius = 10
        return v
    }()
    fileprivate lazy var hamburger: UIImageView = {
        let hamburger = UIImageView(image: UIImage(named: "abc"))
        hamburger.image = hamburger.image!.withRenderingMode(.alwaysTemplate)
        return hamburger
    }()
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-60), height: 40))
        text.text = "Type of bluetooth sensor".localized(code)
        text.textColor = UIColor(rgb: 0x272727)
        text.font = UIFont(name:"BankGothicBT-Medium", size: (iphone5s ? 17 : 19))
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
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame =  CGRect(x: 0, y: headerHeight-10, width: screenWidth, height: screenHeight-(headerHeight-10))
        view.addSubview(webView)
        
        view.addSubview(themeBackView3)

        MainLabel.text = "PDF файл".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        
        setupTheme()
        generateExamplePDF()
    }
    func getCurrentShortDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let dateString = dateFormatter.string(from: Date.init())
        return dateString
    }
    
    func generateExamplePDF() {
        /* ---- Execution Metrics ---- */
        var startTime = CFAbsoluteTimeGetCurrent()
        /* ---- Execution Metrics ---- */
        
        let document = PDFDocument(format: .a4)
        
        // Set document meta data
        document.info.title = "TPPDF Example"
        document.info.subject = "Building a PDF easily"
        document.info.ownerPassword = "Password123"
        
        // Set spacing of header and footer
        document.layout.space.header = 5
        document.layout.space.footer = 5

        let documentOne = PDFDocument(format: .a4)
        documentOne.pagination = PDFPagination(container: .footerCenter, style: PDFPaginationStyle.customClosure { (page, total) -> String in
            return "Стр. \(page) из \(total)"
            }, range: (1, 20), hiddenPages: [0, 0], textAttributes: [
                .font: UIFont.boldSystemFont(ofSize: 15.0),
                .foregroundColor: UIColor.black
            ])
        
        let titleOne = NSMutableAttributedString(string: "Информация о транспортном средстве", attributes: [
            .font: UIFont.systemFont(ofSize: 16.0),
            .foregroundColor: UIColor.black
        ])
        
        let actLabelOne = NSMutableAttributedString(string: "Акт о выполнении работ", attributes: [
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.black
        ])
        
        documentOne.add(.contentLeft, attributedText: actLabelOne)
        
        documentOne.add(space: -15.0)
        
        let dataLabelOne = NSMutableAttributedString(string: "Дата выполнения \(getCurrentShortDate())", attributes: [
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.black
        ])
        documentOne.add(.contentRight, attributedText: dataLabelOne)
        
        //        document.add(space: .0)
        
        let zakazLabelOne = NSMutableAttributedString(string: "Заказчик: \(zakazMap)", attributes: [
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.black
        ])
        documentOne.add(.contentLeft, attributedText: zakazLabelOne)

        documentOne.add(space: 15.0)
        documentOne.add(.contentCenter, attributedText: titleOne)
        documentOne.add(space: 10)
        var imageNil = UIImage()
        imageNil = #imageLiteral(resourceName: "Path-2")
        var firstPhoto : [UIImage] = []
        if photoALLModel.count == 2 && (photoALLModel.first == UIImage(named: "Group 29-2") || photoALLModel.first == UIImage(named: "Group 29-2N")){
            firstPhoto.append(photoALLModel[1])
            firstPhoto.append(imageNil)
        } else if photoALLModel.count == 1 {
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
        } else if photoALLModel.count == 2 && (photoALLModel.first != UIImage(named: "Group 29-2") && photoALLModel.first != UIImage(named: "Group 29-2N")){
            firstPhoto.append(photoALLModel[0])
            firstPhoto.append(photoALLModel[1])
        }
        let tableOne = PDFTable()
        do {
            try tableOne.generateCells(
                data:
                [
                    ["Модель: \(modelTcText)", firstPhoto[0], firstPhoto[1]],

                ],
                alignments:
                [
                    [.center, .center, .center]

            ])
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        tableOne.widths = [
            0.2, 0.4 , 0.4
        ]
        tableOne.padding = 5.0
        tableOne.margin = 0.0
        
        // In case of a linebreak during rendering we want to have table headers on each page.
        //        table.showHeadersOnEveryPage = true
        let styleOne = PDFTableStyleDefaults.simple
        
        // Change standardized styles
        styleOne.alternatingContentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        styleOne.rowHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        styleOne.contentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        
        // Simply set the amount of footer and header rows
        styleOne.columnHeaderCount = 0
        tableOne.style = styleOne
        
        documentOne.add(table: tableOne)
        documentOne.add(table: createTableNumberTC())
        documentOne.add(space: 15)
        
        let titleTracker = NSMutableAttributedString(string: "ГЛОНАСС/GPS Трекер", attributes: [
            .font: UIFont.systemFont(ofSize: 16.0),
            .foregroundColor: UIColor.black
        ])
        documentOne.add(.contentCenter, attributedText: titleTracker)
        documentOne.add(space: 10)
        documentOne.add(table: createTableTracker())
        documentOne.add(table: createTablePlomba())
        documentOne.add(table: createTablePlace())
        documentOne.add(table: createTableDopInformation())
        
        documentOne.add(space: 30)

//        documentOne.createNewPage()
        if numberOfRowLvlTopPreLast > 1 {
            for i in 1...numberOfRowLvlTopPreLast-1 {
                
                let titleDut = NSMutableAttributedString(string: "Монтаж и Тарировка Датчика Уровня Топлива № \(i)", attributes: [
                    .font: UIFont.systemFont(ofSize: 16.0),
                    .foregroundColor: UIColor.black
                ])
                documentOne.add(.contentCenter, attributedText: titleDut)
                
                documentOne.add(space: 10)
                documentOne.add(table: createMontajDUT(i: i))
                documentOne.add(table: createMontajDUTPlombaOne(i: i))
                documentOne.add(table: createMontajDUTPlombaTwo(i: i))
                documentOne.add(table: createTableMontajPlace(i: i))
                documentOne.add(table: createTableDopInformation(i: i))
                documentOne.add(space: 15)
                if itemsPdf != [] {
                    let titleCal = NSMutableAttributedString(string: "Таблица тарирования бака", attributes: [
                        .font: UIFont.systemFont(ofSize: 16.0),
                        .foregroundColor: UIColor.black
                    ])
                    documentOne.add(.contentCenter, attributedText: titleCal)
                    documentOne.add(space: 10)
                    documentOne.add(table: tableCal(i: i))
                }
                documentOne.add(space: 15)
            }
        }
        
        
//        let titleDut = NSMutableAttributedString(string: "Монтаж и Тарировка Датчика Уровня Топлива № 1", attributes: [
//            .font: UIFont.systemFont(ofSize: 16.0),
//            .foregroundColor: UIColor.black
//        ])
//        documentOne.add(.contentCenter, attributedText: titleDut)
//
//        documentOne.add(space: 10)
//        documentOne.add(table: createMontajDUT())
//        documentOne.add(table: createMontajDUTPlombaOne())
//        documentOne.add(table: createMontajDUTPlombaTwo())
//        documentOne.add(table: createTableMontajPlace())
//        documentOne.add(table: createTableDopInformation())
//        documentOne.add(space: 15)
        
        if dopText != "" {
            documentOne.add(space: 10)
            documentOne.add(table: createTableDopInformationLast())
            documentOne.add(space: 10)
        }
        
        documentOne.add(space: 30)
        
        let titleIspolnitel = NSMutableAttributedString(string: "Исполнитель", attributes: [
            .font: UIFont.systemFont(ofSize: 16.0),
            .foregroundColor: UIColor.black
        ])
        let titleFIO = NSMutableAttributedString(string: "Ф.И.О. \(FIO)", attributes: [
            .font: UIFont.systemFont(ofSize: 14.0),
            .foregroundColor: UIColor.black
        ])
        let titleP = NSMutableAttributedString(string: "Подпись: __________________", attributes: [
            .font: UIFont.systemFont(ofSize: 14.0),
            .foregroundColor: UIColor.black
        ])
        documentOne.add(.contentCenter, attributedText: titleIspolnitel)
        documentOne.add(space: 20)
        documentOne.add(.contentLeft, attributedText: titleFIO)
        documentOne.add(space: 20)
        documentOne.add(.contentLeft, attributedText: titleP)
        documentOne.add(space: -50)

        /* ---- Execution Metrics ---- */
        print("Preparation took: " + stringFromTimeInterval(interval: CFAbsoluteTimeGetCurrent() - startTime))
        startTime = CFAbsoluteTimeGetCurrent()
        /* ---- Execution Metrics ---- */
        
        // Convert document to JSON String for debugging
//        let _ = document.toJSON(options: JSONSerialization.WritingOptions.prettyPrinted) ?? "nil"
//        print(json)
        do {
            // Generate PDF file and save it in a temporary file. This returns the file URL to the temporary file
            let url = try PDFGenerator.generateURL(documents: [documentOne],
                                                   filename: "Карта установки \(FIO).pdf",
                                                   progress: { (docIndex: Int, progressValue: CGFloat, totalProgressValue: CGFloat) in
                                                    print("doc:", docIndex, "progress:", progressValue, "total:", totalProgressValue)
            })

            // Load PDF into a webview from the temporary file
            print("url: \(url)")
            
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            
            let downloadTask = urlSession.downloadTask(with: url)
            downloadTask.resume()
            
            webView.loadFileURL(url, allowingReadAccessTo: url)
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
            hamburgerPlace.frame = CGRect(x: screenWidth-50, y: yHamb - (iphone5s ? 5 : 0), width: 45, height: 40)
            hamburger.frame = CGRect(x: screenWidth-45, y: yHamb, width: 25, height: 25)

            self.view.addSubview(hamburger)
            self.view.addSubview(hamburgerPlace)
            hamburgerPlace.addTapGesture {
                self.generator.impactOccurred()
                let fileURL = URL(fileURLWithPath: url.path)
                var filesToShare = [Any]()
                filesToShare.append(fileURL)
                let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
            
        } catch {
            print("Error while generating PDF: " + error.localizedDescription)
        }
        backView.addTapGesture{
            self.generator.impactOccurred()
            self.navigationController?.popViewController(animated: true)
        }
        
        /* ---- Execution Metrics ---- */
        print("Generation took: " + stringFromTimeInterval(interval: CFAbsoluteTimeGetCurrent() - startTime))
        /* ---- Execution Metrics ---- */
    }
    
    /**
     Used for debugging execution time.
     Converts time interval in seconds to String.
     */
    func createTableNumberTC() -> PDFTable {
        let tableOne = PDFTable()
        var imageNil = UIImage()
        imageNil = #imageLiteral(resourceName: "Path-2")
        var firstPhoto : [UIImage] = []
        if photoALLNumber.count == 2 && (photoALLNumber.first == UIImage(named: "Group 29-2") || photoALLNumber.first == UIImage(named: "Group 29-2N")) {
            firstPhoto.append(photoALLNumber[1])
            firstPhoto.append(imageNil)
        } else if photoALLNumber.count == 1 {
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
        } else if photoALLNumber.count == 2 && (photoALLNumber.first != UIImage(named: "Group 29-2") && photoALLNumber.first != UIImage(named: "Group 29-2N")) {
            firstPhoto.append(photoALLNumber[0])
            firstPhoto.append(photoALLNumber[1])
        }
        do {
            try tableOne.generateCells(
                data:
                [
                    ["Номер: \(numberTcText)", firstPhoto[0], firstPhoto[1]],


                ],
                alignments:
                [
                    [.center, .center, .center],

            ])
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        tableOne.widths = [
            0.2, 0.4 , 0.4
        ]
        tableOne.padding = 5.0
        tableOne.margin = 0.0
        
        // In case of a linebreak during rendering we want to have table headers on each page.
        //        table.showHeadersOnEveryPage = true
        let styleOne = PDFTableStyleDefaults.simple
        
        // Change standardized styles
        styleOne.alternatingContentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        styleOne.rowHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        styleOne.contentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        
        // Simply set the amount of footer and header rows
        styleOne.columnHeaderCount = 0
        tableOne.style = styleOne
        return tableOne
    }
    func createTableTracker() -> PDFTable {
        let tableOne = PDFTable()
        var imageNil = UIImage()
        imageNil = #imageLiteral(resourceName: "Path-2")
        var firstPhoto : [UIImage] = []
        if photoALLTrack.count == 2 && (photoALLTrack.first == UIImage(named: "Group 29-2") || photoALLTrack.first == UIImage(named: "Group 29-2N")) {
            firstPhoto.append(photoALLTrack[1])
            firstPhoto.append(imageNil)
        } else if photoALLTrack.count == 1 {
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
        } else if photoALLTrack.count == 2 && (photoALLTrack.first != UIImage(named: "Group 29-2") && photoALLTrack.first != UIImage(named: "Group 29-2N")) {
            firstPhoto.append(photoALLTrack[0])
            firstPhoto.append(photoALLTrack[1])
        }
        do {
            try tableOne.generateCells(
                data:
                [
                    ["Модель: \(modelTrackText)", firstPhoto[0], firstPhoto[1]],


                ],
                alignments:
                [
                    [.center, .center, .center],

            ])
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        tableOne.widths = [
            0.2, 0.4 , 0.4
        ]
        tableOne.padding = 5.0
        tableOne.margin = 0.0
        
        // In case of a linebreak during rendering we want to have table headers on each page.
        //        table.showHeadersOnEveryPage = true
        let styleOne = PDFTableStyleDefaults.simple
        
        // Change standardized styles
        styleOne.alternatingContentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        styleOne.rowHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        styleOne.contentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        
        // Simply set the amount of footer and header rows
        styleOne.columnHeaderCount = 0
        tableOne.style = styleOne
        return tableOne
    }
    func tableCal(i: Int) -> PDFTable {
        let tableCal = PDFTable()
        var tableCalItems = [["Литры", "Топливо"]]
        var tableCalAligments: [[PDFTableCellAlignment]] = [[.center, .center]]
        for j in 0...levelnumberPdfSecond[i-1].count-1 {
            let a = itemsPdfSecond[i-1]
            let b = levelnumberPdfSecond[i-1]
            tableCalItems.append(["\(a[j])","\(b[j])"])
            tableCalAligments.append([.center, .center])
            
        }
        do {
            try tableCal.generateCells(
                data:
                tableCalItems,
                alignments:
                tableCalAligments
            )
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        tableCal.widths = [
            0.5, 0.5
        ]
        tableCal.padding = 0.0
        tableCal.margin = 0.0
        
        // In case of a linebreak during rendering we want to have table headers on each page.
        //        table.showHeadersOnEveryPage = true
        let styleCal = PDFTableStyleDefaults.simple
        
        // Change standardized styles
        styleCal.alternatingContentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        styleCal.rowHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        styleCal.contentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        // Simply set the amount of footer and header rows
        styleCal.columnHeaderCount = 0
        tableCal.style = styleCal
        return tableCal
    }
    func createTablePlomba() -> PDFTable {
        let tableOne = PDFTable()
        var imageNil = UIImage()
        imageNil = #imageLiteral(resourceName: "Path-2")
        var firstPhoto : [UIImage] = []
        if photoALLPlomba.count == 2 && (photoALLPlomba.first == UIImage(named: "Group 29-2") || photoALLPlomba.first == UIImage(named: "Group 29-2N")) {
            firstPhoto.append(photoALLPlomba[1])
            firstPhoto.append(imageNil)
        } else if photoALLPlomba.count == 2 && (photoALLPlomba.first != UIImage(named: "Group 29-2") && photoALLPlomba.first != UIImage(named: "Group 29-2N")) {
            firstPhoto.append(photoALLPlomba[0])
            firstPhoto.append(photoALLPlomba[1])
        } else if photoALLPlomba.count == 1 {
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
        }
        do {
            try tableOne.generateCells(
                data:
                [
                    ["№ Пломбы: \(plombaTrackText)", firstPhoto[0], firstPhoto[1]],


                ],
                alignments:
                [
                    [.center, .center, .center],

            ])
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        tableOne.widths = [
            0.2, 0.4 , 0.4
        ]
        tableOne.padding = 5.0
        tableOne.margin = 0.0
        
        // In case of a linebreak during rendering we want to have table headers on each page.
        //        table.showHeadersOnEveryPage = true
        let styleOne = PDFTableStyleDefaults.simple
        
        // Change standardized styles
        styleOne.alternatingContentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        styleOne.rowHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        styleOne.contentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        
        // Simply set the amount of footer and header rows
        styleOne.columnHeaderCount = 0
        tableOne.style = styleOne
        return tableOne
    }
    func createTablePlace() -> PDFTable {
        let tableOne = PDFTable()
        var imageNil = UIImage()
        imageNil = #imageLiteral(resourceName: "Path-2")
        var firstPhoto : [UIImage] = []
        if photoALLPlace.count == 2 {
            firstPhoto.append(photoALLPlace[1])
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
        } else if photoALLPlace.count == 1 {
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
        } else if photoALLPlace.count == 3 {
            firstPhoto.append(photoALLPlace[1])
            firstPhoto.append(photoALLPlace[2])
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
        } else if photoALLPlace.count == 4 && (photoALLPlace.first == UIImage(named: "Group 29-2") || photoALLPlace.first == UIImage(named: "Group 29-2N")){
            firstPhoto.append(photoALLPlace[1])
            firstPhoto.append(photoALLPlace[2])
            firstPhoto.append(photoALLPlace[3])
            firstPhoto.append(imageNil)
        } else if photoALLPlace.count == 4 && (photoALLPlace.first != UIImage(named: "Group 29-2") && photoALLPlace.first != UIImage(named: "Group 29-2N")){
            firstPhoto.append(photoALLPlace[0])
            firstPhoto.append(photoALLPlace[1])
            firstPhoto.append(photoALLPlace[2])
            firstPhoto.append(photoALLPlace[3])

        }
        do {
            try tableOne.generateCells(
                data:
                [
                    ["Место установки", firstPhoto[0], firstPhoto[1]],
                    [nil, firstPhoto[2], firstPhoto[3]],


                ],
                alignments:
                [
                    [.center, .center, .center],
                    [.center, .center, .center],

            ])
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        tableOne.widths = [
            0.2, 0.4 , 0.4
        ]
        tableOne.padding = 5.0
        tableOne.margin = 0.0
        
        // In case of a linebreak during rendering we want to have table headers on each page.
        //        table.showHeadersOnEveryPage = true
        let styleOne = PDFTableStyleDefaults.simple
        
        // Change standardized styles
        styleOne.alternatingContentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        styleOne.rowHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        styleOne.contentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        
        // Simply set the amount of footer and header rows
        styleOne.columnHeaderCount = 0
        tableOne.style = styleOne
        return tableOne
    }
    func createTableDopInformation() -> PDFTable {
        let tableOne = PDFTable()
        do {
            try tableOne.generateCells(
                data:
                [
                    ["Дополнительная информация", "\(infoTrackText)"],


                ],
                alignments:
                [
                    [.center, .center],

            ])
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        tableOne.widths = [
            0.2, 0.8
        ]
        tableOne.padding = 5.0
        tableOne.margin = 0.0
        
        // In case of a linebreak during rendering we want to have table headers on each page.
        //        table.showHeadersOnEveryPage = true
        let styleOne = PDFTableStyleDefaults.simple
        
        // Change standardized styles
        styleOne.alternatingContentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        styleOne.rowHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        styleOne.contentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        
        // Simply set the amount of footer and header rows
        styleOne.columnHeaderCount = 0
        tableOne.style = styleOne
        return tableOne
    }
    func createTableDopInformation(i: Int) -> PDFTable {
        let tableOne = PDFTable()
        do {
            try tableOne.generateCells(
                data:
                [
                    ["Дополнительная информация", "\(photoALLPlaceSetTrackLabel[i-1])"],


                ],
                alignments:
                [
                    [.center, .center],

            ])
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        tableOne.widths = [
            0.2, 0.8
        ]
        tableOne.padding = 5.0
        tableOne.margin = 0.0
        
        // In case of a linebreak during rendering we want to have table headers on each page.
        //        table.showHeadersOnEveryPage = true
        let styleOne = PDFTableStyleDefaults.simple
        
        // Change standardized styles
        styleOne.alternatingContentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        styleOne.rowHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        styleOne.contentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        
        // Simply set the amount of footer and header rows
        styleOne.columnHeaderCount = 0
        tableOne.style = styleOne
        return tableOne
    }
    func createTableDopInformationLast() -> PDFTable {
        let tableOne = PDFTable()
        do {
            try tableOne.generateCells(
                data:
                [
                    ["Дополнительная информация", "\(dopText)"],


                ],
                alignments:
                [
                    [.center, .center],

            ])
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        tableOne.widths = [
            0.2, 0.8
        ]
        tableOne.padding = 5.0
        tableOne.margin = 0.0
        
        // In case of a linebreak during rendering we want to have table headers on each page.
        //        table.showHeadersOnEveryPage = true
        let styleOne = PDFTableStyleDefaults.simple
        
        // Change standardized styles
        styleOne.alternatingContentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        styleOne.rowHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        styleOne.contentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10)
        )
        
        // Simply set the amount of footer and header rows
        styleOne.columnHeaderCount = 0
        tableOne.style = styleOne
        return tableOne
    }

    func createMontajDUT(i: Int) -> PDFTable {
         let tableOne = PDFTable()
         do {
             try tableOne.generateCells(
                 data:
                 [
                    ["Модель: \(DutTrackLabel[i-1])", "Серийный номер: № \(photoALLNumberDutLabel[i-1])"],


                 ],
                 alignments:
                 [
                     [.center, .center],

             ])
         } catch PDFError.tableContentInvalid(let value) {
             // In case invalid input is provided, this error will be thrown.
             print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
         } catch {
             // General error handling in case something goes wrong.
             print("Error while creating table: " + error.localizedDescription)
         }
         tableOne.widths = [
             0.5, 0.5
         ]
         tableOne.padding = 5.0
         tableOne.margin = 0.0
         
         // In case of a linebreak during rendering we want to have table headers on each page.
         //        table.showHeadersOnEveryPage = true
         let styleOne = PDFTableStyleDefaults.simple
         
         // Change standardized styles
         styleOne.alternatingContentStyle = PDFTableCellStyle(
             colors: (
                 fill: UIColor.clear,
                 text: UIColor.black
             ),
             borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                          top: PDFLineStyle(type: .full),
                                          right: PDFLineStyle(type: .full),
                                          bottom: PDFLineStyle(type: .full)),
             
             font: UIFont.systemFont(ofSize: 10, weight: .bold)
         )
         styleOne.rowHeaderStyle = PDFTableCellStyle(
             colors: (
                 fill: UIColor.clear,
                 text: UIColor.black
             ),
             borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                          top: PDFLineStyle(type: .none),
                                          right: PDFLineStyle(type: .full),
                                          bottom: PDFLineStyle(type: .none)),
             
             font: UIFont.systemFont(ofSize: 10, weight: .bold)
         )
         
         styleOne.contentStyle = PDFTableCellStyle(
             colors: (
                 fill: UIColor.clear,
                 text: UIColor.black
             ),
             borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                          top: PDFLineStyle(type: .none),
                                          right: PDFLineStyle(type: .full),
                                          bottom: PDFLineStyle(type: .none)),
             
             font: UIFont.systemFont(ofSize: 10, weight: .bold)
         )
         
         // Simply set the amount of footer and header rows
         styleOne.columnHeaderCount = 0
         tableOne.style = styleOne
         return tableOne
     }
    func createMontajDUTPlombaOne(i: Int) -> PDFTable {
        let tableOne = PDFTable()
        var imageNil = UIImage()
        imageNil = #imageLiteral(resourceName: "Path-2")
        var firstPhoto : [UIImage] = []
        if photoALLPlombaFirstTrack[i-1].count == 1 {
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
        } else if photoALLPlombaFirstTrack[i-1].count == 2 && (photoALLPlombaFirstTrack[i-1].first == UIImage(named: "Group 29-2") || photoALLPlombaFirstTrack[i-1].first == UIImage(named: "Group 29-2N")){
            firstPhoto.append(photoALLPlombaFirstTrack[i-1][1])
            firstPhoto.append(imageNil)
        } else if photoALLPlombaFirstTrack[i-1].count == 2 && (photoALLPlombaFirstTrack[i-1].first != UIImage(named: "Group 29-2") && photoALLPlombaFirstTrack[i-1].first != UIImage(named: "Group 29-2N")){
            firstPhoto.append(photoALLPlombaFirstTrack[i-1][0])
            firstPhoto.append(photoALLPlombaFirstTrack[i-1][1])
        }
         do {
             try tableOne.generateCells(
                 data:
                 [
                    ["Пломба № 1: \(String(describing: photoALLPlombaFirstTrackLabel[i-1]))", firstPhoto[0], firstPhoto[1]],


                 ],
                 alignments:
                 [
                     [.center, .center, .center],

             ])
         } catch PDFError.tableContentInvalid(let value) {
             // In case invalid input is provided, this error will be thrown.
             print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
         } catch {
             // General error handling in case something goes wrong.
             print("Error while creating table: " + error.localizedDescription)
         }
         tableOne.widths = [
             0.2, 0.4, 0.4
         ]
         tableOne.padding = 5.0
         tableOne.margin = 0.0
         
         // In case of a linebreak during rendering we want to have table headers on each page.
         //        table.showHeadersOnEveryPage = true
         let styleOne = PDFTableStyleDefaults.simple
         
         // Change standardized styles
         styleOne.alternatingContentStyle = PDFTableCellStyle(
             colors: (
                 fill: UIColor.clear,
                 text: UIColor.black
             ),
             borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                          top: PDFLineStyle(type: .full),
                                          right: PDFLineStyle(type: .full),
                                          bottom: PDFLineStyle(type: .full)),
             
             font: UIFont.systemFont(ofSize: 10, weight: .bold)
         )
         styleOne.rowHeaderStyle = PDFTableCellStyle(
             colors: (
                 fill: UIColor.clear,
                 text: UIColor.black
             ),
             borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                          top: PDFLineStyle(type: .none),
                                          right: PDFLineStyle(type: .full),
                                          bottom: PDFLineStyle(type: .none)),
             
             font: UIFont.systemFont(ofSize: 10, weight: .bold)
         )
         
         styleOne.contentStyle = PDFTableCellStyle(
             colors: (
                 fill: UIColor.clear,
                 text: UIColor.black
             ),
             borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                          top: PDFLineStyle(type: .none),
                                          right: PDFLineStyle(type: .full),
                                          bottom: PDFLineStyle(type: .none)),
             
             font: UIFont.systemFont(ofSize: 10, weight: .bold)
         )
         
         // Simply set the amount of footer and header rows
         styleOne.columnHeaderCount = 0
         tableOne.style = styleOne
         return tableOne
     }
    func createMontajDUTPlombaTwo(i: Int) -> PDFTable {
         let tableOne = PDFTable()
        var imageNil = UIImage()
        imageNil = #imageLiteral(resourceName: "Path-2")
        var firstPhoto : [UIImage] = []
        if photoALLPlombaSecondTrack[i-1].count == 1 {
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
        } else if photoALLPlombaSecondTrack[i-1].count == 2 && (photoALLPlombaSecondTrack[i-1].first == UIImage(named: "Group 29-2") || photoALLPlombaSecondTrack[i-1].first == UIImage(named: "Group 29-2N")){
            firstPhoto.append(photoALLPlombaSecondTrack[i-1][1])
            firstPhoto.append(imageNil)
        } else if photoALLPlombaSecondTrack[i-1].count == 2 && (photoALLPlombaSecondTrack[i-1].first != UIImage(named: "Group 29-2") && photoALLPlombaSecondTrack[i-1].first != UIImage(named: "Group 29-2N")){
            firstPhoto.append(photoALLPlombaSecondTrack[i-1][0])
            firstPhoto.append(photoALLPlombaSecondTrack[i-1][1])
        }
         do {
             try tableOne.generateCells(
                 data:
                 [
                    ["Пломба № 2: \(String(describing: photoALLPlombaSecondTrackLabel[i-1]))", firstPhoto[0], firstPhoto[1]],


                 ],
                 alignments:
                 [
                     [.center, .center, .center],

             ])
         } catch PDFError.tableContentInvalid(let value) {
             // In case invalid input is provided, this error will be thrown.
             print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
         } catch {
             // General error handling in case something goes wrong.
             print("Error while creating table: " + error.localizedDescription)
         }
         tableOne.widths = [
             0.2, 0.4, 0.4
         ]
         tableOne.padding = 5.0
         tableOne.margin = 0.0
         
         // In case of a linebreak during rendering we want to have table headers on each page.
         //        table.showHeadersOnEveryPage = true
         let styleOne = PDFTableStyleDefaults.simple
         
         // Change standardized styles
         styleOne.alternatingContentStyle = PDFTableCellStyle(
             colors: (
                 fill: UIColor.clear,
                 text: UIColor.black
             ),
             borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                          top: PDFLineStyle(type: .full),
                                          right: PDFLineStyle(type: .full),
                                          bottom: PDFLineStyle(type: .full)),
             
             font: UIFont.systemFont(ofSize: 10, weight: .bold)
         )
         styleOne.rowHeaderStyle = PDFTableCellStyle(
             colors: (
                 fill: UIColor.clear,
                 text: UIColor.black
             ),
             borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                          top: PDFLineStyle(type: .none),
                                          right: PDFLineStyle(type: .full),
                                          bottom: PDFLineStyle(type: .none)),
             
             font: UIFont.systemFont(ofSize: 10, weight: .bold)
         )
         
         styleOne.contentStyle = PDFTableCellStyle(
             colors: (
                 fill: UIColor.clear,
                 text: UIColor.black
             ),
             borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                          top: PDFLineStyle(type: .none),
                                          right: PDFLineStyle(type: .full),
                                          bottom: PDFLineStyle(type: .none)),
             
             font: UIFont.systemFont(ofSize: 10, weight: .bold)
         )
         
         // Simply set the amount of footer and header rows
         styleOne.columnHeaderCount = 0
         tableOne.style = styleOne
         return tableOne
     }
    func createTableMontajPlace(i: Int) -> PDFTable {
        let tableOne = PDFTable()
        var imageNil = UIImage()
        imageNil = #imageLiteral(resourceName: "Path-2")
        var firstPhoto : [UIImage] = []
        print("photoALLPlaceSetTrack[i-1].count: \(photoALLPlaceSetTrack[i-1].count)")
        if photoALLPlaceSetTrack[i-1].count == 1 {
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
        } else if photoALLPlaceSetTrack[i-1].count == 2 && (photoALLPlaceSetTrack[i-1].first == UIImage(named: "Group 29-2") || photoALLPlaceSetTrack[i-1].first == UIImage(named: "Group 29-2N")){
            firstPhoto.append(photoALLPlaceSetTrack[i-1][1])
            firstPhoto.append(imageNil)
        } else if photoALLPlaceSetTrack[i-1].count == 2 && (photoALLPlaceSetTrack[i-1].first != UIImage(named: "Group 29-2") && photoALLPlaceSetTrack[i-1].first != UIImage(named: "Group 29-2N")){
            firstPhoto.append(photoALLPlaceSetTrack[i-1][0])
            firstPhoto.append(photoALLPlaceSetTrack[i-1][1])
        } else {
            firstPhoto.append(imageNil)
            firstPhoto.append(imageNil)
        }
        do {
            try tableOne.generateCells(
                data:
                [
                    ["Место установки", firstPhoto[0], firstPhoto[1]]
                    
                    
                ],
                alignments:
                [
                    [.center, .center, .center],
                    
            ])
        } catch PDFError.tableContentInvalid(let value) {
            // In case invalid input is provided, this error will be thrown.
            print("This type of object is not supported as table content: " + String(describing: (type(of: value))))
        } catch {
            // General error handling in case something goes wrong.
            print("Error while creating table: " + error.localizedDescription)
        }
        tableOne.widths = [
            0.2, 0.4 , 0.4
        ]
        tableOne.padding = 5.0
        tableOne.margin = 0.0
        
        // In case of a linebreak during rendering we want to have table headers on each page.
        //        table.showHeadersOnEveryPage = true
        let styleOne = PDFTableStyleDefaults.simple
        
        // Change standardized styles
        styleOne.alternatingContentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .full),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .full)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        styleOne.rowHeaderStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        styleOne.contentStyle = PDFTableCellStyle(
            colors: (
                fill: UIColor.clear,
                text: UIColor.black
            ),
            borders: PDFTableCellBorders(left: PDFLineStyle(type: .full),
                                         top: PDFLineStyle(type: .none),
                                         right: PDFLineStyle(type: .full),
                                         bottom: PDFLineStyle(type: .none)),
            
            font: UIFont.systemFont(ofSize: 10, weight: .bold)
        )
        
        // Simply set the amount of footer and header rows
        styleOne.columnHeaderCount = 0
        tableOne.style = styleOne
        return tableOne
    }
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let ns = (interval * 10e8).truncatingRemainder(dividingBy: 10e5)
        let ms = (interval * 10e2).rounded(.towardZero)
        let seconds = interval.rounded(.towardZero)
        let minutes = (interval / 60).rounded(.towardZero)
        let hours = (interval / 3600).rounded(.towardZero)
        
        var result = [String]()
        if hours > 1 {
            result.append(String(format: "%.0f", hours) + "h")
        }
        if minutes > 1 {
            result.append(String(format: "%.0f", minutes) + "m")
        }
        if seconds > 1 {
            result.append(String(format: "%.0f", seconds) + "s")
        }
        if ms > 1 {
            result.append(String(format: "%.0f", ms) + "ms")
        }
        if ns > 0.001 {
            result.append(String(format: "%.3f", ns) + "ns")
        }
        return result.joined(separator: " ")
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            themeBackView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
            hamburger.theme.tintColor = themed{ $0.navigationTintColor }
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            hamburger.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}


extension PDF:  URLSessionDownloadDelegate {
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
