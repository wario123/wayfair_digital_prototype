//
//  ShopViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 10/31/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

protocol CategoryDelegate {
    func didSelectCategory(_ name: String)
}

class ShopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        //self.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        print("current user ID = \(String(describing: Auth.auth().currentUser?.uid))")
        if self.currentProductImages.count > 4{
            self.currentProductImages.removeAll()
        }
        DispatchQueue.main.async {
            self.loadProducts {
                self.collectionView.reloadData()
            }
        }
    }
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    var currentProducts = [Product]()
    var currentProductImages = [UIImage]()
    let itemCellId = "itemCell"
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        
        searchBar.text = "Furniture"
        searchBar.isUserInteractionEnabled = false
        navigationItem.titleView = searchBar
        
        let cameraBarButton = UIBarButtonItem(image: UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        
        let shoppingCartBarButton = UIBarButtonItem(image: UIImage(named: "shopping_cart")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        shoppingCartBarButton.action = #selector(goToCart)
        
        navigationItem.rightBarButtonItems = [shoppingCartBarButton, cameraBarButton]
        
        //Setting up our collection view and its intended layout
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2.0-15.0, height: 315.0)
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height), collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.93, alpha:1)
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: itemCellId)
        self.view.addSubview(collectionView)
    }
    
    @objc func goToCart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cartNav = storyboard.instantiateViewController(withIdentifier: "CartNav")
        self.present(cartNav, animated: true, completion: nil)
    }
    
    func loadProducts(completion: @escaping ()->()){
        currentProducts = [Product]()
        let ref: DatabaseReference = Database.database().reference()
        
        ref.child("furniture").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for (productName, productInfo) in value ?? [:]{
                let currentSeller = (productInfo as? NSDictionary)!["Seller"]
                let currentType = (productInfo as? NSDictionary)!["Type"]
                let currentPrice = (productInfo as? NSDictionary)!["Price"]
                let starRating = (productInfo as? NSDictionary)!["Star_Rating"]
                let latitude = (productInfo as? NSDictionary)!["Latitude"]
                let longitude = (productInfo as? NSDictionary)!["Longitude"]
                let product = Product(productName: productName as! String, productSeller: currentSeller as! String, productType: currentType as! String, productPrice: currentPrice as! Double, productRating: starRating as! Double, productLatitude: latitude as! Double, productLongitude: longitude as! Double)
                
                self.currentProducts.append(product)
            }
            print(self.currentProducts.count)
            print(self.currentProductImages.count)
            // ...
            completion()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentProducts.count
    }
    
    //let imageCache = NSCache<AnyObject, UIImage>()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellId, for: indexPath) as! ItemCell
        let currentProduct: Product = currentProducts[indexPath.row]
        
        cell.nameLabel.textColor = UIColor.black
        cell.nameLabel.lineBreakMode = .byWordWrapping
        cell.nameLabel.numberOfLines = 0
        let nameContent = currentProduct.getName()
        let nameString = NSMutableAttributedString(string: nameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 15)!
            ])
        let nameRange = NSRange(location: 0, length: nameString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        nameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: nameRange)
        nameString.addAttribute(NSAttributedString.Key.kern, value: 0.56, range: nameRange)
        cell.nameLabel.attributedText = nameString
        cell.nameLabel.sizeToFit()
        
        cell.sellerLabel.lineBreakMode = .byWordWrapping
        cell.sellerLabel.numberOfLines = 0
        cell.sellerLabel.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)
        let sellerContent =  "by \(currentProduct.getSeller())"
        let sellerString = NSMutableAttributedString(string: sellerContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 15)!
            ])
        let sellerNameRange = NSRange(location: 0, length: sellerString.length)
        sellerString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: sellerNameRange)
        sellerString.addAttribute(NSAttributedString.Key.kern, value: 0.56, range: sellerNameRange)
        cell.sellerLabel.attributedText = sellerString
        cell.sellerLabel.sizeToFit()
        
        
        cell.priceLabel.lineBreakMode = .byWordWrapping
        cell.priceLabel.numberOfLines = 0
        cell.priceLabel.textColor = UIColor(red:0.82, green:0.01, blue:0.11, alpha:1)
        let priceContent = "$\(currentProduct.getPrice())"
        let priceString = NSMutableAttributedString(string: priceContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 20)!
            ])
        let priceRange = NSRange(location: 0, length: priceString.length)
        priceString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: priceRange)
        priceString.addAttribute(NSAttributedString.Key.kern, value: 0.56, range: priceRange)
        cell.priceLabel.attributedText = priceString
        cell.priceLabel.sizeToFit()
        
        //let storageRef = Storage.storage().reference()
        let imageName = currentProduct.getName().lowercased().replacingOccurrences(of: " ", with: "") + ".png"
        cell.itemImageView.image = UIImage(named: imageName)
        currentProductImages.append(UIImage(named: imageName)!)
        
        if currentProduct.getRating() >= 1.0{
            cell.star1.image = UIImage(named: "filled_star")
        }else{
            if currentProduct.getRating() == 0.5{
                cell.star1.image = UIImage(named: "half_star")
            }else{
                cell.star1.image = UIImage(named: "empty_star")
            }
        }
        
        if currentProduct.getRating() >= 2.0{
            cell.star2.image = UIImage(named: "filled_star")
        }else{
            if currentProduct.getRating() == 1.5{
                cell.star2.image = UIImage(named: "half_star")
            }else{
                cell.star2.image = UIImage(named: "empty_star")
            }
        }
        
        if currentProduct.getRating() >= 3.0{
            cell.star3.image = UIImage(named: "filled_star")
        }else{
            if currentProduct.getRating() == 2.5{
                cell.star3.image = UIImage(named: "half_star")
            }else{
                cell.star3.image = UIImage(named: "empty_star")
            }
        }
        
        if currentProduct.getRating() >= 4.0{
            cell.star4.image = UIImage(named: "filled_star")
        }else{
            if currentProduct.getRating() == 3.5{
                cell.star4.image = UIImage(named: "half_star")
            }else{
                cell.star4.image = UIImage(named: "empty_star")
            }
        }
        
        if currentProduct.getRating() == 5.0{
            cell.star5.image = UIImage(named: "filled_star")
        }else{
            if currentProduct.getRating() == 4.5{
                cell.star5.image = UIImage(named: "half_star")
            }else{
                cell.star5.image = UIImage(named: "empty_star")
            }
        }
        
        return cell
        
        /*let currentImageRef = storageRef.child("images/\(imageName)")
        
        if let imageFromCache = imageCache.object(forKey: imageName as AnyObject){
            cell.itemImageView.image = imageFromCache
            self.currentProductImages.append(imageFromCache)
            return cell
        }
        
        currentImageRef.getData(maxSize: 1024 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                image?.accessibilityIdentifier = imageName
                self.imageCache.setObject(image!, forKey: imageName as AnyObject)
                cell.itemImageView.image = image
                if !self.currentProductImages.contains(image!){
                    self.currentProductImages.append(image!)
                }
            }
        }
        
        return cell*/
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productInfoVC = ProductInfoViewController()
        productInfoVC.detailLabel.text = currentProducts[indexPath.row].getName()
        let imageName = currentProducts[indexPath.row].getName().lowercased().replacingOccurrences(of: " ", with: "") + ".png"
        productInfoVC.detailImageView.image = UIImage(named: imageName)
        productInfoVC.currentProduct = currentProducts[indexPath.row]
        self.navigationController?.pushViewController(productInfoVC, animated: false)
    }
    
}

class ItemCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.addSubview(itemImageView)
        self.addSubview(nameLabel)
        self.addSubview(sellerLabel)
        self.addSubview(priceLabel)
        self.addSubview(star1)
        self.addSubview(star2)
        self.addSubview(star3)
        self.addSubview(star4)
        self.addSubview(star5)
        self.addSubview(numberRatings)
        self.addSubview(shippingLabel)
        
        itemImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: self.frame.height/3)
        
        nameLabel.anchor(top:itemImageView.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight:10, width: 0, height: self.frame.height/10)
        
        sellerLabel.anchor(top:nameLabel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight:10, width: 0, height: self.frame.height/10)
        
        priceLabel.anchor(top:sellerLabel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight:10, width: 0, height: self.frame.height/10)
        
        star1.anchor(top: priceLabel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 11.39, height: 10.83)
        
        star2.anchor(top: priceLabel.bottomAnchor, left: star1.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 11.39, height: 10.83)
        
        star3.anchor(top: priceLabel.bottomAnchor, left: star2.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 11.39, height: 10.83)
        
        star4.anchor(top: priceLabel.bottomAnchor, left: star3.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 11.39, height: 10.83)
        
        star5.anchor(top: priceLabel.bottomAnchor, left: star4.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 11.39, height: 10.83)
        
        numberRatings.anchor(top: priceLabel.bottomAnchor, left: star5.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 33.0, height: 12.0)
        
        shippingLabel.anchor(top: star1.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 106.53, height: 17.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet!")
    }
    
    var itemImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let textLayer = UILabel(frame: CGRect(x: 13, y: 365, width: 156.02, height: 28))
        //textLayer.lineBreakMode = .byWordWrapping
        //textLayer.numberOfLines = 0
        return textLayer
    }()
    
    let sellerLabel: UILabel = {
        /*let label = UILabel()
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 2
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.center
        return label*/
        let textLayer = UILabel(frame: CGRect(x: 13.46, y: 401, width: 144.19, height: 14))
        return textLayer
    }()
    
    let priceLabel: UILabel = {
        /*let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.red
        return label*/
        let textLayer = UILabel(frame: CGRect(x: 13, y: 423, width: 73, height: 19))
        return textLayer
        //self.view.addSubview(textLayer)
    }()
    
    let star1: UIImageView = {
        let layer = UIImageView(frame: CGRect(x: 13, y: 449, width: 11.39, height: 10.83))
        layer.image = UIImage(named: "filled_star")
        return layer
    }()
    
    let star2: UIImageView = {
        let layer = UIImageView(frame: CGRect(x: 13, y: 449, width: 11.39, height: 10.83))
        layer.image = UIImage(named: "filled_star")
        return layer
    }()
    
    let star3: UIImageView = {
        let layer = UIImageView(frame: CGRect(x: 13, y: 449, width: 11.39, height: 10.83))
        layer.image = UIImage(named: "filled_star")
        return layer
    }()
    
    let star4: UIImageView = {
        let layer = UIImageView(frame: CGRect(x: 13, y: 449, width: 11.39, height: 10.83))
        layer.image = UIImage(named: "filled_star")
        return layer
    }()
    
    let star5: UIImageView = {
        let layer = UIImageView(frame: CGRect(x: 13, y: 449, width: 11.39, height: 10.83))
        layer.image = UIImage(named: "filled_star")
        return layer
    }()
    
    let numberRatings: UILabel = {
        let textLayer = UILabel(frame: CGRect(x: 77, y: 450, width: 33, height: 12))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)
        let textContent = "4623"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 13)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.96, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        return textLayer
    }()
    
    let shippingLabel: UILabel = {
        let textLayer = UILabel(frame: CGRect(x: 13.46, y: 470, width: 106.53, height: 14))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.black
        let textContent = "Free Shipping"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 15)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.56, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        return textLayer
    }()
}
