//
//  AutoCompleteResult.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/30/23.
//

import Foundation


struct AutoCompleteResult: Codable, Identifiable {
    var id: String?
    var _embedded: Embedded?
    
    struct Embedded: Codable {
        var attractions: [Attractions]?
        
        struct Attractions: Codable, Identifiable {
            var id: String?
            var name: String?
        }
    }
}
