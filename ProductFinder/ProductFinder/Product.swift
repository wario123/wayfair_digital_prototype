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
    
    override init(){
        self.name = ""
        self.seller = ""
        self.type = ""
        self.price = 0.0
    }
    
    init(productName: String, productSeller: String, productType: String, productPrice: Double){
        self.name = productName
        self.seller = productSeller
        self.type = productType
        self.price = productPrice
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
}
