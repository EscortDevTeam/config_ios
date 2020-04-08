//
//  UserFilesViewController.swift
//  Escort
//
//  Created by Володя Зверев on 07.04.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

class UserFilesViewController: UIViewController, FilePreselectionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Class properties
    var fileDelegate : FileSelectionDelegate?
    var selectedPath : URL?
    var files        : [URL]!
    var documentsDirectoryPath : String?
    
    //MARK: - View Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!

    //MARK: - UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        files = [URL]()
        let fileManager = FileManager.default
        let documentsURL = URL(string: documentsDirectoryPath!)

        do {
            try files = fileManager.contentsOfDirectory(at: documentsURL!, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
        } catch {
            print("Error \(error)")
        }
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButtonTapped))
        tabBarController?.navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelButtonTapped))
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        let buttonEnabled = selectedPath != nil
//        tabBarController!.navigationItem.rightBarButtonItem!.isEnabled = buttonEnabled
        tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
        if selectedPath == nil {
            tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        tableView.reloadData()
        ensureDirectoryNotEmpty()
    }
    
    //MARK: - UserFilesViewController
    func ensureDirectoryNotEmpty() {
        if files.count == 0 {
            emptyView.isHidden = false
        }
    }
    //MARK: - AppFilesViewController implementation
    @objc func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
        fileDelegate?.onFileSelected(withURL: self.selectedPath!)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    //MARK: - FilePreselectionDelegate
    func onFilePreselected(withURL aFileURL: URL) {
        selectedPath = aFileURL
        tableView.reloadData()
        tabBarController!.navigationItem.rightBarButtonItem!.isEnabled = true

        let appFilesVC = tabBarController?.viewControllers?.first as? AppFilesViewController
        appFilesVC?.selectedPath = selectedPath
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count //Increment one for the tutorial on first row
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ensureDirectoryNotEmpty()  //Always check if the table is emtpy

        // File row
        let aCell = tableView.dequeueReusableCell(withIdentifier: "UserFilesCell", for: indexPath)

        // Configure the cell...
        let filePath = files[indexPath.row]
        print("LOLOLO: \(filePath)")
        let fileName = filePath.lastPathComponent
        
        aCell.textLabel?.text = fileName
        aCell.accessoryType = .none
        
        var isDirectory : ObjCBool = false
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath.relativePath, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                aCell.accessoryType = .disclosureIndicator
                if fileName.lowercased() == "inbox" {
                    aCell.textLabel?.text = "Сохраненные прошивки"
                    aCell.imageView?.image = UIImage(named: "ic_email")
                } else {
                    aCell.imageView?.image = UIImage(named: "ic_folder")
                }
            } else if fileName.lowercased().contains(".hex") {
                aCell.imageView!.image = UIImage(named: "ic_file")
            } else if fileName.lowercased().contains("bin") {
                aCell.imageView!.image = UIImage(named: "ic_file")
            } else if fileName.lowercased().contains(".zip") {
                aCell.imageView!.image = UIImage(named: "ic_archive")
            }
        } else {
            DFUConstantsUtility.showAlert(message: "File does not exist!", from: self)
        }

        if filePath == selectedPath {
            aCell.accessoryType = .checkmark
        }
        return aCell;
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tabBarController?.navigationItem.rightBarButtonItem?.isEnabled = true
        // Normal row
        let filePath = files[indexPath.row ]
        
        var isDirectory : ObjCBool = false
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath.relativePath, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                performSegue(withIdentifier: "OpenFolder", sender: indexPath)
            } else {
                onFilePreselected(withURL: filePath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row > 0 {
            // Inbox folder can't be deleted
            let filePath = files[indexPath.row - 1]
            let fileName = filePath.lastPathComponent
            
            if fileName.lowercased() == "inbox" {
                return .none
            } else {
                return .delete
            }
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let filePath = files[indexPath.row - 1]
            
            do {
                try FileManager.default.removeItem(at: filePath)
                files.remove(at: indexPath.row - 1)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                if filePath == selectedPath {
                    onFilePreselected(withURL: selectedPath!)
                }
            } catch {
                print("An error occured while deleting file\(error)")
            }
        }
    }
    
    //MARK: - Segue navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenFolder" {
            let selectionIndexPath = sender as! IndexPath
            let filePath = files[selectionIndexPath.row]
            let fileName = filePath.lastPathComponent

            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath.relativePath) {
                let folderVC = segue.destination as? FolderFilesViewController
                folderVC?.directoryPath = filePath.absoluteString
                folderVC?.directoryName = fileName
                folderVC?.fileDelegate = fileDelegate!
                folderVC?.preselectionDelegate = self
                folderVC?.selectedPath = filePath
            } else {
                DFUConstantsUtility.showAlert(message: "File does not exist!", from: self)
            }
        }
    }

}
