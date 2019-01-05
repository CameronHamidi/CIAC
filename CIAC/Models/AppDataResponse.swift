//
//  AppDataResponse.swift
//  CIAC
//
//  Created by Cameron Hamidi on 12/29/18.
//  Copyright © 2018 Cornell International Affairs Conference. All rights reserved.
//

import Foundation

class AppDataResponse: Codable {
    var headDelPassword: String
    var staffPassword: String
    var conferenceStartDate: String
    var numConferenceDays: Int
    var committeeTimes: [CommitteeTime]
}

class CommitteeTime: Codable {
    var start: String
    var end: String
}
