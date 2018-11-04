//
//  ProductInfoViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 11/3/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit

class ProductInfoViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.view.subviews.count == 0{
            setupNavigationBar()
            setupProductDetailView()
        }
    }
    
    var detailImageView = UIImageView()
    var detailLabel = UILabel()
    var locatorButton = UIButton()
    var currentProduct = Product()
    
    func setupNavigationBar(){
        navigationItem.title = "Details"
        
        let uploadBarButton = UIBarButtonItem(image: UIImage(named: "upload")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        
        let shoppingCartBarButton = UIBarButtonItem(image: UIImage(named: "shopping_cart")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [shoppingCartBarButton, uploadBarButton]
    }
    
    func setupProductDetailView(){
        let whiteView = UIView(frame: CGRect(x: 5.0, y: 5.0, width: UIScreen.main.bounds.width-10.0, height: UIScreen.main.bounds.height-10.0))
        whiteView.backgroundColor = UIColor.white
        
        self.detailLabel.frame = CGRect(x: 1.0, y: 5.0, width: view.frame.width/2.0, height: view.frame.height/10.0)
        //self.detailLabel.text = "Barrryknoll Chesterfield Settee"
        self.detailLabel.textColor = UIColor.black
        self.detailLabel.font = UIFont.systemFont(ofSize: 20)
        self.detailLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.detailLabel.numberOfLines = 2
        self.detailLabel.textAlignment = NSTextAlignment.left
        
        self.detailImageView.frame = CGRect(x: 0.0, y: view.frame.height/5.0, width: (4.0*view.frame.width)/5.0, height: view.frame.height/2.0)
        self.detailImageView.center.x = view.center.x
        //self.detailImageView.backgroundColor = UIColor.black
        
        self.locatorButton.frame = CGRect(x: 0.0, y: (4*view.frame.height)/5.0, width: view.frame.width/2.0, height: view.frame.height/10.0)
        self.locatorButton.addTarget(self, action: #selector(navigateToLocations), for: .touchUpInside)
        self.locatorButton.isEnabled = true
        self.locatorButton.isUserInteractionEnabled = true
        self.locatorButton.center.x = view.center.x
        self.locatorButton.setTitle("Locate It", for: UIControl.State.normal)
        self.locatorButton.setTitleColor(UIColor(displayP3Red: 0.0, green: 173.0/255, blue: 181.0/255, alpha: 1.0), for: UIControl.State.normal)
        //self.locatorButton.clipsToBounds = true
        
        whiteView.addSubview(detailLabel)
        whiteView.addSubview(detailImageView)
        whiteView.addSubview(locatorButton)
        
        self.view.addSubview(whiteView)
    }
    
    @objc func navigateToLocations(sender: UIButton){
        print("Locate It tapped!")
        let locationController = LocationViewController()
        locationController.currentProductName = currentProduct.getName()
        self.navigationController?.pushViewController(locationController, animated: false)
        //self.tabBarController?.selectedIndex = 2
    }
}
