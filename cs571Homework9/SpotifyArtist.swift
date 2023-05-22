//
//  SpotifyArtist.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/9/23.
//

import SwiftUI
import Foundation

struct SpotifyArtist: Codable, Identifiable {
    var id: String?
    var artists: Artists
    
    struct Artists: Codable {
        var items: [Item]
        
        struct Item: Codable {
            var name: String
            var popularity: Float
            var images: [Images]
            var followers: Followers
            var external_urls: External_urls
            var id: String
            
            struct Images: Codable {
                var url: String
            }
            
            struct Followers: Codable {
                var total: Int // 可能需要改成int
            }
            
            struct External_urls: Codable {
                var spotify: String
            }
        }
    }
    
   
}


