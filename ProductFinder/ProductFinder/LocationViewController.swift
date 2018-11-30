//
//  LocationViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 10/31/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseDatabase
import CoreLocation
import MapKit
import FirebaseStorage

class LocationViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate{
    
    var locationManager = CLLocationManager()
    var latitude = 0.0
    var longitude = 0.0
    var infoShowing = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //self.title = ""
        let alert = UIAlertController(title: "Note", message: "Check into businesses for discounts!", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            alert.removeFromParent()
        }
        alert.addAction(cancelAction)
        //self.present(alert, animated: true, completion: nil)
    }
    
    var currentBusinesses = [Business]()
    var currentProducts = [String]()
    var currentProductName = ""
    var currentTag = 0
    var indexChosen = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        setupNavigationBar()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        self.currentBusinesses.removeAll()
        self.currentProducts.removeAll()
        
        if self.currentProductName.count > 0 {
            self.currentBusinesses = loadRelevantBusinesses {
            }
        }else{
            self.currentBusinesses = loadAllProductInfo {
                self.currentProducts = self.loadAllProductInfo2{
                    
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.navigationController?.popViewController(animated: false)
    }
    
    lazy var searchBar = UISearchBar(frame: CGRect.zero)
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitude = Double(locations[0].coordinate.latitude)
        self.longitude = Double(locations[0].coordinate.longitude)
        
        print("\(self.latitude), \(self.longitude)")
    }
    
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
        let titleLabel = UILabel()
        titleLabel.text = "Location View"
        navigationItem.titleView = titleLabel
    }
    
    func loadAllProductInfo2(completion: @escaping ()->()) -> [String]{
        let ref: DatabaseReference = Database.database().reference()
        ref.child("furniture").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for (productName, _) in value ?? [:]{
                self.currentProducts.append(productName as! String)
            }
        })
        return self.currentProducts
    }
    
    func loadAllProductInfo(completion: @escaping ()->()) -> [Business]{
        let ref: DatabaseReference = Database.database().reference()
        
        let camera = GMSCameraPosition.camera(withLatitude: 40.7605, longitude: -73.951, zoom: 35)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
        let customSC = self.customSegments
        customSC.frame = CGRect(x: 0.0, y: (0.25*view.frame.height)/8.0, width: view.frame.width/2.0, height: view.frame.height/10.0)
        customSC.backgroundColor = UIColor.white
        customSC.center.x = self.view.center.x
        customSC.selectedSegmentIndex = 0
        mapView.addSubview(customSC)
        
        self.view = mapView
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        ref.child("furniture").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for (productName, productInfo) in value ?? [:]{
                let currentBusinesses = (productInfo as? NSDictionary)!["businesses"] as? NSDictionary
                //print(currentBusinesses?["\"0\""] ?? -1)
                var businessNames = [String]()
                for (_, businessName) in currentBusinesses!{
                    businessNames.append(businessName as! String)
                }
                
                ref.child("businesses").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    for (businessName, businessInfo) in value ?? [:]{
                        if businessNames.contains(businessName as! String){
                            let address = (businessInfo as? NSDictionary)!["Address"] as! String
                            let type = (businessInfo as? NSDictionary)!["Type"] as! String
                            let latitude = (businessInfo as? NSDictionary)!["Latitude"] as! Double
                            let longitude = (businessInfo as? NSDictionary)!["Longitude"] as! Double
                            let note = (businessInfo as? NSDictionary)!["Description"] as! String
                            let id = (businessInfo as? NSDictionary)!["ID"] as! String
                            let open = (businessInfo as? NSDictionary)!["Open"] as! Double
                            let close = (businessInfo as? NSDictionary)!["Close"] as! Double
                            let rating = (businessInfo as? NSDictionary)!["Rating"] as! Double
                            let price = (businessInfo as? NSDictionary)!["Price"] as! String
                            
                            let currentBusiness = Business(name: businessName as! String, address: address, note: note,type: type, latitude: latitude, longitude: longitude, id: id, open: open, close: close, rating: rating, price: price)
                            if(!self.currentBusinesses.contains(currentBusiness)){
                                self.currentBusinesses.append(currentBusiness)
                            }
                        }
                    }
                    
                    print("\(String(describing: self.locationManager.location?.coordinate.latitude)), \(String(describing: self.locationManager.location?.coordinate.longitude))")
                    mapView.camera = GMSCameraPosition.camera(withLatitude: /*(self.locationManager.location?.coordinate.latitude) ??*/ 40.7605, longitude: /*(self.locationManager.location?.coordinate.longitude) ??*/ -73.951, zoom: 14.0)
                    
                    print(self.currentBusinesses.count)
                    
                    for currBusiness in self.currentBusinesses{
                        //print("\(currBusiness.getLatitude()), \(currBusiness.getLongitude())")
                        // Creates a marker in the center of the map.
                        let marker = GMSMarker()
                        marker.icon = UIImage(named: "location_marker")
                        marker.position = CLLocationCoordinate2D(latitude: currBusiness.getLatitude(), longitude: currBusiness.getLongitude())
                        marker.title = currBusiness.getName()
                        marker.snippet = currBusiness.getNote()
                        marker.map = mapView
                    }
                    
                })
            }
            completion()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return self.currentBusinesses
    }
    
    func loadRelevantBusinesses(completion: @escaping ()->()) -> [Business]{
        let ref: DatabaseReference = Database.database().reference()
        
        let camera = GMSCameraPosition.camera(withLatitude: 40.7605, longitude: -73.951, zoom: 20)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
        let customSC = self.customSegments
        customSC.frame = CGRect(x: 0.0, y: (0.25*view.frame.height)/8.0, width: view.frame.width/2.0, height: view.frame.height/10.0)
        customSC.backgroundColor = UIColor.white
        customSC.center.x = self.view.center.x
        customSC.selectedSegmentIndex = 0
        mapView.addSubview(customSC)
        
        self.view = mapView
        mapView.delegate = self
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        //self.latitude = Double((mapView.myLocation?.coordinate.latitude)) ?? 0.0
        //self.longitude = Double((mapView.myLocation?.coordinate.longitude)) ?? 0.0
        print("\(self.latitude), \(self.longitude)")
        
        ref.child("furniture").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for (productName, productInfo) in value ?? [:]{
                if (productName as! String) == self.currentProductName{
                    print(productInfo)
                    let currentBusinesses = (productInfo as? NSDictionary)!["businesses"] as? NSDictionary
                    //print(currentBusinesses?["\"0\""] ?? -1)
                    var businessNames = [String]()
                    for (_, businessName) in currentBusinesses!{
                       businessNames.append(businessName as! String)
                    }
                    
                    ref.child("businesses").observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        for (businessName, businessInfo) in value ?? [:]{
                            if businessNames.contains(businessName as! String){
                                let address = (businessInfo as? NSDictionary)!["Address"] as! String
                                let type = (businessInfo as? NSDictionary)!["Type"] as! String
                                let latitude = (businessInfo as? NSDictionary)!["Latitude"] as! Double
                                let longitude = (businessInfo as? NSDictionary)!["Longitude"] as! Double
                                let note = (businessInfo as? NSDictionary)!["Description"] as! String
                                let id = (businessInfo as? NSDictionary)!["ID"] as! String
                                let open = (businessInfo as? NSDictionary)!["Open"] as! Double
                                let close = (businessInfo as? NSDictionary)!["Close"] as! Double
                                let rating = (businessInfo as? NSDictionary)!["Rating"] as! Double
                                let price = (businessInfo as? NSDictionary)!["Price"] as! String
                                
                                let currentBusiness = Business(name: businessName as! String, address: address, note: note,type: type, latitude: latitude, longitude: longitude, id: id, open: open, close: close, rating: rating, price: price)
                                if(!self.currentBusinesses.contains(currentBusiness)){
                                    self.currentBusinesses.append(currentBusiness)
                                }
                            }
                        }
                        
                        print("\(String(describing: self.locationManager.location?.coordinate.latitude)), \(String(describing: self.locationManager.location?.coordinate.longitude))")
                        mapView.camera = GMSCameraPosition.camera(withLatitude: /*(self.locationManager.location?.coordinate.latitude) ??*/ 40.7605, longitude: /*(self.locationManager.location?.coordinate.longitude) ??*/ -73.951, zoom: 14.0)
                        
                        print(self.currentBusinesses.count)
                        
                        for currBusiness in self.currentBusinesses{
                            //print("\(currBusiness.getLatitude()), \(currBusiness.getLongitude())")
                            // Creates a marker in the center of the map.
                            let marker = GMSMarker()
                            marker.icon = UIImage(named: "location_marker")
                            marker.position = CLLocationCoordinate2D(latitude: currBusiness.getLatitude(), longitude: currBusiness.getLongitude())
                            marker.title = currBusiness.getName()
                            marker.snippet = currBusiness.getNote()
                            marker.map = mapView
                        }
                        
                    })
                }
            }
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return currentBusinesses
    }
    
    //Function for handling the tap on the marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if currentTag > 2 {
            let view1 = self.view.viewWithTag(self.currentTag-2)
            let view2 = self.view.viewWithTag(self.currentTag-1)
            view1?.removeFromSuperview()
            view2?.removeFromSuperview()
        }
        
        let infoLayer = UIControl(frame: CGRect(x: 149, y: (553*view.frame.height)/812.0, width: (209*view.frame.width)/375.0, height: (135*view.frame.height)/812.0))
        infoLayer.backgroundColor = UIColor.white
        infoLayer.layer.shadowOffset = CGSize(width: 0, height: 2)
        infoLayer.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
        infoLayer.layer.shadowOpacity = 1
        infoLayer.layer.shadowRadius = 4
        self.view.addSubview(infoLayer)
        //Product Name
        let textLayer = UILabel()
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor(red:0.47, green:0.29, blue:0.47, alpha:1)
        var textContent = currentProductName
        var index = 0
        print("lenght of products: \(currentProducts.count)")
        if currentProductName.count == 0{
            for currentBusiness in currentBusinesses{
                if currentBusiness.getLatitude() == marker.position.latitude && currentBusiness.getLongitude() == marker.position.longitude{
                    textContent = self.currentProducts[index]
                    break
                }
                index+=1
            }
        }
        self.indexChosen = index
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 13)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.48, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        infoLayer.addSubview(textLayer)
        textLayer.anchor(top: infoLayer.topAnchor, left: infoLayer.leftAnchor, bottom: infoLayer.bottomAnchor, right: nil, paddingTop: (19.0*view.frame.height)/812.0, paddingLeft: (10.0*view.frame.width)/375.0, paddingBottom: -1*(89.0*view.frame.height)/812.0, paddingRight: 0.0)
        //Business Name
        let businessNameLayer = UILabel(/*frame: CGRect(x: 159, y: 609, width: 62, height: 12)*/)
        businessNameLayer.lineBreakMode = .byWordWrapping
        businessNameLayer.numberOfLines = 0
        businessNameLayer.textColor = UIColor.darkGray
        var businessNameContent = currentBusinesses[0].getName()
        if self.currentProductName.count == 0{
            businessNameContent = currentBusinesses[index].getName()
        }
        let businessNameString = NSMutableAttributedString(string: businessNameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 13)!
            ])
        let businessNameRange = NSRange(location: 0, length: businessNameString.length)
        let businessNameStyle = NSMutableParagraphStyle()
        businessNameStyle.lineSpacing = 1
        businessNameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:businessNameStyle, range: businessNameRange)
        businessNameString.addAttribute(NSAttributedString.Key.kern, value: 0.48, range: businessNameRange)
        businessNameLayer.attributedText = businessNameString
        businessNameLayer.sizeToFit()
        infoLayer.addSubview(businessNameLayer)
        businessNameLayer.anchor(top: infoLayer.topAnchor, left: infoLayer.leftAnchor, bottom: infoLayer.bottomAnchor, right: nil, paddingTop: (56.0*view.frame.height)/812.0, paddingLeft: (10.0*view.frame.width)/375.0, paddingBottom: -1*(60.0*view.frame.height)/812.0, paddingRight: 0.0)
        //Business Address Label
        let addressLayer = UILabel(/*frame: CGRect(x: 159, y: 641, width: 78, height: 12)*/)
        addressLayer.lineBreakMode = .byWordWrapping
        addressLayer.numberOfLines = 0
        addressLayer.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)
        var addressContent = "405 main st."
        if self.currentBusinesses.count == 1{
            addressContent = String(self.currentBusinesses[0].getAddress().split(separator: ",")[0])
        }else{
            for currentBusiness in currentBusinesses{
                if currentBusiness.getLatitude() == marker.position.latitude && currentBusiness.getLongitude() == marker.position.longitude{
                    addressContent = String(currentBusiness.getAddress().split(separator: ",")[0])
                    break
                }
            }
        }
        let addressString = NSMutableAttributedString(string: addressContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Roman", size: 13)!
            ])
        let addressRange = NSRange(location: 0, length: addressString.length)
        let addressStyle = NSMutableParagraphStyle()
        addressStyle.lineSpacing = 1
        addressString.addAttribute(NSAttributedString.Key.paragraphStyle, value:addressStyle, range: addressRange)
        addressString.addAttribute(NSAttributedString.Key.kern, value: 0.48, range: addressRange)
        addressLayer.attributedText = addressString
        addressLayer.sizeToFit()
        infoLayer.addSubview(addressLayer)
        addressLayer.anchor(top: infoLayer.topAnchor, left: infoLayer.leftAnchor, bottom: infoLayer.bottomAnchor, right: nil, paddingTop: (88.0*view.frame.height)/812.0, paddingLeft: (10.0*view.frame.width)/375.0, paddingBottom: -1*(30.0*view.frame.height)/812.0, paddingRight: 0.0)
        
        let imageLayer = UIImageView(frame: CGRect(x: 17, y: (553*view.frame.height)/812.0, width: (135*view.frame.width)/375.0, height: (135*view.frame.height)/812.0))
        imageLayer.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageLayer.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
        imageLayer.layer.shadowOpacity = 1
        imageLayer.layer.shadowRadius = 4
        var imageName = self.currentBusinesses[0].getName().lowercased().replacingOccurrences(of: " ", with: "") + ".png"
        if self.currentProductName.count == 0{
            imageName = self.currentProducts[index].lowercased().replacingOccurrences(of: " ", with: "") + ".png"
        }
        imageLayer.image = UIImage(named: imageName)
        self.view.addSubview(imageLayer)
        
        infoLayer.tag = self.currentTag
        imageLayer.tag = self.currentTag+1
        
        infoLayer.addTarget(self, action: #selector(goToBusinessPage), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToBusinessPage))
        imageLayer.isUserInteractionEnabled = true
        imageLayer.addGestureRecognizer(tapGestureRecognizer)
        
        self.currentTag+=2
        return true
    }
    
    @objc func goToBusinessPage(){
        let businessVC = BusinessViewController()
        if self.currentProductName.count > 0{
            businessVC.currentBusiness = self.currentBusinesses[0]
            businessVC.currentDistance = abs(self.latitude-self.currentBusinesses[0].getLatitude()) + abs(self.longitude-self.currentBusinesses[0].getLongitude())
        }else{
            businessVC.currentBusiness = self.currentBusinesses[self.indexChosen]
            businessVC.currentDistance = abs(self.latitude-self.currentBusinesses[0].getLatitude()) + abs(self.longitude-self.currentBusinesses[0].getLongitude())
        }
        self.navigationController?.pushViewController(businessVC, animated: false)
    }
    
    func loadBusinessListView(){
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: (9.0*self.view.frame.height)/10.0), style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.register(BusinessCell.self, forCellReuseIdentifier: "businessCell")
        
        let customSC = self.customSegments
        customSC.frame = CGRect(x: 0.0, y: (7.5*view.frame.height)/8.0, width: view.frame.width/2.0, height: view.frame.height/20.0)
        customSC.center.x = self.view.center.x
        self.view.addSubview(customSC)
        
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentBusinesses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let businessVC = BusinessViewController()
        businessVC.currentBusiness = self.currentBusinesses[indexPath.row]
        businessVC.currentDistance = abs(self.latitude-self.currentBusinesses[indexPath.row].getLatitude()) + abs(self.longitude-self.currentBusinesses[indexPath.row].getLongitude())
        self.navigationController?.pushViewController(businessVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell") as! BusinessCell
        cell.nameLabel.text = self.currentBusinesses[indexPath.row].getName()
        cell.addressLabel.text = String(self.currentBusinesses[indexPath.row].getAddress().split(separator: ",").first!)
        
        //let storageRef = Storage.storage().reference()
        let imageName = self.currentBusinesses[indexPath.row].getName().lowercased().replacingOccurrences(of: " ", with: "") + ".png"
        cell.businessImageView.image = UIImage(named: imageName)
        /*let currentImageRef = storageRef.child("images/\(imageName)")
        
        currentImageRef.getData(maxSize: 1024 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                image?.accessibilityIdentifier = imageName
                cell.businessImageView.image = image
            }
        }*/
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.23
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    let customSegments: UISegmentedControl = {
        let items = ["Map View", "List View"]
        let customSC = UISegmentedControl(items: items)
        customSC.tintColor = UIColor(red:0.2, green:0.44, blue:0.51, alpha:1)
        customSC.selectedSegmentIndex = 0
        customSC.addTarget(self, action: #selector(changeView), for: UIControl.Event.valueChanged)
        return customSC
    }()
    
    @objc func changeView(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            self.currentBusinesses.removeAll()
            self.currentProducts.removeAll()
            
            if self.currentProductName.count > 0 {
                self.currentBusinesses = loadRelevantBusinesses {
                }
            }else{
                self.currentBusinesses = loadAllProductInfo {
                    self.currentProducts = self.loadAllProductInfo2{
                        
                    }
                }
            }
        case 1:
            self.view.subviews.forEach({ $0.removeFromSuperview() })
            self.view.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
            loadBusinessListView()
        default:
            self.view.backgroundColor = UIColor.purple
        }
    }
    
}

class BusinessCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(businessImageView)
        self.contentView.addSubview(addressLabel)
        
        businessImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: (2.0*self.frame.width)/3.0, width: 0, height: self.frame.height)
        
        nameLabel.anchor(top:safeAreaLayoutGuide.topAnchor, left: businessImageView.rightAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 5.0, paddingLeft: 10, paddingBottom: 0, paddingRight:10, width: 0, height: (2.5*self.frame.height)/6.0)
        
        addressLabel.anchor(top: nameLabel.bottomAnchor, left: businessImageView.rightAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: (2.5*self.frame.height)/6.0)
        
        self.contentView.backgroundColor = UIColor(displayP3Red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        //label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(red:0.47, green:0.29, blue:0.47, alpha:1)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        return label
    }()
    
    let businessImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(displayP3Red: 34.0/255, green: 40.0/255, blue: 49.0/255, alpha: 1.0)
        return imageView
    }()
}
