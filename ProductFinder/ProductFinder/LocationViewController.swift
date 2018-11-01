//
//  LocationViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 10/31/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController{
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        setupNavigationBar()
    }
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    func setupNavigationBar(){
        searchBar.placeholder = "Search"
        for subView in searchBar.subviews {
            for subViewInSubView in subView.subviews {
                if let textField = subViewInSubView as? UITextField {
                    subViewInSubView.backgroundColor = UIColor(displayP3Red: 230.0/255, green: 232.0/255, blue:237.0/255, alpha: 1.0)
                    
                    let textFieldInsideUISearchBarLabel = textField.value(forKey: "placeholderLabel") as? UILabel
                    textFieldInsideUISearchBarLabel?.textColor = UIColor.black
                }
                
                
            }
        }
        navigationItem.titleView = searchBar
    }
    
}
