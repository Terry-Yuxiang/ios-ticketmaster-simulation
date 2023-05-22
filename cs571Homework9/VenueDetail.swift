//
//  VenueDetail.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/10/23.
//

import SwiftUI
import Foundation

struct VenueDetail: Codable, Identifiable {
    var id: String?
    var _embedded: Embedded?
    
    struct Embedded: Codable {
        var venues: [Venues]?
        
        struct Venues: Codable {
            var name: String?
            var address: Address?
            var boxOfficeInfo: BoxOfficeInfo?
            var generalInfo: GeneralInfo?
            
            struct Address: Codable {
                var line1: String?
            }
            
            struct BoxOfficeInfo: Codable {
                var phoneNumberDetail: String?
                var openHoursDetail: String?
            }
            
            struct GeneralInfo: Codable {
                var generalRule: String?
                var childRule: String?
            }
        }
    }
}
