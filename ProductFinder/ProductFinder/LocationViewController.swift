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

class LocationViewController: UIViewController, GMSMapViewDelegate{
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    var currentBusinesses = [Business]()
    var currentProductName = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor(displayP3Red: 57.0/255, green: 62.0/255, blue: 70.0/255, alpha: 1.0)
        setupNavigationBar()
        
        loadRelevantBusinesses {
            self.loadMap()
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
    
    func loadRelevantBusinesses(completion: @escaping ()->()){
        let ref: DatabaseReference = Database.database().reference()
        
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
                        
                        let camera = GMSCameraPosition.camera(withLatitude: 40.7831, longitude: -73.9712, zoom: 10.0)
                        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
                        self.view = mapView
                        mapView.delegate = self
                        mapView.settings.myLocationButton = true
                        
                        print(self.currentBusinesses.count)
                        
                        for currBusiness in self.currentBusinesses{
                            print("\(currBusiness.getLatitude()), \(currBusiness.getLongitude())")
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
    }
    
    func loadMap(){
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        
        /*let camera = GMSCameraPosition.camera(withLatitude: 40.7831, longitude: -73.9712, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        view = mapView
        
        print(self.currentBusinesses!.count)
        
        for business in currentBusinesses!{
            print("\(business.getLatitude()), \(business.getLongitude())")
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: business.getLatitude(), longitude: business.getLongitude())
            marker.title = business.getName()
            marker.snippet = business.getNote()
            marker.map = mapView
        }*/
        
    }
    
    /*func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let currPlaceId = String((marker.snippet?.split(separator: "|")[1])!)
        let businessVC = BusinessViewController()
        //businessVC.currentPlaceId = currPlaceId
        //self.navigationController?.pushViewController(businessVC, animated: false)
        
        return true
    }*/
    
}
