//
//  eventDetail.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/8/23.
//

import Foundation
import SwiftUI

struct EventDetail: Codable, Identifiable {
    var name: String
    var type: String
    var id: String
    var url: String
    var dates: Dates?
    var _embedded: Embedded?
    var classifications: [Classification]?
    var priceRanges: [PriceRange]?
    var seatmap: Seatmap?
    
    struct Seatmap: Codable {
        var staticUrl: String?
    }
    
    struct Dates: Codable {
        var start: LocalDate?
        struct LocalDate: Codable {
            var localDate: String?
        }

        var status: Status?
        struct Status: Codable {
            var code: String?
        }
    }

    struct Embedded: Codable {
        var venues: [Venue]?
        struct Venue: Codable {
            var name: String?
        }

        var attractions: [Attraction]?
        struct Attraction: Codable, Identifiable {
            var id:String?
            var name: String
            var classifications: [Classifications]?
            struct Classifications: Codable {
                var segment: Segment?
                struct Segment: Codable {
                    var name: String?
                }
            }
        }
    }

    struct Classification: Codable {
        var segment: Name?
        var genre: Name?
        var subGenre: Name?
        var type: Name?
        var subType: Name?
        struct Name: Codable {
            var name: String?
        }
    }

    struct PriceRange: Codable {
        var min: Double?
        var max: Double?
    }
}





