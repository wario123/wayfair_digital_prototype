//
//  AccountViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 10/31/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 34.0/355, green: 40.0/255, blue: 49.0/255, alpha: 1.0)
        setupNavigationBar()
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Account"
        
        let shoppingCartBarButton = UIBarButtonItem(image: UIImage(named: "shopping_cart")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        
        navigationItem.rightBarButtonItem = shoppingCartBarButton
    }
    
    
}
