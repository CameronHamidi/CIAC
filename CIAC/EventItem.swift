//
//  EventItem.swift
//  CIAC
//
//  Created by Cameron Hamidi on 9/1/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import Foundation

class EventItem {
    var event: String
    var identifier: String
    
    init(event: String, identifier: String) {
        self.event = event
        self.identifier = identifier
    }
}

class DayItem {
    var day: String
    var events: [EventItem]
    
    init(day: String, events: [EventItem]) {
        self.day = day
        self.events = events
    }
    
    init() {
        self.day = ""
        self.events = [EventItem]()
    }
}
