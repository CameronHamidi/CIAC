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
    var information: String?
    
    init(event: String, identifier: String) {
        self.event = event
        self.identifier = identifier
    }
    
    init(event: String, identifier: String, information: String?) {
        self.event = event
        self.identifier = identifier
        self.information = information
    }
}

class DayItem {
    var day: String
    var events: [EventItem]
    var information: String?
    
    init(day: String, events: [EventItem]) {
        self.day = day
        self.events = events
    }
    
    init(day: String, events: [EventItem], information: String?) {
        self.day = day
        self.events = events
        self.information = information
    }
    
    init() {
        self.day = ""
        self.events = [EventItem]()
    }
}
