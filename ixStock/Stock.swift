//
//  Stock.swift
//  ixStock
//
//  Created by Kaiming Cheng on 7/12/17.
//  Copyright © 2017 Kaiming Cheng. All rights reserved.
//

import Foundation

//after retriving data from json file, we want to classify different parameter so we could use i
//that's why we create a class file called stock



class Stock {
    //parameters
    var date: Date?
    var open: Double?
    var high: Double?
    var low: Double?
    var close: Double?
    var volume: Int?
    
    //test if this is necessary
    //look into init function (why ?, )
    init?() {
        self.date = Date()
        self.open = 0.0
        self.high = 0.0
        self.low = 0.0
        self.close = 0.0
       // self.volume = 0
    }
    
    //how to create a dictionary
    
    //here we create a dictionary with type of string, dictionary[key] gets the value we want 
    
    
    init?(dictionary: [String: AnyObject]) {
        self.open = Double(dictionary["1. open"] as! String)
        self.high = Double(dictionary["2. high"] as! String)
        self.low = Double(dictionary["3. low"] as! String)
        self.close = Double(dictionary["4. close"] as! String)
        //self.volume = dictionary["5. volume"] as? String
    }
    
}











