//
//  Product.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 11/2/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import Foundation

class Product: NSObject{
    private var name: String
    private var seller: String
    private var type: String
    private var price: Double
    private var rating: Double
    private var latitude: Double
    private var longitude: Double
    
    override init(){
        self.name = ""
        self.seller = ""
        self.type = ""
        self.price = 0.0
        self.rating = 0.0
        self.latitude = 0.0
        self.longitude = 0.0
    }
    
    init(productName: String, productSeller: String, productType: String, productPrice: Double, productRating: Double, productLatitude: Double, productLongitude: Double){
        self.name = productName
        self.seller = productSeller
        self.type = productType
        self.price = productPrice
        self.rating = productRating
        self.latitude = productLatitude
        self.longitude = productLongitude
    }
    
    func getName() -> String{
        return self.name
    }
    
    func setName(newName: String){
        self.name = newName
    }
    
    func getSeller() -> String{
        return self.seller
    }
    
    func setSeller(newSeller: String){
        self.seller = newSeller
    }
    
    func getType() -> String{
        return self.type
    }
    
    func setType(newType: String){
        self.type = newType
    }
    
    func setPrice(newPrice: Double){
        self.price = newPrice
    }
    
    func getPrice() -> Double{
        return self.price
    }
    
    func setRating(newRating: Double){
        self.rating = newRating
    }
    
    func getRating() -> Double{
        return self.rating
    }
    
    func setLatitude(newLatitude: Double){
        self.latitude = newLatitude
    }
    
    func getLatitude() -> Double{
        return self.latitude
    }
    
    func setLongitude(newLongitude: Double){
        self.longitude = newLongitude
    }
    
    func getLongitude() -> Double{
        return self.longitude
    }
    
}

