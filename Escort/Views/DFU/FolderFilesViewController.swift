//
//  FolderFilesViewController.swift
//  Escort
//
//  Created by Володя Зверев on 07.04.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

class FolderFilesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Class Properties
    var files                   : [URL]?
    var directoryPath           : String?
    var directoryName           : String?
    var fileDelegate            : FileSelectionDelegate?
    var preselectionDelegate    : FilePreselectionDelegate?
    var selectedPath            : URL?
    
    //MARK: - View Outlets
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelInfo: UILabel!
    
    //MARK: - View Actions
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        doneButtonTappedEventHandler()
    }
    
    fileprivate lazy var bgImage: UIImageView = {
        let img = UIImageView(image: UIImage(named: "bg-figures.png")!)
        img.frame = CGRect(x: 0, y: screenHeight-260, width: 201, height: 207)
        img.alpha = 0.3
        return img
    }()
    
    //MARK: - UIViewDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bgImage)
        if directoryName != nil {
            self.navigationItem.title = directoryName!
        } else {
            self.navigationItem.title = "Files"
        }
        setupTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let enabled = (selectedPath != nil)
        self.navigationItem.rightBarButtonItem?.isEnabled = enabled
        do {
            try self.files = FileManager.default.contentsOfDirectory(at: selectedPath!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        } catch {
            print(error)
        }
        self.ensureDirectoryNotEmpty()
        
        let label = UILabel()
        label.text = "Архивы"
        label.textColor = .red
        label.font = UIFont(name:"FuturaPT-Medium", size: 25.0)
        label.sizeToFit()
        navigationItem.titleView = label
    }

    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (files?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "FolderFilesCell", for:indexPath)
        let aFilePath = files?[indexPath.row]
        let fileName = aFilePath?.lastPathComponent
        
        //Configuring the cell
        aCell.textLabel?.text = fileName
        aCell.textLabel?.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        if fileName?.lowercased().contains(".hex") != false {
            aCell.imageView?.image = UIImage(named: "ic_file")
        } else if fileName?.lowercased().contains(".bin") != false {
            aCell.imageView?.image = UIImage(named: "ic_file")
        } else if fileName?.lowercased().contains(".zip") != false {
            aCell.imageView?.image = UIImage(named: "ic_archive")
        } else {
            aCell.imageView?.image = UIImage(named: "ic_file")
        }
        
        if aFilePath == selectedPath {
            aCell.accessoryType = .checkmark
            aCell.tintColor = UIColor.red
        } else {
            aCell.accessoryType = .none
        }
        
        return aCell
    }

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filePath = files?[indexPath.row]
        selectedPath = filePath
        tableView.reloadData()
        navigationItem.rightBarButtonItem!.isEnabled = true
        self.preselectionDelegate?.onFilePreselected(withURL: filePath!)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }

        let filePath = files?[indexPath.row]
        do {
            try FileManager.default.removeItem(at: filePath!)
        } catch {
            print("Error while deleting file: \(error)")
            return
        }

        files?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    
        if filePath == selectedPath {
            selectedPath = nil
            self.preselectionDelegate?.onFilePreselected(withURL: filePath!)
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }

        self.ensureDirectoryNotEmpty()

    }
    //MARK: - FolderFilesViewController Implementation
    func ensureDirectoryNotEmpty() {
        if (files?.count)! == 0 {
            emptyView.isHidden = false
        }
    }

    func doneButtonTappedEventHandler(){
        // Go back to DFUViewController
        dismiss(animated: true) {
            self.fileDelegate?.onFileSelected(withURL: self.selectedPath!)
        }
    }
    fileprivate func setupTheme() {
        if #available(iOS 13.0, *) {
            view.theme.backgroundColor = themed { $0.backgroundColor }
            tableView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            emptyView.theme.backgroundColor = themed { $0.backgroundNavigationColor }
            tableView.separatorColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelInfo.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        } else {
            view.backgroundColor = UIColor(rgb: isNight ? 0x1F2222 : 0xFFFFFF)
            tableView.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            emptyView.backgroundColor = UIColor(rgb: isNight ? 0x272727 : 0xFFFFFF)
            tableView.separatorColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
            labelInfo.textColor = UIColor(rgb: isNight ? 0xFFFFFF : 0x1F1F1F)
        }
    }
}
