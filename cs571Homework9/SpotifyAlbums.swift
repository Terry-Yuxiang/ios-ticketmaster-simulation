//
//  SpotifyAlbums.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/9/23.
//

import SwiftUI

struct SpotifyAlbums: Codable, Identifiable {
    var id: String?
    var items: [Items]
    
    struct Items: Codable {
        var images: [Images]
        
        struct Images: Codable {
            var url: String
        }
    }
}


