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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
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
        navigationItem.titleView = searchBar
        
        let cameraBarButton = UIBarButtonItem(image: UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        
        let shoppingCartBarButton = UIBarButtonItem(image: UIImage(named: "shopping_cart")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [shoppingCartBarButton, cameraBarButton]
        
        //Setting up our collection view and its intended layout
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2.0-15.0, height: UIScreen.main.bounds.height/3.0)
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height), collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: itemCellId)
        self.view.addSubview(collectionView)
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
                let product = Product(productName: productName as! String, productSeller: currentSeller as! String, productType: currentType as! String, productPrice: currentPrice as! Double)
                
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
        cell.nameLabel.text = currentProduct.getName()
        cell.sellerLabel.text = "by \(currentProduct.getSeller())"
        cell.priceLabel.text = "$\(currentProduct.getPrice())"
        
        
        //let storageRef = Storage.storage().reference()
        let imageName = currentProduct.getName().lowercased().replacingOccurrences(of: " ", with: "") + ".png"
        cell.itemImageView.image = UIImage(named: imageName)
        currentProductImages.append(UIImage(named: imageName)!)
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
        self.backgroundColor = UIColor(displayP3Red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
        
        self.addSubview(itemImageView)
        self.addSubview(nameLabel)
        self.addSubview(sellerLabel)
        self.addSubview(priceLabel)
        
        itemImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: self.frame.height/3)
        
        nameLabel.anchor(top:itemImageView.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight:10, width: 0, height: self.frame.height/10)
        
        sellerLabel.anchor(top:nameLabel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight:10, width: 0, height: self.frame.height/10)
        
        priceLabel.anchor(top:sellerLabel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight:10, width: 0, height: self.frame.height/10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet!")
    }
    
    var itemImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let sellerLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 2
        label.textColor = UIColor.darkGray
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.red
        return label
    }()
    
}
