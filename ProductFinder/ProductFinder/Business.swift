//
//  Business.swift
//  ProductFinder
//
//  Created by Shailesh Phadke on 11/3/18.
//  Copyright © 2018 Karim Arem. All rights reserved.
//

import Foundation

class Business: NSObject{
    
    private var name: String
    private var address: String
    private var note: String
    private var latitude: Double
    private var longitude: Double
    private var type: String
    private var id: String
    private var open: Double
    private var close: Double
    private var rating: Double
    private var price: String
    
    override init(){
        self.name = ""
        self.address = ""
        self.note = ""
        self.type = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.id = ""
        self.open = 0.0
        self.close = 0.0
        self.rating = 0.0
        self.price = ""
    }
    
    init(name: String, address: String, note: String, type: String, latitude: Double, longitude: Double, id: String, open: Double, close: Double, rating: Double, price: String){
        self.name = name
        self.address = address
        self.note = note
        self.type = type
        self.latitude = latitude
        self.longitude = longitude
        self.id = id
        self.open = open
        self.close = close
        self.rating = rating
        self.price = price
    }
    
    func getName() -> String{
        return self.name
    }
    
    func setName(newName: String){
        self.name = newName
    }
    
    func getAddress() -> String{
        return self.address
    }
    
    func setAddress(newAddress: String){
        self.address = newAddress
    }
    
    func getNote() -> String{
        return self.note
    }
    
    func setNote(newNote: String){
        self.note = newNote
    }
    
    func getType() -> String{
        return self.type
    }
    
    func setType(newType: String){
        self.type = newType
    }
    
    func getLatitude() -> Double{
        return self.latitude
    }
    
    func setLatitude(newLatitude: Double){
        self.latitude = newLatitude
    }
    
    func getLongitude() -> Double{
        return self.longitude
    }
    
    func setLongitude(newLongitude: Double){
        self.longitude = newLongitude
    }
    
    func getID() -> String{
        return self.id
    }
    
    func setID(newId: String){
        self.id = newId
    }
    
    func getOpen() -> Double{
        return self.open
    }
    
    func setOpen(open: Double){
        self.open = open
    }
    
    func getClose() -> Double{
        return self.close
    }
    
    func setClose(close: Double){
        self.close = close
    }
    
    func getPrice() -> String{
        return self.price
    }
    
    func setPrice(price: String){
        self.price = price
    }
    
    func getRating() -> Double{
        return self.rating
    }
    
    func setRating(rating: Double){
        self.rating = rating
    }
}
