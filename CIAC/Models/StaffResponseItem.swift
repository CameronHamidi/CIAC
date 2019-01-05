//
//  StaffResponseItem.swift
//  CIAC
//
//  Created by Cameron Hamidi on 12/27/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import Foundation

class StaffResponseItem: Codable {
    var staffRooms: [StaffRoomsItem]
    var sessions: [String]
}

class StaffRoomsItem: Codable {
    var name: String
    var rooms: [String]
}
