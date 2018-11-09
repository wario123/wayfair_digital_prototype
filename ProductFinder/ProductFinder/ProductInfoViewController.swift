//
//  ProductInfoViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 11/3/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

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
        
        self.view.backgroundColor = UIColor.white
        //whiteView.backgroundColor = UIColor.white
        
        self.detailLabel.frame = CGRect(x: 5.0, y: 5.0, width: view.frame.width/2.0, height: view.frame.height/10.0)
        self.detailLabel.textColor = UIColor.black
        self.detailLabel.font = UIFont.systemFont(ofSize: 20)
        self.detailLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.detailLabel.numberOfLines = 2
        self.detailLabel.textAlignment = NSTextAlignment.left
        
        let sellerLabel1 = UILabel()
        sellerLabel1.text = "Sold by "
        sellerLabel1.textColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        sellerLabel1.frame = CGRect(x: 5.0, y: self.detailLabel.frame.maxY+2.0, width: self.view.frame.width/5.0, height: self.view.frame.height/15.0)
        sellerLabel1.sizeToFit()
        view.addSubview(sellerLabel1)
        
        let sellerLabel2 = UILabel()
        sellerLabel2.text = self.currentProduct.getSeller()
        sellerLabel2.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        sellerLabel2.frame = CGRect(x: sellerLabel1.frame.maxX+1.0, y: sellerLabel1.frame.minY, width: self.view.frame.width/5.0, height: self.view.frame.height/15.0)
        sellerLabel2.sizeToFit()
        view.addSubview(sellerLabel2)
        //let sellerLabel = UILabel(frame: CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>))
        
        self.detailImageView.frame = CGRect(x: 0.0, y: sellerLabel1.frame.maxY+5.0, width: view.frame.width, height: view.frame.height/2.0)
        self.detailImageView.center.x = view.center.x
        //self.detailImageView.backgroundColor = UIColor.black
        
        self.locatorButton.frame = CGRect(x: 5.0, y: self.detailImageView.frame.maxY+5.0, width: view.frame.width/2.0-15.0, height: view.frame.height/10.0)
        self.locatorButton.addTarget(self, action: #selector(navigateToLocations), for: .touchUpInside)
        self.locatorButton.isEnabled = true
        self.locatorButton.isUserInteractionEnabled = true
        self.locatorButton.layer.cornerRadius = 10
        self.locatorButton.clipsToBounds = true
        self.locatorButton.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        self.locatorButton.setTitle("Locate It", for: UIControl.State.normal)
        self.locatorButton.setTitleColor(UIColor(displayP3Red: 0.0, green: 173.0/255, blue: 181.0/255, alpha: 1.0), for: UIControl.State.normal)
        //self.locatorButton.clipsToBounds = true
        
        let addToCartButton = UIButton(frame: CGRect(x: self.locatorButton.frame.maxX+5.0, y: self.detailImageView.frame.maxY+5.0, width: view.frame.width/2.0-15.0, height: view.frame.height/10.0))
        //addToCartButton.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
        addToCartButton.isEnabled = true
        addToCartButton.isUserInteractionEnabled = true
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.clipsToBounds = true
        addToCartButton.backgroundColor = UIColor(displayP3Red: 0.0, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        addToCartButton.setTitle("Add To Cart", for: UIControl.State.normal)
        addToCartButton.setTitleColor(UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0), for: UIControl.State.normal)
        
        view.addSubview(detailLabel)
        view.addSubview(detailImageView)
        view.addSubview(locatorButton)
        view.addSubview(addToCartButton)
        
        addToCartButton.anchor(top: detailImageView.bottomAnchor, left: locatorButton.rightAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 0, paddingRight: 5.0, width: 0, height: self.view.frame.height/10.0)
        
        locatorButton.anchor(top: detailImageView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: addToCartButton.leftAnchor, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 0, paddingRight: 5.0, width: addToCartButton.frame.width, height: self.view.frame.height/10.0)
        
        let priceLabel = UILabel()
        priceLabel.textColor = UIColor(displayP3Red: 34.0/255, green: 40.0/255, blue: 49.0/255, alpha: 1.0)
        priceLabel.text = "$" + String(currentProduct.getPrice())
        priceLabel.frame = CGRect(x: 15.0, y: locatorButton.frame.maxY+20.0, width: self.view.frame.width/2.0, height: self.view.frame.height/10.0)
        priceLabel.font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir-Heavy"]), size: CGFloat(25.0))
        priceLabel.sizeToFit()
        self.view.addSubview(priceLabel)
        
        let freeShippingLabel = UILabel()
        freeShippingLabel.textColor = UIColor(displayP3Red: 34.0/255, green: 40.0/255, blue: 49.0/255, alpha: 1.0)
        freeShippingLabel.text = "FREE Shipping"
        freeShippingLabel.frame = CGRect(x: 15.0, y: priceLabel.frame.maxY+20.0, width: self.view.frame.width/2.0, height: self.view.frame.height/10.0)
        freeShippingLabel.font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: "Avenir-Heavy"]), size: CGFloat(20.0))
        freeShippingLabel.sizeToFit()
        self.view.addSubview(freeShippingLabel)
    }
    
    @objc func navigateToLocations(sender: UIButton){
        print("Locate It tapped!")
        let locationController = LocationViewController()
        locationController.currentProductName = currentProduct.getName()
        self.navigationController?.pushViewController(locationController, animated: false)
        //self.tabBarController?.selectedIndex = 2
    }
    
    /*@objc func addToCart(sender: UIButton){
        let databaseRef = Database.database().reference()
        let currentUID = Auth.auth().currentUser?.uid
        databaseRef.child("users/"+currentUID!+"/cart")({
            
        })
    }*/
}
