//
//  HomeViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 10/31/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit

class HomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(displayP3Red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
        setupNavigationBar()
    }
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    let productCategoryCellId = "productCategoryCell"
    let dealCellId = "dealCell"
    
    let productCategoryImages = [UIImage(named: "furniture"), UIImage(named: "bed_bath"), UIImage(named: "decor_pillows"), UIImage(named: "rugs"), UIImage(named: "lighting"), UIImage(named: "home_improvement"), UIImage(named: "appliances"), UIImage(named: "kitchen_tabletop")]
    let productCategories = ["Furniture", "Bed & Bath", "Decor & Pillows", "Rugs", "Lighting", "Home Improvement", "Appliances", "Kitchen & Tabletop"]
    
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
        
        collectionView?.register(ProductCategoryCell.self, forCellWithReuseIdentifier: productCategoryCellId)
        collectionView?.register(DealCell.self, forCellWithReuseIdentifier: dealCellId)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if section == 0{
            return 1
        }else{
            return 16
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dealCellId, for: indexPath) as! DealCell
            cell.dealView.frame = cell.frame
            cell.dealView.backgroundColor = UIColor.black
            cell.dealView.contentMode = .scaleAspectFill
            cell.dealView.clipsToBounds = true
            cell.dealView.image = UIImage(named: "deal")
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCategoryCellId, for: indexPath) as! ProductCategoryCell
        cell.categoryImageView.image = productCategoryImages[indexPath.row%8]
        cell.categoryLabel.text = productCategories[indexPath.row%8]
        cell.categoryLabel.font = cell.categoryLabel.font.withSize(12)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: CGFloat(view.frame.width), height: CGFloat(view.frame.height/2.0))
        }else{
            return CGSize(width: CGFloat((view.frame.width)/2.0-6.0), height: CGFloat(view.frame.height/10.0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.tabBarController?.selectedIndex = 1
        let currentShopVC = ShopViewController()
        currentShopVC.searchBar.text = productCategories[indexPath.row]
        self.navigationController?.pushViewController(currentShopVC, animated: false)
    }
}

class DealCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        setupCell()
    }
    
    func setCellShadow(){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.cornerRadius = 3
    }
    
    func setupCell(){
        self.backgroundView?.contentMode = .scaleToFill
        self.backgroundColor = UIColor(patternImage: UIImage(named:"deal")!)
        self.addSubview(dealView)
        
        //dealImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        
        //dealImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet!")
    }
    
    let dealView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        //imageView.clipsToBounds = true
        //imageView.backgroundColor = UIColor.black//(patternImage: UIImage(named: "deal")!)
        return imageView
    }()
}

class ProductCategoryCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell(){
        self.backgroundColor = UIColor.white
        self.addSubview(categoryImageView)
        self.addSubview(categoryLabel)
    categoryImageView.anchor(top:safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight:2*self.frame.width/3, width: 0, height: self.frame.height)
        
    categoryLabel.anchor(top:safeAreaLayoutGuide.topAnchor, left: categoryImageView.rightAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight:10, width: 0, height: self.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet!")
    }
    
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()
}
