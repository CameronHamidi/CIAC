//
//  BusItem.swift
//  CIAC
//
//  Created by Cameron Hamidi on 10/29/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import Foundation

class BusItem {
    var name: String
    var time: String
    
    init(name: String, time: String) {
        self.name = name
        self.time = time
    }
}

class BusDayItem {
    var day: String
    var busItems : [BusItem]
    
    init(day: String, busItems: [BusItem]) {
        self.day = day
        self.busItems = busItems
    }
}
