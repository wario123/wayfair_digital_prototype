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
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    var currentBusinesses = [Business]()
    var currentProductName = ""
    
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
        self.currentBusinesses = loadRelevantBusinesses {
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.navigationController?.popViewController(animated: false)
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
    
    func loadRelevantBusinesses(completion: @escaping ()->()) -> [Business]{
        let ref: DatabaseReference = Database.database().reference()
        
        let camera = GMSCameraPosition.camera(withLatitude: 40.7831, longitude: -73.9712, zoom: 10.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        
        let customSC = self.customSegments
        customSC.frame = CGRect(x: 0.0, y: (7.0*view.frame.height)/8.0, width: view.frame.width/2.0, height: view.frame.height/10.0)
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
                                
                                let currentBusiness = Business(name: businessName as! String, address: address, note: note,type: type, latitude: latitude, longitude: longitude, id: id)
                                if(!self.currentBusinesses.contains(currentBusiness)){
                                    self.currentBusinesses.append(currentBusiness)
                                }
                            }
                        }
                        
                        
                        print("\(String(describing: self.locationManager.location?.coordinate.latitude)), \(String(describing: self.locationManager.location?.coordinate.longitude))")
                        mapView.camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 10.0)
                        
                        print(self.currentBusinesses.count)
                        
                        for currBusiness in self.currentBusinesses{
                            //print("\(currBusiness.getLatitude()), \(currBusiness.getLongitude())")
                            // Creates a marker in the center of the map.
                            let marker = GMSMarker()
                            marker.position = CLLocationCoordinate2D(latitude: currBusiness.getLatitude(), longitude: currBusiness.getLongitude())
                            marker.title = currBusiness.getName()
                            marker.snippet = currBusiness.getNote() + "|" + currBusiness.getID()
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell") as! BusinessCell
        cell.nameLabel.text = self.currentBusinesses[indexPath.row].getName()
        cell.addressLabel.text = String(self.currentBusinesses[indexPath.row].getAddress().split(separator: ",").first!)
        
        let storageRef = Storage.storage().reference()
        let imageName = self.currentBusinesses[indexPath.row].getName().lowercased().replacingOccurrences(of: " ", with: "") + ".png"
        let currentImageRef = storageRef.child("images/\(imageName)")
        
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
        }
        
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
        customSC.tintColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        customSC.selectedSegmentIndex = 0
        customSC.addTarget(self, action: #selector(changeView), for: UIControl.Event.valueChanged)
        return customSC
    }()
    
    @objc func changeView(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            self.currentBusinesses.removeAll()
            self.currentBusinesses = loadRelevantBusinesses {

            }
        case 1:
            self.view.subviews.forEach({ $0.removeFromSuperview() })
            self.view.backgroundColor = UIColor.black
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
        label.textColor = UIColor(displayP3Red: 0.0/255, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
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
