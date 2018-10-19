//
//  RoomItem.swift
//  CIAC
//
//  Created by Cameron Hamidi on 10/4/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import Foundation

class RoomItem {
    var committee: String
    var image: String
    var rooms: [String]
    
    init(committee: String, image: String, rooms: [String]) {
        self.committee = committee
        self.image = image
        self.rooms = rooms
    }
}
