//
//  BusinessViewController.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 11/3/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import GoogleMaps
import GooglePlaces
import MapKit
import CoreLocation


class BusinessViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate{
    var currentBusiness = Business()
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let businessImageCellId = "businessImageCellId"
    let businessInfoCellId = "businessInfoCellId"
    let checkInCellId = "checkInCellId"
    let mapViewCellId = "mapViewCellId"
    
    let manager = CLLocationManager()
    var currentDistance = 10000.0
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locations[0].coordinate.latitude
        let longitude = locations[0].coordinate.longitude
        let distanceMeasure = abs(currentBusiness.getLatitude()-latitude) + abs(currentBusiness.getLongitude()-longitude)
        currentDistance = distanceMeasure
        //collectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        print(currentBusiness.getName())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(displayP3Red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
        self.navigationItem.title = currentBusiness.getName()
        //loadBusinessInfo()
        let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.width, height: self.view.bounds.height), collectionViewLayout: collectionLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(BusinessImageCell.self, forCellWithReuseIdentifier: self.businessImageCellId)
        collectionView.register(BusinessInfoCell.self, forCellWithReuseIdentifier: self.businessInfoCellId)
        collectionView.register(CheckInCell.self, forCellWithReuseIdentifier: self.checkInCellId)
        collectionView.register(MapViewCell.self, forCellWithReuseIdentifier: self.mapViewCellId)
        self.view.addSubview(collectionView)
        
        
    }
    
    let businessImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()
    
    let businessInfo: UIImageView = {
        let infoImageView = UIImageView()
        infoImageView.backgroundColor = UIColor.lightGray
        infoImageView.contentMode = .scaleToFill
        return infoImageView
    }()
    
    /*func loadBusinessInfo(){
        self.view.addSubview(businessImageView)
        businessImageView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width, height: self.view.frame.height/2.0)
        
        
        self.view.addSubview(businessInfo)
        businessInfo.anchor(top: self.businessImageView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 5.0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.view.frame.width, height: self.view.frame.height/5.0)
        businessInfo.image = UIImage(named: "business_info")
        
        self.view.addSubview(checkInButton)
        checkInButton.anchor(top: self.businessInfo.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, paddingTop: 5.0, paddingLeft: self.view.frame.width/5.0, paddingBottom: 0, paddingRight: self.view.frame.width/5.0, width: (3.0*self.view.frame.width)/5.0, height: self.view.frame.height/10.0)
        checkInButton.setTitle("Check In", for: UIControl.State.normal)
        checkInButton.layer.cornerRadius = 10
        checkInButton.clipsToBounds = true
    }*/
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 1
        }else if section == 2{
            return 1
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 || indexPath.section == 3{
            return CGSize(width: view.frame.width, height: CGFloat(view.frame.height/2.0))
        }else if indexPath.section == 1{
            return CGSize(width: CGFloat(view.frame.width), height: CGFloat(view.frame.height/5.0))
        }else{
            return CGSize(width: CGFloat(view.frame.width), height: CGFloat(view.frame.height/8.0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2{
            if currentDistance < 0.004{
                print("tapped check In!")
                let shapeLayer = CAShapeLayer()
                let circularPath = UIBezierPath(arcCenter: self.view.center, radius: 100, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
                
                /*trackLayer.path = circularPath.cgPath
                trackLayer.strokeColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 0.9).cgColor
                trackLayer.lineWidth = 20
                trackLayer.fillColor = UIColor.clear.cgColor
                trackLayer.lineCap = CAShapeLayerLineCap.round
                view.layer.addSublayer(trackLayer)*/
                let databaseRef = Database.database().reference()
                //let currentUID = Auth.auth().currentUser?.uid
                
                if(UserDefaults.standard.stringArray(forKey: "checkIns") != nil){
                    //Cart exists
                    
                    var currentCheckIns = (UserDefaults.standard.stringArray(forKey: "checkIns"))
                    if(!(currentCheckIns?.contains(currentBusiness.getName()))!){
                        currentCheckIns?.append(currentBusiness.getName())
                        databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("checkIns").setValue(currentCheckIns)
                        UserDefaults.standard.set(currentCheckIns, forKey: "checkIns")
                    }
                    
                    
                }else{
                    let checkIns = [currentBusiness.getName()]
                    databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("checkIns").setValue(checkIns)
                    UserDefaults.standard.set(checkIns, forKey: "checkIns")
                }
                
                shapeLayer.path = circularPath.cgPath
                shapeLayer.strokeColor = UIColor(displayP3Red: 0.0, green: 173.0/255, blue: 181.0/255, alpha: 1.0).cgColor
                shapeLayer.lineWidth = 20
                shapeLayer.strokeEnd = 0
                shapeLayer.fillColor = UIColor.clear.cgColor
                view.layer.addSublayer(shapeLayer)
                
                let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
                basicAnimation.toValue = 1
                basicAnimation.duration = 2
                
                basicAnimation.fillMode = CAMediaTimingFillMode.forwards
                basicAnimation.isRemovedOnCompletion = true
                shapeLayer.add(basicAnimation, forKey: "urSoBasic")
                
                // trackLayer.removeFromSuperlayer()
            }
            
        }
    }
    
    
    @objc func disappear(){
        self.view.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.businessImageCellId, for: indexPath) as! BusinessImageCell
            
            //let storageRef = Storage.storage().reference()
            let imageName = self.currentBusiness.getName().lowercased().replacingOccurrences(of: " ", with: "") + ".png"
            cell.productImageView.image = UIImage(named: imageName)
            /*let currentImageRef = storageRef.child("images/\(imageName)")
            currentImageRef.getData(maxSize: 1024 * 1024 * 1024) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print(error.localizedDescription)
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    image?.accessibilityIdentifier = imageName
                    cell.productImageView.image = image
                }
            }*/
            return cell
        }else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.businessInfoCellId, for: indexPath) as! BusinessInfoCell
            
            let currentRating = self.currentBusiness.getRating()
            let currentPriceLevel = self.currentBusiness.getPrice()
            
            let currentDateTime = Date()
            let userCalendar = Calendar.current
            let requestedComponents: Set<Calendar.Component> = [
                .hour,
                .minute,
                .second
            ]
            
            let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
            
            let currentTime = Double(dateTimeComponents.hour!) + Double(dateTimeComponents.minute!)/60.0
            print("current Time = \(currentRating)")
            
            if currentTime >= currentBusiness.getOpen() && currentTime <= currentBusiness.getClose(){
                cell.openStatus.text = "Open"
            }else{
                cell.openStatus.text = "Closed"
            }
            
            if(currentRating >= 1.0){
                cell.rating.image = UIImage(named: "filled_star")
            }else{
                
                cell.rating.image = UIImage(named: "empty_star")
            }
            
            if(currentRating >= 2.0){
                cell.star2.image = UIImage(named: "filled_star")
            }else{
                if(currentRating == 1.5){
                    cell.star2.image = UIImage(named: "half_star")
                }else{
                    cell.star2.image = UIImage(named: "empty_star")
                }
            }
            
            if(currentRating >= 3.0){
                cell.star3.image = UIImage(named: "filled_star")
            }else{
                if(currentRating == 2.5){
                    cell.star3.image = UIImage(named: "half_star")
                }else{
                    cell.star3.image = UIImage(named: "empty_star")
                }
            }
            
            if(currentRating >= 4.0){
                cell.star4.image = UIImage(named: "filled_star")
            }else{
                if(currentRating == 3.5){
                    cell.star4.image = UIImage(named: "half_star")
                }else{
                    cell.star4.image = UIImage(named: "empty_star")
                }
            }
            
            if(currentRating == 5.0){
                cell.star5.image = UIImage(named: "filled_star")
            }else{
                if(currentRating == 4.5){
                    cell.star5.image = UIImage(named: "half_star")
                }else{
                    cell.star5.image = UIImage(named: "empty_star")
                }
            }
            
            cell.businessName.text = currentBusiness.getName()
            cell.productPriceLevel.text = currentPriceLevel
            
            
            return cell
        }else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.checkInCellId, for: indexPath) as! CheckInCell
            print("current Distance = \(currentDistance)")
            /*if(currentDistance < 0.004){
                cell.checkInButton.isEnabled = true
                cell.checkInButton.isUserInteractionEnabled = true
            }else{
                cell.checkInButton.isEnabled = false
                cell.checkInButton.isUserInteractionEnabled = false
            }*/
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.mapViewCellId, for: indexPath) as! MapViewCell
            cell.mapView.camera = GMSCameraPosition.camera(withLatitude: currentBusiness.getLatitude(), longitude: currentBusiness.getLongitude(), zoom: 10.0)
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: currentBusiness.getLatitude(), longitude: currentBusiness.getLongitude()))
            marker.map = cell.mapView
            marker.title = currentBusiness.getName()
            marker.snippet = currentBusiness.getNote()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2 || section == 3{
            return UIEdgeInsets(top: 10.0, left: 5.0, bottom: 5.0, right: 5.0)
        }else{
            return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
    
   /* @objc func registerCheckIn(sender: UIButton){
        
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }*/
    
}

class BusinessImageCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell(){
        self.backgroundView?.contentMode = .scaleToFill
        self.addSubview(productImageView)
        productImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //dealImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
        
        //dealImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet!")
    }
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
}

class BusinessInfoCell: UICollectionViewCell{
    
    let businessName = UILabel()
    let star2 = UIImageView()
    let star3 = UIImageView()
    let star4 = UIImageView()
    let star5 = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell(){
        self.backgroundView?.contentMode = .scaleToFill
        self.addSubview(rating)
        self.addSubview(productPriceLevel)
        self.addSubview(openStatus)
        self.addSubview(businessName)
        
        
        businessName.font = UIFont(descriptor: UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family:"BodoniSvtyTwoITCTT-Bold"]), size: 20.0)
        businessName.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 0, paddingRight: 0, width: self.contentView.frame.width, height: 20.0)
        businessName.sizeToFit()
        
        rating.anchor(top: businessName.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 0, paddingRight: 0, width: 15.0, height: 15.0)
        rating.image = UIImage(named: "filled_star")
        
        self.addSubview(star2)
        star2.anchor(top: businessName.bottomAnchor, left: rating.rightAnchor, bottom: nil, right: nil, paddingTop: 5.0, paddingLeft: 1.0, paddingBottom: 0, paddingRight: 0, width: 15.0, height: 15.0)
        star2.image = UIImage(named: "filled_star")
        
        self.addSubview(star3)
        star3.anchor(top: businessName.bottomAnchor, left: star2.rightAnchor, bottom: nil, right: nil, paddingTop: 5.0, paddingLeft: 1.0, paddingBottom: 0, paddingRight: 0, width: 15.0, height: 15.0)
        star3.image = UIImage(named: "filled_star")
        
        self.addSubview(star4)
        star4.anchor(top: businessName.bottomAnchor, left: star3.rightAnchor, bottom: nil, right: nil, paddingTop: 5.0, paddingLeft: 1.0, paddingBottom: 0, paddingRight: 0, width: 15.0, height: 15.0)
        star4.image = UIImage(named: "filled_star")
        
        self.addSubview(star5)
        star5.anchor(top: businessName.bottomAnchor, left: star4.rightAnchor, bottom: nil, right: nil, paddingTop: 5.0, paddingLeft: 1.0, paddingBottom: 0, paddingRight: 0, width: 15.0, height: 15.0)
        star5.image = UIImage(named: "filled_star")
        
        productPriceLevel.anchor(top: rating.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 0, paddingRight: 0, width: self.contentView.frame.width/2.0, height: 0)
        openStatus.anchor(top: productPriceLevel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 0, paddingRight: 0, width: self.contentView.frame.width/2.0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet!")
    }
    
    var productPriceLevel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textColor = UIColor.red
        return priceLabel
    }()
    
    let rating: UIImageView = {
        let ratingImageView = UIImageView()
        ratingImageView.backgroundColor = UIColor.darkGray
        return ratingImageView
    }()
    
    let openStatus: UILabel = {
        let openLabel = UILabel()
        openLabel.textColor = UIColor(displayP3Red: 0.0, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
        return openLabel
    }()
}

