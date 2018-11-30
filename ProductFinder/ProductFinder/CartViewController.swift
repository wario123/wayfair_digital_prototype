//
//  CartViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 11/8/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var currentCart = [String]()
    let cartCellID = "cartCellId"
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        self.setUpCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let databaseRef = Database.database().reference()
        databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("cart").removeValue()
        for element in self.currentCart{
            let cartElement = ["name": element]
            let cartRef = databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("cart").childByAutoId()
            cartRef.setValue(cartElement)
        }
    }
    
    func setUpNavBar(){
        self.navigationItem.title = "My Cart"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(dismissCart))
    }
    
    func setUpCart(){
        //self.currentCart = UserDefaults.standard.stringArray(forKey: "cart") ?? [String]()
        let databaseRef = Database.database().reference()
        databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("cart").observe(.value, with: { (snapshot) in
        //print(snapshot.value!)
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    let currentProductInfo = (snap.value! as! [String: String])
                    if self.currentCart.count == 0{
                        self.currentCart = [currentProductInfo["name"]] as! [String]
                        //print(currentCart)
                    }else{
                        self.currentCart.append(currentProductInfo["name"]!)
                        //print(currentCart)
                    }
                    //self.currentCart.append(snap.value as! String)
                }
            }
            //Make UserDefaults consistent with the db
            print(self.currentCart)
            self.tableView.reloadData()
        })
        //}
        tableView.tableFooterView = UIView(frame: .zero)
        tableView = UITableView(frame: self.view.frame, style: UITableView.Style.plain)
        self.view = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartCell.self, forCellReuseIdentifier: self.cartCellID)
    }
    
    @objc func dismissCart(){
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentCart.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.currentCart.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cartCellID) as! CartCell
        cell.nameLabel.text = currentCart[indexPath.row]
        let imageName = currentCart[indexPath.row].lowercased().replacingOccurrences(of: " ", with: "") + ".png"
        cell.itemImageView.image = UIImage(named: imageName)
        
        let ref: DatabaseReference = Database.database().reference()
        
        ref.child("furniture").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for (productName, productInfo) in value ?? [:]{
                if (productName as! String) == self.currentCart[indexPath.row]{
                    cell.priceLabel.text = String(describing:(productInfo as? NSDictionary)!["Price"]!)
                    break
                }
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.23
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        return cell
    }
}

class CartCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(itemImageView)
        self.contentView.addSubview(priceLabel)
        
        itemImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: (2.0*self.frame.width)/3.0, width: 0, height: self.frame.height)
        
        nameLabel.anchor(top:safeAreaLayoutGuide.topAnchor, left: itemImageView.rightAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 5.0, paddingLeft: 10, paddingBottom: 0, paddingRight:10, width: 0, height: (2.5*self.frame.height)/6.0)
        
        priceLabel.anchor(top: nameLabel.bottomAnchor, left: itemImageView.rightAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: (2.5*self.frame.height)/6.0)
        
        self.contentView.backgroundColor = UIColor.white //UIColor(displayP3Red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        //label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        return label
    }()
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(displayP3Red: 34.0/255, green: 40.0/255, blue: 49.0/255, alpha: 1.0)
        return imageView
    }()
}
