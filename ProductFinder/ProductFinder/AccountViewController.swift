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
        setUpWelcome()
    }
    
    func setupNavigationBar(){
        navigationItem.title = "Account"
        
        let shoppingCartBarButton = UIBarButtonItem(image: UIImage(named: "shopping_cart")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        shoppingCartBarButton.action = #selector(goToCart)
        
        navigationItem.rightBarButtonItem = shoppingCartBarButton
    }
    
    func setUpWelcome(){
        let welcomeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2.0))
        welcomeLabel.center.y = self.view.center.y-(self.navigationController?.navigationBar.frame.height)!
        welcomeLabel.textAlignment = .center
        if(UserDefaults.standard.value(forKey: "username") != nil){
            welcomeLabel.text = "Welcome Back " + (UserDefaults.standard.value(forKey: "username") as! String) + "!"
        }else{
            welcomeLabel.text = "Welcome Back!"
        }
        welcomeLabel.textColor = UIColor(displayP3Red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
        welcomeLabel.font = UIFont(name: "AmericanTypewriter", size: 25.0)
        self.view.addSubview(welcomeLabel)
    }
    
    @objc func goToCart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cartNav = storyboard.instantiateViewController(withIdentifier: "CartNav")
        self.present(cartNav, animated: true, completion: nil)
    }
}
