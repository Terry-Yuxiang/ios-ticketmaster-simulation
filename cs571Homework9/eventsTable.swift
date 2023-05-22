//
//  eventsTable.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/7/23.
//

import Foundation
import SwiftUI

struct TableSection: Codable, Identifiable {
    var id: String
    var name: String
    var dates: Dates
    var images: [Image]
    var _embedded: Embedded
    var classifications: [Classifications]
    
    struct Classifications: Codable {
        var segment: Segment
        
        struct Segment: Codable {
            var name: String
        }
    }
    
    struct Embedded: Codable {
        var venues: [Venue]
        
        struct Venue: Codable {
            var name: String
        }
    }
    
    struct Image: Codable {
        var url: String
    }
    
    struct Dates: Codable {
        var start: Start
        
        struct Start: Codable {
            var localDate: String?
            var localTime: String?
        }
    }
}









