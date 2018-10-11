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
    var room: String
    
    init(committee: String, room: String) {
        self.committee = committee
        self.room = room
    }
}
