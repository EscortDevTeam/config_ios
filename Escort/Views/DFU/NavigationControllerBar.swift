//
//  NavigationControllerBar.swift
//  Escort
//
//  Created by Володя Зверев on 09.04.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class NavigationControllerBar: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
        print("13213kdsvdsvbdsv")
    }
    
    func customizeNavigationBar() {
        navigationItem.setLeftBarButton(.init(barButtonSystemItem: .cancel, target: nil, action: nil), animated: true)
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .done, target: nil, action: nil), animated: true)

        let navBarAppearance = UINavigationBarAppearance()

        // Call this first otherwise it will override your customizations
        navBarAppearance.configureWithDefaultBackground()

        let buttonAppearance = UIBarButtonItemAppearance()
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.systemGray]
        buttonAppearance.normal.titleTextAttributes = titleTextAttributes

        navBarAppearance.titleTextAttributes = [
            .foregroundColor : UIColor.purple, // Navigation bar title color
            .font : UIFont.italicSystemFont(ofSize: 17) // Navigation bar title font
        ]

        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor : UIColor.systemBlue, // Navigation bar title color
        ]

        // appearance.backgroundColor = UIColor.systemGray // Navigation bar bg color
        // appearance.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 8) // Only works on non large title

        let transNavBarAppearance = navBarAppearance.copy()
        transNavBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = transNavBarAppearance

        title = "Title"

        navigationController?.navigationBar.prefersLargeTitles = true // Activate large title
    }
}
