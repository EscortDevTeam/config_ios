//
//  MainVCNavController.swift
//  Escort
//
//  Created by Володя Зверев on 20.12.2019.
//  Copyright © 2019 pavit.design. All rights reserved.
//
import UIKit

class MainVCNavController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatusBar), name: NSNotification.Name(rawValue: "updateStatusBar"), object: nil)
    }
    
    let statusBarHidden: Bool = false
    
    @objc func updateStatusBar() {
        self.setNeedsStatusBarAppearanceUpdate() // this gets called when the notification is triggered
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden // this doesn't get called after setNeedsStatusBarAppearanceUpdate() is called
    }
    
    // I added this just to see if it would make a difference but it didn't
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    override open var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
