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
import CoreLocation

class ProductInfoViewController: UIViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //if self.view.subviews.count == 0{
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
        
        
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
                self.latitude = Double(locationManager.location?.coordinate.latitude ?? 0)
                self.longitude = Double(locationManager.location?.coordinate.longitude ?? 0)
            }
        
            setupNavigationBar()
            setupProductDetailView()
            //self.currentBusinesses.removeAll()
            /*self.currentBusinesses = loadRelevantBusinesses {
                print("currentBusinesses = \(self.currentBusinesses)")
            }*/
        //}
    }
    
    var locationManager = CLLocationManager()
    var latitude = 0.0
    var longitude = 0.0
    var distEst = 10000.0
    var detailImageView = UIImageView()
    var detailLabel = UILabel()
    var locatorButton = UIButton()
    var currentProduct = Product()
    var imageDiffVal = 50.0
    //var currentBusinesses = [Business]()
    
    func setupNavigationBar(){
        //navigationItem.title = "Details"
        
        let uploadBarButton = UIBarButtonItem(image: UIImage(named: "upload")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        
        let shoppingCartBarButton = UIBarButtonItem(image: UIImage(named: "shopping_cart")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        shoppingCartBarButton.action = #selector(goToCart)
        
        navigationItem.rightBarButtonItems = [shoppingCartBarButton, uploadBarButton]
    }
    
    @objc func goToCart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let cartNav = storyboard.instantiateViewController(withIdentifier: "CartNav")
        self.present(cartNav, animated: true, completion: nil)
    }
    
    @objc func handleCheckIn(){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = true
        
        self.present(image, animated: true){
            //After picking image is complete
            print(self.imageDiffVal)
            if self.imageDiffVal < 5.0{
                
            }else{
                
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let imageName = currentProduct.getName().lowercased().replacingOccurrences(of: " ", with: "") + ".png"
            let image2 = UIImage(named: imageName)
            self.imageDiffVal = compareImages(image1: image, image2: image2!)!
            print("Image Difference = \(String(describing: imageDiffVal))")
            
            if imageDiffVal >= 5.0{
                let alert = UIAlertController(title: "Check In Failed!", message: "We detected a fake check-in attempt", preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    alert.removeFromParent()
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                picker.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Successful Check-In!", message: "You've been checked in!", preferredStyle: UIAlertController.Style.alert)
                let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    alert.removeFromParent()
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                picker.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //Couple of helper methods from online
    func pixelValues(fromCGImage imageRef: CGImage?) -> [UInt8]?
    {
        var width = 0
        var height = 0
        var pixelValues: [UInt8]?
        
        if let imageRef = imageRef {
            width = imageRef.width
            height = imageRef.height
            let bitsPerComponent = imageRef.bitsPerComponent
            let bytesPerRow = imageRef.bytesPerRow
            let totalBytes = height * bytesPerRow
            let bitmapInfo = imageRef.bitmapInfo
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            var intensities = [UInt8](repeating: 0, count: totalBytes)
            
            let contextRef = CGContext(data: &intensities,
                                       width: width,
                                       height: height,
                                       bitsPerComponent: bitsPerComponent,
                                       bytesPerRow: bytesPerRow,
                                       space: colorSpace,
                                       bitmapInfo: bitmapInfo.rawValue)
            contextRef?.draw(imageRef, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
            
            pixelValues = intensities
        }
        
        return pixelValues
    }
    
    func compareImages(image1: UIImage, image2: UIImage) -> Double? {
        guard let data1 = pixelValues(fromCGImage: image1.cgImage),
            let data2 = pixelValues(fromCGImage: image2.cgImage),
            data1.count == data2.count else {
                return nil
        }
        
        let width = Double(image1.size.width)
        let height = Double(image1.size.height)
        
        var value = zip(data1, data2).enumerated().reduce(0.0) {
                $1.offset % 4 == 3 ? $0 : $0 + abs(Double($1.element.0) - Double($1.element.1))
            }
        value*=(100/(width * height * 3.0)/255.0)
        return value
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitude = Double(locations[0].coordinate.latitude)
        self.longitude = Double(locations[0].coordinate.longitude)
        
        print("Location Manager: \(self.latitude), \(self.longitude), \(self.distEst)")
    }
    
    /*func loadRelevantBusinesses(completion: @escaping ()->()) -> [Business]{
        print("In loadRelevantBusinesses on ProductInfoVC")
        let ref: DatabaseReference = Database.database().reference()

        //self.latitude = Double((mapView.myLocation?.coordinate.latitude)) ?? 0.0
        //self.longitude = Double((mapView.myLocation?.coordinate.longitude)) ?? 0.0
        print("\(self.latitude), \(self.longitude)")
        
        ref.child("furniture").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            for (productName, productInfo) in value ?? [:]{
                if (productName as! String) == self.currentProduct.getName(){
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
                        print(self.currentBusinesses.count)
                        
                        
                    })
                }
            }
            
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return currentBusinesses
    }*/
    
    func setupProductDetailView(){
        
        /*self.view.backgroundColor = UIColor.white
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
        addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
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
        self.view.addSubview(freeShippingLabel)*/
        
        //General Background
        view.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.93, alpha:1)
        //Foreground w/ Actual Product Info
        let productLayer = UIView(frame: CGRect(x: 10, y: 104, width: (356.0*view.frame.width)/375.0, height: (708.0*view.frame.height)/812.0))
        productLayer.backgroundColor = UIColor.white
        self.view.addSubview(productLayer)
        productLayer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 15.0, paddingLeft: 10.0, paddingBottom: 15.0, paddingRight: 10.0)
        //Furniture Name
        let nameLayer = UILabel(frame: CGRect(x: 18, y: 114, width: (208.0*view.frame.width)/375.0, height: (20.0*view.frame.height)/812.0))
        nameLayer.lineBreakMode = .byWordWrapping
        nameLayer.numberOfLines = 0
        nameLayer.textColor = UIColor.black
        let nameContent = currentProduct.getName()
        let nameString = NSMutableAttributedString(string: nameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 20)!
            ])
        let nameRange = NSRange(location: 0, length: nameString.length)
        let nameStyle = NSMutableParagraphStyle()
        nameStyle.lineSpacing = 1
        nameString.addAttribute(NSAttributedString.Key.paragraphStyle, value: nameStyle, range: nameRange)
        nameString.addAttribute(NSAttributedString.Key.kern, value: 0.74, range: nameRange)
        nameLayer.attributedText = nameString
        nameLayer.sizeToFit()
        productLayer.addSubview(nameLayer)
        nameLayer.anchor(top: productLayer.topAnchor, left: productLayer.leftAnchor, bottom: nil, right: productLayer.rightAnchor, paddingTop: (10.0*view.frame.height)/812.0, paddingLeft: (8.0*view.frame.width)/375.0, paddingBottom: 0.0, paddingRight: (149.0*view.frame.width)/375.0)
        //Seller Detail Label
        let detailLayer = UILabel(frame: CGRect(x: 16, y: 162, width: (213.0*view.frame.width)/375.0, height: (14.0*view.frame.height)/812.0))
        detailLayer.lineBreakMode = .byWordWrapping
        detailLayer.numberOfLines = 0
        detailLayer.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)
        detailLayer.textAlignment = .center
        let detailContent = "See more by " + currentProduct.getSeller()
        let detailString = NSMutableAttributedString(string: detailContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 14)!
            ])
        let detailRange = NSRange(location: 0, length: detailString.length)
        let detailStyle = NSMutableParagraphStyle()
        detailStyle.lineSpacing = 1
        detailString.addAttribute(NSAttributedString.Key.paragraphStyle, value:detailStyle, range: detailRange)
        detailString.addAttribute(NSAttributedString.Key.kern, value: 0.78, range: detailRange)
        detailLayer.attributedText = detailString
        detailLayer.sizeToFit()
        productLayer.addSubview(detailLayer)
        detailLayer.anchor(top: nameLayer.bottomAnchor, left: productLayer.leftAnchor, bottom: nil, right: nil, paddingTop: 0.0, paddingLeft: (6.0*view.frame.width)/375.0, paddingBottom: 0.0, paddingRight: 0.0)
        //Stars Detail View
        /*let starsDetailLayer = UIImageView(/*frame: CGRect(x: 18, y: 186, width: 97, height: 13)*/)
        productLayer.addSubview(starsDetailLayer)
        starsDetailLayer.backgroundColor = UIColor.white
        starsDetailLayer.anchor(top: detailLayer.bottomAnchor, left: productLayer.leftAnchor, bottom: nil, right: productLayer.rightAnchor, paddingTop: (10.0*productLayer.frame.height)/708.0, paddingLeft: (8.0*productLayer.frame.width)/356.0, paddingBottom: 0.0, paddingRight: (251.0*productLayer.frame.width)/356.0, width: 0.0, height: (13.0*productLayer.frame.height)/708.0)
        starsDetailLayer.image = UIImage(named: "rating")*/

        let star1 = UIImageView(frame: CGRect(x: 13, y: 449, width: 11.39, height: 10.83))
        let star2 = UIImageView(frame: CGRect(x: 13, y: 449, width: 11.39, height: 10.83))
        let star3 = UIImageView(frame: CGRect(x: 13, y: 449, width: 11.39, height: 10.83))
        let star4 = UIImageView(frame: CGRect(x: 13, y: 449, width: 11.39, height: 10.83))
        let star5 = UIImageView(frame: CGRect(x: 13, y: 449, width: 11.39, height: 10.83))
        
        if currentProduct.getRating() >= 1.0{
            star1.image = UIImage(named: "filled_star")
        }else{
            if currentProduct.getRating() == 0.5{
                star1.image = UIImage(named: "half_star")
            }else{
                star1.image = UIImage(named: "empty_star")
            }
        }
        
        if currentProduct.getRating() >= 2.0{
            star2.image = UIImage(named: "filled_star")
        }else{
            if currentProduct.getRating() == 1.5{
                star2.image = UIImage(named: "half_star")
            }else{
                star2.image = UIImage(named: "empty_star")
            }
        }
        
        if currentProduct.getRating() >= 3.0{
            star3.image = UIImage(named: "filled_star")
        }else{
            if currentProduct.getRating() == 2.5{
                star3.image = UIImage(named: "half_star")
            }else{
                star3.image = UIImage(named: "empty_star")
            }
        }
        
        if currentProduct.getRating() >= 4.0{
            star4.image = UIImage(named: "filled_star")
        }else{
            if currentProduct.getRating() == 3.5{
                star4.image = UIImage(named: "half_star")
            }else{
                star4.image = UIImage(named: "empty_star")
            }
        }
        
        if currentProduct.getRating() == 5.0{
            star5.image = UIImage(named: "filled_star")
        }else{
            if currentProduct.getRating() == 4.5{
                star5.image = UIImage(named: "half_star")
            }else{
                star5.image = UIImage(named: "empty_star")
            }
        }
        
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
        
        productLayer.addSubview(star1)
        productLayer.addSubview(star2)
        productLayer.addSubview(star3)
        productLayer.addSubview(star4)
        productLayer.addSubview(star5)
        productLayer.addSubview(textLayer)

        star1.anchor(top: detailLayer.bottomAnchor, left: productLayer.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: (6.0*view.frame.width)/375.0, paddingBottom: 0, paddingRight: 0, width: 15.7756, height: 15.0)
        star2.anchor(top: detailLayer.bottomAnchor, left: star1.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15.7756, height: 15.0)
        star3.anchor(top: detailLayer.bottomAnchor, left: star2.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15.7756, height: 15.0)
        star4.anchor(top: detailLayer.bottomAnchor, left: star3.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15.7756, height: 15.0)
        star5.anchor(top: detailLayer.bottomAnchor, left: star4.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15.7756, height: 15.0)
        textLayer.anchor(top: detailLayer.bottomAnchor, left: star5.rightAnchor, bottom: nil, right: nil, paddingTop: 5.0, paddingLeft: 10.0, paddingBottom: 0, paddingRight: 0, width: 33.0, height: 18.0)
    
        //Furniture Image Layer
        let imageLayer = UIImageView(frame: CGRect(x: (10.0*productLayer.frame.width)/356.0, y: (114.0*view.frame.height)/708.0, width: (356.0*productLayer.frame.width)/375.0, height: (350.0*productLayer.frame.height)/708.0))
        imageLayer.backgroundColor = UIColor.black
        let imageName = currentProduct.getName().lowercased().replacingOccurrences(of: " ", with: "") + ".png"
        imageLayer.image = UIImage(named: imageName)
        productLayer.addSubview(imageLayer)
        imageLayer.anchor(top: star1.bottomAnchor, left: productLayer.leftAnchor, bottom: nil, right: productLayer.rightAnchor, paddingTop: (10.0*view.frame.height)/812.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0, width: (356.0*productLayer.frame.width)/375.0, height: (350.0*productLayer.frame.height)/708.0)
        //Various Pics Subview
        /*let imagePickerLayer = UIImageView()
        imagePickerLayer.center.x = productLayer.center.x
        imagePickerLayer.backgroundColor = UIColor.white
        imagePickerLayer.image = UIImage(named: "slider")
        productLayer.addSubview(imagePickerLayer)
        imagePickerLayer.anchor(top: imageLayer.bottomAnchor, left: productLayer.leftAnchor, bottom: productLayer.bottomAnchor, right: productLayer.rightAnchor, paddingTop: 15.0, paddingLeft: (143.0*productLayer.frame.width)/356.0, paddingBottom: -1*(290.0*productLayer.frame.height)/708.0, paddingRight: (143.0*productLayer.frame.width)/356.0) //width: (70.0*productLayer.frame.width)/356.0, height: (8.0*productLayer.frame.height)/708.0)*/
        //Locate It Button
        let locateItButtonLayer = UIView(frame: CGRect(x: 18, y: 535, width: (339.0*productLayer.frame.width)/356.0, height: (44.0*productLayer.frame.height)/708.0))
        locateItButtonLayer.layer.cornerRadius = 8
        locateItButtonLayer.layer.borderWidth = 2
        locateItButtonLayer.layer.borderColor = UIColor(red:0.2, green:0.44, blue:0.51, alpha:1).cgColor
        locateItButtonLayer.center.x = productLayer.center.x
        productLayer.addSubview(locateItButtonLayer)
        locateItButtonLayer.anchor(top: imageLayer.bottomAnchor, left: productLayer.leftAnchor, bottom: productLayer.bottomAnchor, right: productLayer.rightAnchor, paddingTop: (15.0*productLayer.frame.height)/356.0, paddingLeft:(8.5*productLayer.frame.width)/356.0, paddingBottom: -1*(180.0*productLayer.frame.height)/708.0, paddingRight:(195.0*productLayer.frame.width)/356.0, width:0.0, height:44.0)
        //Actual Button
        locateItButtonLayer.addSubview(locatorButton)
        locatorButton.anchor(top: locateItButtonLayer.topAnchor, left: locateItButtonLayer.leftAnchor, bottom: locateItButtonLayer.bottomAnchor, right: locateItButtonLayer.rightAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0)
        
        //Add To Cart Button
        let cartButtonLayer = UIView(frame: CGRect(x: 18, y: 535, width: (339.0*productLayer.frame.width)/356.0, height: (44.0*productLayer.frame.height)/708.0))
        cartButtonLayer.layer.cornerRadius = 8
        cartButtonLayer.layer.borderWidth = 2
        cartButtonLayer.layer.borderColor = UIColor(red:0.47, green:0.29, blue:0.47, alpha:1).cgColor
        cartButtonLayer.center.x = productLayer.center.x
        productLayer.addSubview(cartButtonLayer)
        cartButtonLayer.anchor(top: imageLayer.bottomAnchor, left: locateItButtonLayer.rightAnchor, bottom: productLayer.bottomAnchor, right: productLayer.rightAnchor, paddingTop: (15.0*productLayer.frame.height)/356.0, paddingLeft:(34.0*productLayer.frame.width)/356.0, paddingBottom: -1*(180.0*productLayer.frame.height)/708.0, paddingRight:(8.5*productLayer.frame.width)/356.0, width:0.0, height:44.0)
        let addToCartButton = UIButton()
        cartButtonLayer.addSubview(addToCartButton)
        addToCartButton.anchor(top: cartButtonLayer.topAnchor, left: cartButtonLayer.leftAnchor, bottom: cartButtonLayer.bottomAnchor, right: cartButtonLayer.rightAnchor, paddingTop: 0.0, paddingLeft: 0.0, paddingBottom: 0.0, paddingRight: 0.0)
        addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        //Add To Cart Text
        let cartTextLayer = UILabel()
        cartTextLayer.lineBreakMode = .byWordWrapping
        cartTextLayer.numberOfLines = 0
        cartTextLayer.textColor = UIColor(red:0.47, green:0.29, blue:0.47, alpha:1)
        cartTextLayer.textAlignment = .center
        let cartTextContent = "Add To Cart"
        let cartTextString = NSMutableAttributedString(string: cartTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 18)!
            ])
        let cartTextRange = NSRange(location: 0, length: cartTextString.length)
        let cartTextStyle = NSMutableParagraphStyle()
        cartTextStyle.lineSpacing = 1
        cartTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value:cartTextStyle, range: cartTextRange)
        cartTextString.addAttribute(NSAttributedString.Key.kern, value: 0.93, range: cartTextRange)
        cartTextLayer.attributedText = cartTextString
        cartTextLayer.sizeToFit()
        cartButtonLayer.addSubview(cartTextLayer)
        cartTextLayer.anchor(top: cartButtonLayer.topAnchor, left: cartButtonLayer.leftAnchor, bottom: cartButtonLayer.bottomAnchor, right: nil, paddingTop: (13.0*cartButtonLayer.frame.height)/44.0, paddingLeft: (25.0*cartButtonLayer.frame.width)/339.0, paddingBottom: -1*(14.0*cartButtonLayer.frame.height)/44.0, paddingRight: 0.0)
        //Locate It Icon
        let locateItIconLayer = UIImageView()
        locateItIconLayer.backgroundColor = UIColor.white
        locateItIconLayer.image = UIImage(named: "locate_icon")
        locateItButtonLayer.addSubview(locateItIconLayer)
        locateItIconLayer.anchor(top: locateItButtonLayer.topAnchor, left: locateItButtonLayer.leftAnchor, bottom: locateItButtonLayer.bottomAnchor, right: nil, paddingTop: (8.0*locateItButtonLayer.frame.height)/44.0, paddingLeft: (15.0*locateItButtonLayer.frame.width)/339.0, paddingBottom: -1*(8.0*locateItButtonLayer.frame.height)/44.0, paddingRight: 0.0, width: 28.0, height: 20.0)
        //Locate It Text
        let locateTextLayer = UILabel()
        locateTextLayer.lineBreakMode = .byWordWrapping
        locateTextLayer.numberOfLines = 0
        locateTextLayer.textColor = UIColor(red:0.2, green:0.44, blue:0.51, alpha:1)
        locateTextLayer.textAlignment = .center
        
        var locateTextContent = "Locate it"
        self.distEst = abs(self.latitude-currentProduct.getLatitude())+abs(self.longitude-currentProduct.getLongitude())
        let closeToFurniture =  self.distEst < 0.004
        /*for business in self.currentBusinesses{
            let businessLatitude = business.getLatitude()
            let businessLongitude = business.getLongitude()
            let distanceEst = abs(self.latitude-businessLatitude)+abs(self.longitude-businessLongitude)
            print("Current Distance Estimate \(distanceEst)")
            if distanceEst < 0.003{
                closeToFurniture = true
            }
        }*/
        
        if closeToFurniture{
            locateTextContent = "Check In"
            locatorButton.addTarget(self, action: #selector(handleCheckIn), for: .touchUpInside)
        }else{
            locatorButton.addTarget(self, action: #selector(navigateToLocations), for: .touchUpInside)
        }
        
        
        
        let locateTextString = NSMutableAttributedString(string: locateTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 18)!
            ])
        let locateTextRange = NSRange(location: 0, length: locateTextString.length)
        let locateTextStyle = NSMutableParagraphStyle()
        locateTextStyle.lineSpacing = 1
        locateTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value:locateTextStyle, range: locateTextRange)
        locateTextString.addAttribute(NSAttributedString.Key.kern, value: 0.93, range: locateTextRange)
        locateTextLayer.attributedText = locateTextString
        locateTextLayer.sizeToFit()
        locateItButtonLayer.addSubview(locateTextLayer)
        locateTextLayer.anchor(top: locateItButtonLayer.topAnchor, left: locateItButtonLayer.leftAnchor, bottom: locateItButtonLayer.bottomAnchor, right: nil, paddingTop: (13.0*locateItButtonLayer.frame.height)/44.0, paddingLeft: (50.625*locateItButtonLayer.frame.width)/339.0, paddingBottom: -1*(14.0*locateItButtonLayer.frame.height)/44.0, paddingRight: 0.0)
        //Price Label
        let priceLayer = UILabel(/*frame: CGRect(x: 23, y: 601, width: 97, height: 24)*/)
        priceLayer.lineBreakMode = .byWordWrapping
        priceLayer.numberOfLines = 0
        priceLayer.textColor = UIColor.black
        priceLayer.textAlignment = .center
        let priceContent = "$"+String(currentProduct.getPrice())
        let priceString = NSMutableAttributedString(string: priceContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 19)!
            ])
        let priceRange = NSRange(location: 0, length: priceString.length)
        let priceStyle = NSMutableParagraphStyle()
        priceStyle.lineSpacing = 1
        priceString.addAttribute(NSAttributedString.Key.paragraphStyle, value:priceStyle, range: priceRange)
        priceString.addAttribute(NSAttributedString.Key.kern, value: 0.93, range: priceRange)
        priceLayer.attributedText = priceString
        priceLayer.sizeToFit()
        productLayer.addSubview(priceLayer)
        priceLayer.anchor(top: locateItButtonLayer.bottomAnchor, left: productLayer.leftAnchor, bottom: nil, right: nil, paddingTop: (22.0*productLayer.frame.height)/708.0, paddingLeft: (13.0*productLayer.frame.width)/356.0, paddingBottom: 0.0, paddingRight: 0.0, width: (97.0*productLayer.frame.width)/356.0, height: (24.0*productLayer.frame.height)/708.0)
        //Free Shipping Label
        let shippingLayer = UILabel(frame: CGRect(x: 23, y: 639, width: 115, height: 16))
        shippingLayer.lineBreakMode = .byWordWrapping
        shippingLayer.numberOfLines = 0
        shippingLayer.textColor = UIColor.black
        shippingLayer.textAlignment = .center
        let shippingContent = "FREE Shipping"
        let shippingString = NSMutableAttributedString(string: shippingContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Medium", size: 14)!
            ])
        let shippingRange = NSRange(location: 0, length: shippingString.length)
        let shippingStyle = NSMutableParagraphStyle()
        shippingStyle.lineSpacing = 1.06
        shippingString.addAttribute(NSAttributedString.Key.paragraphStyle, value:shippingStyle, range: shippingRange)
        shippingString.addAttribute(NSAttributedString.Key.kern, value: 0.75, range: shippingRange)
        shippingLayer.attributedText = shippingString
        shippingLayer.sizeToFit()
        productLayer.addSubview(shippingLayer)
        shippingLayer.anchor(top: priceLayer.bottomAnchor, left: productLayer.leftAnchor, bottom: nil, right: nil, paddingTop: (14.0*productLayer.frame.height)/708.0, paddingLeft: (13.0*productLayer.frame.width)/356.0, paddingBottom: 0.0, paddingRight: 0.0, width: (115.0*productLayer.frame.width)/356.0, height: 0.0)
        //Additional Info
        let additionalInfoLayer = UILabel()
        additionalInfoLayer.lineBreakMode = .byWordWrapping
        additionalInfoLayer.numberOfLines = 0
        additionalInfoLayer.textColor = UIColor.black
        additionalInfoLayer.textAlignment = .center
        let additionalInfoContent = "Get it by Thu, Nov 29"
        let additionalInfoString = NSMutableAttributedString(string: additionalInfoContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 16)!
            ])
        additionalInfoString.addAttribute(NSAttributedString.Key.foregroundColor,value: UIColor.darkGray, range: NSRange(location: 0, length: 9))
        let additionalInfoRange = NSRange(location: 0, length: additionalInfoString.length)
        let additionalInfoStyle = NSMutableParagraphStyle()
        additionalInfoStyle.lineSpacing = 1.06
        additionalInfoString.addAttribute(NSAttributedString.Key.paragraphStyle, value:additionalInfoStyle, range: additionalInfoRange)
        additionalInfoString.addAttribute(NSAttributedString.Key.kern, value: 0.75, range: additionalInfoRange)
        additionalInfoLayer.attributedText = additionalInfoString
        additionalInfoLayer.sizeToFit()
        productLayer.addSubview(additionalInfoLayer)
        additionalInfoLayer.anchor(top: shippingLayer.bottomAnchor, left: productLayer.leftAnchor, bottom: nil, right: nil, paddingTop: (14.0*productLayer.frame.height)/708.0, paddingLeft: (13.0*productLayer.frame.width)/356.0, paddingBottom: 0.0, paddingRight: 0.0, width: 0.0, height: 0.0)
        
    }
    
    @objc func navigateToLocations(sender: UIButton){
        print("Locate It tapped!")
        let locationController = LocationViewController()
        locationController.currentProductName = currentProduct.getName()
        self.navigationController?.pushViewController(locationController, animated: false)
        //self.tabBarController?.selectedIndex = 2
    }
    
    @objc func addToCart(sender: UIButton){
        
        let shapeLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: self.view.center, radius: 100, startAngle: -CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
        
        let databaseRef = Database.database().reference()
        let cartItem: [String: String] = ["name": currentProduct.getName()]
        let cartRef = databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).child("cart").childByAutoId()
        cartRef.setValue(cartItem)
        
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
    }
}
