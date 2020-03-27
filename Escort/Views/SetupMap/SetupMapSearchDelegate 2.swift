//
//  SetupMapSearchDelegate.swift
//  Escort
//
//  Created by Володя Зверев on 13.03.2020.
//  Copyright © 2020 pavit.design. All rights reserved.
//

import UIKit

extension SetupMap: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }
    
}
