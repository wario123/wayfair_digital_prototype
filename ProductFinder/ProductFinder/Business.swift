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
    
    init(name: String, address: String, note: String, type: String, latitude: Double, longitude: Double, id: String){
        self.name = name
        self.address = address
        self.note = note
        self.type = type
        self.latitude = latitude
        self.longitude = longitude
        self.id = id
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
}