class CheckInCell: UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.borderWidth = 2.0
        self.contentView.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        setUpCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell(){
        self.addSubview(checkInLabel)
        checkInLabel.anchor(top:safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 5.0, paddingLeft: 5.0, paddingBottom: 5.0, paddingRight: 5.0, width: 0, height: 0)
        /*checkInButton.setTitle("Check In", for: UIControl.State.normal)
        checkInButton.layer.cornerRadius = 10
        checkInButton.clipsToBounds = true*/
        checkInLabel.textAlignment = .center
        checkInLabel.text = "Check In"
        checkInLabel.textColor = UIColor(displayP3Red: 0.0, green: 173.0/255, blue: 181.0/255, alpha: 1.0)
    }
    
    let checkInLabel: UILabel = {
        let label = UILabel()
        //button.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        //button.setTitleColor(UIColor(displayP3Red: 0.0, green: 173.0/255, blue: 181.0/255, alpha: 1.0), for: UIControl.State.normal)
        return label
    }()
}

class MapViewCell: UICollectionViewCell{
    /*var latitude = 40.7831
    var longitude = -73.9712
    var name = ""
    var note = ""*/
    
    let mapView = GMSMapView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setUpCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell(){
        /*let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 10.0)
        let mapView: GMSMapView = GMSMapView.map(withFrame: self.contentView.frame, camera: camera)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = name
        marker.snippet = note
        marker.map = mapView*/
        mapView.frame = self.contentView.frame
        self.contentView.addSubview(mapView)
    }
}
