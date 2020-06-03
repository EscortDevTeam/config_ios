//
//  DFUViewController.swift
//  Escort
//
//  Created by Володя Зверев on 07.04.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit
import CoreBluetooth
import ZIPFoundation
import iOSDFULibrary

class DFUViewController: BaseViewController, ScannerDelegate, FileSelectionDelegate, LoggerDelegate, DFUServiceDelegate, DFUProgressDelegate {
    
    //MARK: - Class properties
    var selectedPeripheral : CBPeripheral?
    var centralManager     : CBCentralManager?
    var dfuController      : DFUServiceController?
    var selectedFirmware   : DFUFirmware?
    var selectedFileURL    : URL?
    var isImportingFile = false
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        img.alpha = 0.3
        return img
    }()
    //MARK: - UIViewController Outlets
    
    //    @IBOutlet weak var dfuLibraryVersionLabel: UILabel!
    @IBOutlet weak var fileNaming: UILabel!
    @IBOutlet weak var deviceNaming: UILabel!
    @IBOutlet weak var labelDevice: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSize: UILabel!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileSize: UILabel!
    //    @IBOutlet weak var fileType: UILabel!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var selectFileButton: UIButton! {
        didSet {
            self.selectFileButton.backgroundColor = UIColor(rgb: 0xE80000)
            self.selectFileButton.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var uploadStatus: UILabel!
    //    @IBOutlet weak var verticalLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!{
        didSet {
            self.connectButton.backgroundColor = UIColor(rgb: 0xE80000)
            self.connectButton.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var uploadPane: UIView! {
        didSet {
            uploadPane.layer.shadowRadius = 3.0
            uploadPane.layer.shadowOpacity = 0.2
            uploadPane.layer.cornerRadius = 10
            uploadPane.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        }
    }
    
    @IBOutlet weak var uploadButton: UIButton!{
        didSet {
            self.uploadButton.backgroundColor = UIColor(rgb: 0xE80000)
            self.uploadButton.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var viewAction: UIView! {
        didSet {
            viewAction.layer.shadowRadius = 3.0
            viewAction.layer.shadowOpacity = 0.2
            viewAction.layer.cornerRadius = 10
            viewAction.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        }
    }
    fileprivate lazy var themeBackView3: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: screenWidth+20, height: headerHeight-(hasNotch ? 5 : 12) + (iphone5s ? 10 : 0))
        v.layer.shadowRadius = 3.0
        v.layer.shadowOpacity = 0.2
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        return v
    }()
    fileprivate lazy var MainLabel: UILabel = {
        let text = UILabel(frame: CGRect(x: 24, y: dIy + (hasNotch ? dIPrusy+30 : 40) + dy - (iphone5s ? 10 : 0), width: Int(screenWidth-24), height: 40))
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
    //MARK: - UIViewController Actions
    
    @IBAction func aboutButtonTapped(_ sender: AnyObject) {
        handleAboutButtonTapped()
    }
    @IBAction func uploadButtonTapped(_ sender: AnyObject) {
        handleUploadButtonTapped()
    }
    
    //MARK: - UIVIewControllerDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(themeBackView3)

        MainLabel.text = "Режим обновления".localized(code)
        view.addSubview(MainLabel)
        view.addSubview(backView)
        view.addSubview(bgImage)

        backView.addTapGesture{
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
        }
//        self.verticalLabel.transform = CGAffineTransform(translationX: -(verticalLabel.frame.width/2) + (verticalLabel.frame.height / 2), y: 0.0).rotated(by: -.pi / 2)
        
        if isImportingFile {
            isImportingFile = false
            self.onFileSelected(withURL: selectedFileURL!)
        }

//        self.dfuLibraryVersionLabel.text = "DFU Library version \(AppUtilities.iOSDFULibraryVersion)"
        setupTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //if DFU peripheral is connected and user press Back button then disconnect it
        if self.isMovingFromParent && dfuController != nil {
            let aborted = dfuController?.abort()
            if aborted! == false {
                logWith(.application, message: "Процесс обновления прерван")
            }
        }
    }

    //MARK: - ScannerDelegate
    func centralManagerDidSelectPeripheral(withManager aManager: CBCentralManager, andPeripheral aPeripheral: CBPeripheral) {
        selectedPeripheral = aPeripheral
        centralManager = aManager
        deviceName.text = aPeripheral.name
        progressLabel.text = nil
        self.updateUploadButtonState()
    }

    //MARK: - FileSelectionDelegate
    func onFileImported(withURL aFileURL: URL){
        selectedFileURL = aFileURL
        self.isImportingFile = true
    }

    func onFileSelected(withURL aFileURL: URL) {
        selectedFileURL = aFileURL
        selectedFirmware = nil
        fileName.text = nil
        fileSize.text = nil
//        fileType.text = nil

        let fileNameExtension = aFileURL.pathExtension.lowercased()
        
        if fileNameExtension == "zip" {
            selectedFirmware = DFUFirmware(urlToZipFile: aFileURL)
            var appPresent         = false
            var softDevicePresent  = false
            var bootloaderPresent  = false
            if let appSize = selectedFirmware?.size.application {
                if appSize > 0 {
                    appPresent = true
                }
            }
            if let sdSize = selectedFirmware?.size.softdevice {
                if sdSize > 0 {
                    softDevicePresent = true
                }
            }
            if let blSize = selectedFirmware?.size.bootloader {
                if blSize > 0 {
                    bootloaderPresent = true
                }
            }
            
            if bootloaderPresent && softDevicePresent && appPresent {
                showFirmwarePartSelectionAlert(withChoices: [.softdeviceBootloaderApplication, .softdeviceBootloader, .application])
                return
            } else {
                updateViewForSelectedDistributionPacketWithType(aType: .softdeviceBootloaderApplication, andFileURL: aFileURL)
            }
        } else {
            showFileTypeSelectionAlert()
        }

    }

    func updateViewForSelectedDistributionPacketWithType(aType: DFUFirmwareType, andFileURL aFileURL: URL) {
        selectedFirmware = DFUFirmware(urlToZipFile: aFileURL, type: aType)
        if selectedFirmware != nil && selectedFirmware?.fileName != nil {
            fileName.text = selectedFirmware?.fileName
            let content = try? Data(contentsOf: aFileURL)
            fileSize.text = String(format: "%lu" + " байтов", (content?.count)!)
//            fileType.text = "Distribution packet"
        } else {
            selectedFirmware = nil
            selectedFileURL  = nil
            DFUConstantsUtility.showAlert(message: "Выбранный файл не поддерживается", from: self)
        }
        self.updateUploadButtonState()
    }

    func showFileTypeSelectionAlert() {
        let fileTypeAlert = UIAlertController(title: "Firmware type", message: "Please select the firmware type.", preferredStyle: .actionSheet)
        fileTypeAlert.popoverPresentationController?.sourceView = selectFileButton
        fileTypeAlert.popoverPresentationController?.sourceRect = selectFileButton.bounds
        let softdeviceAction = UIAlertAction(title: "Softdevice", style: .default) { (anAction) in
            self.didSelectFirmwareType(.softdevice)
        }
        
        let bootloaderAction = UIAlertAction(title: "Bootloader", style: .default) { (anAction) in
            self.didSelectFirmwareType(.bootloader)
        }
        
        let applicationAction = UIAlertAction(title: "Application", style: .default) { (anAction) in
            self.didSelectFirmwareType(.application)
        }
        
        let softdeviceBootloaderAction = UIAlertAction(title: "Softdevice + Bootloader", style: .default) { (anAction) in
            self.didSelectFirmwareType(.softdeviceBootloader)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { (anAction) in
            DispatchQueue.main.async {
                self.selectedFileURL = nil
                self.updateUploadButtonState()
                self.progressLabel.text = nil
            }
        }
        
        fileTypeAlert.addAction(applicationAction)
        fileTypeAlert.addAction(softdeviceAction)
        fileTypeAlert.addAction(bootloaderAction)
        fileTypeAlert.addAction(softdeviceBootloaderAction)
        fileTypeAlert.addAction(cancelAction)
        
        present(fileTypeAlert, animated: true, completion: nil)
    }

    func showFirmwarePartSelectionAlert(withChoices choices: [DFUFirmwareType]) {
        let firmwarePartAlert = UIAlertController(title: "Scope", message: "Please select the component(s) to be uploaded.", preferredStyle: .actionSheet)
        firmwarePartAlert.popoverPresentationController?.sourceView = selectFileButton
        firmwarePartAlert.popoverPresentationController?.sourceRect = selectFileButton.bounds
        for aChoice in choices {
            let choiceAction = UIAlertAction(title: firmwarePartToString(aChoice), style: .default, handler: { (alertAction) in
                self.didSelectFirmwarePart(aChoice)
            })
            firmwarePartAlert.addAction(choiceAction)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel) { (anAction) in
            DispatchQueue.main.async {
                self.selectedFirmware = nil
                self.selectedFileURL = nil
                self.updateUploadButtonState()
                self.progressLabel.text = nil
            }
        }
        firmwarePartAlert.addAction(cancelAction)
        present(firmwarePartAlert, animated: true, completion: nil)
    }

    func didSelectFirmwarePart(_ aPart: DFUFirmwareType) {
        if let selectedFileURL = selectedFileURL {
            updateViewForSelectedDistributionPacketWithType(aType: aPart, andFileURL: selectedFileURL)
        } else {
            print("No file selected")
        }
    }

    func didSelectFirmwareType(_ aFileType: DFUFirmwareType) {
        selectedFirmware = DFUFirmware(urlToBinOrHexFile: selectedFileURL!, urlToDatFile: nil, type: aFileType)
        print(selectedFirmware?.fileUrl ?? "None")
        if selectedFirmware != nil && selectedFirmware?.fileName != nil {
            fileName.text = selectedFirmware?.fileName
            let content = try? Data(contentsOf: selectedFileURL!)
            fileSize.text = String(format: "%d" + "байтов", (content?.count)!)
            DispatchQueue.main.async {
//                self.fileType.text = self.firmwareTypeToString(aFileType)
            }
        } else {
            selectedFileURL = nil
            DFUConstantsUtility.showAlert(message: "Выбранный файл не поддерживается", from: self)
        }
        DispatchQueue.main.async {
            self.progressLabel.text = nil
            self.updateUploadButtonState()
        }
    }

    func firmwareTypeToString(_ aType: DFUFirmwareType) -> String {
        switch  aType {
            case .application:
                return "Application"
            
            case .bootloader:
                return "Bootloader"
            
            case .softdevice:
                return "SoftDevice"
            
            case .softdeviceBootloader:
                return "SD + BL"
            
            case .softdeviceBootloaderApplication:
                return "APP + SD + BL"
        }
    }
    
    func firmwarePartToString(_ aType: DFUFirmwareType) -> String {
        switch  aType {
        case .application:
            return "Application only"
            
        case .bootloader:
            return "Bootloader only"
            
        case .softdevice:
            return "SoftDevice only"
            
        case .softdeviceBootloader:
            return "System components only"
            
        case .softdeviceBootloaderApplication:
            return "All"
        }
    }

    //MARK: - LoggerDelegate
    func logWith(_ level:LogLevel, message:String){
        print("\(level.name()): \(message)")
    }

    //MARK: - DFUServiceDelegate
    func dfuStateDidChange(to state: DFUState) {
        switch state {
        case .connecting:
            uploadStatus.text = "Подключение..."
        case .starting:
            uploadStatus.text = "Подготовка DFU..."
        case .enablingDfuMode:
            uploadStatus.text = "Enabling DFU Bootloader..."
        case .uploading:
            uploadStatus.text = "Загрузка..."
        case .validating:
            uploadStatus.text = "Проверка..."
        case .disconnecting:
            uploadStatus.text = "Отключение..."
        case .completed:
            DFUConstantsUtility.showAlert(message: "Загрузка успешна", from: self)
            if DFUConstantsUtility.isApplicationStateInactiveOrBackgrounded() {
                DFUConstantsUtility.showBackgroundNotification(message: "Загрузка успешна")
            }
            self.clearUI()
        case .aborted:
            DFUConstantsUtility.showAlert(message: "Загрузка прервана", from: self)
            if DFUConstantsUtility.isApplicationStateInactiveOrBackgrounded(){
                DFUConstantsUtility.showBackgroundNotification(message: "Загрузка прервана")
            }
            self.clearUI()
        }
    }

    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        if DFUConstantsUtility.isApplicationStateInactiveOrBackgrounded() {
            DFUConstantsUtility.showBackgroundNotification(message: message)
        }
        clearUI()
        DispatchQueue.main.async {
            self.progressLabel.text = "Ошибка: \(message)"
            self.progressLabel.isHidden = false
        }
    }

    //MARK: - DFUProgressDelegate
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        self.progress.setProgress(Float(progress) / 100.0, animated: true)
        progressLabel.text = String("\(progress)% (\(part)/\(totalParts))")
    }
    
    //MARK: - Segue Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if (segue.identifier == "scan") {
                // Set this contoller as scanner delegate
                let aNavigationController = segue.destination as? UINavigationController
                let scannerViewController = aNavigationController?.children.first as? ScannerViewController
                scannerViewController?.delegate = self
                
            } else if segue.identifier == "FileSegue" {
                let aNavigationController = segue.destination as? UINavigationController
                let barViewController = aNavigationController?.children.first as? UITabBarController
//                barViewController?.title = "1000"
//                let appFilecsVC = barViewController?.viewControllers?.last as? AppFilesViewController
//                appFilecsVC?.fileDelegate = self
                let userFilesVC = barViewController?.viewControllers?.first as? UserFilesViewController
                userFilesVC?.fileDelegate = self
                
                if selectedFileURL != nil {
//                    appFilecsVC?.selectedPath = selectedFileURL
                    userFilesVC?.selectedPath = selectedFileURL
                }
            }
    }
    
    //MARK: - DFUViewController implementation
    func handleAboutButtonTapped() {
        self.showAbout(message: DFUConstantsUtility.getDFUHelpText())
    }
    
    func handleUploadButtonTapped() {
        guard dfuController != nil else {
            self.performDFU()
            return
        }
        
        // Pause the upload process. Pausing is possible only during upload, so if the device was still connecting or sending some metadata it will continue to do so,
        // but it will pause just before seding the data.
        dfuController?.pause()
        
        let alert = UIAlertController(title: "Внимание", message: "Хотите завершить?", preferredStyle: .alert)
        let abort = UIAlertAction(title: "Завершить", style: .destructive, handler: { (anAction) in
            _ = self.dfuController?.abort()
            alert.dismiss(animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "Отмена", style: .default, handler: { (anAction) in
            self.dfuController?.resume()
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(abort)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }

    func registerObservers() {
        if UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert], categories: nil))
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidEnterBackgroundCallback), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActiveCallback), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc func applicationDidEnterBackgroundCallback() {
        if dfuController != nil {
            DFUConstantsUtility.showBackgroundNotification(message: "Загрузка fireware...")
        }
    }

    @objc func applicationDidBecomeActiveCallback() {
        UIApplication.shared.cancelAllLocalNotifications()
    }

    func updateUploadButtonState() {
        uploadButton.isEnabled = selectedFirmware != nil && selectedPeripheral != nil
    }

    func disableOtherButtons() {
        selectFileButton.isEnabled = false
        connectButton.isEnabled = false
    }

    func enableOtherButtons() {
        selectFileButton.isEnabled = true
        connectButton.isEnabled = true
    }

    func clearUI() {
        DispatchQueue.main.async {
            self.dfuController          = nil
            self.selectedPeripheral     = nil
            
            self.deviceName.text        = "DFU устройство"
            self.uploadStatus.text      = nil
            self.uploadStatus.isHidden  = true
            self.progress.progress      = 0.0
            self.progress.isHidden      = true
            self.progressLabel.text     = nil
            self.progressLabel.isHidden = true
            
            self.uploadButton.setTitle("Начать обновление прошивки", for: .normal)
            self.updateUploadButtonState()
            self.enableOtherButtons()
            self.removeObservers()
        }
    }

    func performDFU() {
        self.disableOtherButtons()
        progress.isHidden = false
        progressLabel.text = nil
        progressLabel.isHidden = false
        uploadStatus.isHidden = false
        uploadButton.isEnabled = false

        self.registerObservers()
        
        // To start the DFU operation the DFUServiceInitiator must be used
        let initiator = DFUServiceInitiator()
        initiator.forceDfu = UserDefaults.standard.bool(forKey: "dfu_force_dfu")
        initiator.packetReceiptNotificationParameter = UInt16(UserDefaults.standard.integer(forKey: "dfu_number_of_packets"))
        initiator.logger = self
        initiator.delegate = self
        initiator.progressDelegate = self
        initiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = true
        dfuController = initiator.with(firmware: selectedFirmware!).start(target: selectedPeripheral!)
        uploadButton.setTitle("Отменить", for: .normal)
        uploadButton.isEnabled = true
    }
    
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            themeBackView3.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            MainLabel.theme.textColor = themed{ $0.navigationTintColor }
            backView.theme.tintColor = themed{ $0.navigationTintColor }
            viewAction.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xF7F7F7)
            uploadPane.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xF7F7F7)
            deviceName.theme.textColor = themed{ $0.navigationTintColor }
            fileName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            fileSize.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelDevice.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            deviceNaming.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            fileNaming.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelSize.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            uploadStatus.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            progressLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            themeBackView3.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            MainLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            backView.tintColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            viewAction.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xF7F7F7)
            uploadPane.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xF7F7F7)
            deviceName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            fileName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            fileSize.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelName.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelDevice.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            deviceNaming.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            fileNaming.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelSize.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            uploadStatus.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            progressLabel.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}
