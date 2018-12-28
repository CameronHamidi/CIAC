//
//  HeadDelDataResponse.swift
//  CIAC
//
//  Created by Cameron Hamidi on 12/27/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import Foundation

class HeadDelDataResponse: Codable {
    var secretariatInfo: [SecretariatInfoResponse]
    var meetings: [MeetingItem]
}

class SecretariatInfoResponse: Codable {
    var name: String
    var role: String
    var email: String
}

class MeetingItem: Codable {
    var date: String
    var description: String
    
    init(date: String, description: String) {
        self.date = date
        self.description = description
    }
}
