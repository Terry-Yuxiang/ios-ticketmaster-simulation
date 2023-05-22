//
//  ajaxRequest.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/7/23.
//

import Foundation
import Combine
import Alamofire


class AjaxRequest: ObservableObject {
    
    @Published var autoCompleteResult: AutoCompleteResult? = nil
    @Published var autoCompleteResultDone = false
    @Published var events: [TableSection] = []
    @Published var eventsRequestDone = false
    @Published var details: EventDetail? = nil
    @Published var detailsRequestDone = false
    @Published var noMusic = true
    @Published var artists: SpotifyArtist? = nil
    @Published var artistsArray: [String: SpotifyArtist] = [:]
    @Published var albums: SpotifyAlbums? = nil
    @Published var albumsArray: [String: SpotifyAlbums] = [:]
    @Published var venue: VenueDetail? = nil
    @Published var venueLocation: MapLocation? = nil
    
    func autoComplete(word: String) {
        if let encodedUrlString = "https://inbound-trainer-382006.wl.r.appspot.com/auto-complete?word=\(word)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedUrlString) {
            AF.request(url).responseDecodable(of: AutoCompleteResult.self) { response in
                switch response.result {
                case .success(let autoCompleteResult):
                    DispatchQueue.main.async {
                        self.autoCompleteResult = autoCompleteResult
                        self.autoCompleteResultDone = true
//                        print(self.autoCompleteResult)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    

    func eventSearch(keyword: String, distance: String, categories: String, location: String) {
        if let encodedUrlString = "https://inbound-trainer-382006.wl.r.appspot.com/events-search?keyword=\(keyword)&distance=\(distance)&category=\(categories)&location=\(location)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedUrlString) {
            AF.request(url).responseDecodable(of: [TableSection].self) { response in
                switch response.result {
                case .success(let events):
                    DispatchQueue.main.async {
                        self.events = events
//                        print(events)
                        self.eventsRequestDone = true
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func eventDetail(eventId: String) {
        if let encodedUrlString = "https://inbound-trainer-382006.wl.r.appspot.com/events-detail?word=\(eventId)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedUrlString) {
            AF.request(url)
                .responseDecodable(of:EventDetail.self){ response in
                    switch response.result {
                    case .success(let details):
                        DispatchQueue.main.async {
                            self.details = details
                            self.detailsRequestDone = true
                            if (self.details?._embedded?.attractions?.first?.classifications?.first?.segment?.name == "Music") {
                                self.noMusic = false
                                print(self.noMusic)
                            }
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
        }
    }
    
    func spotifyArtist(artistName: String) {
        if let encodedUrlString = "https://inbound-trainer-382006.wl.r.appspot.com/spotifyArtist?name=\(artistName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedUrlString) {
            AF.request(url)
                .responseDecodable(of:SpotifyArtist.self){ response in
                    switch response.result {
                    case .success(let artists):
                        DispatchQueue.main.async {
                            self.artists = artists
                            self.artistsArray[artistName] = artists
                            self.spotifyAlbums(artistId: self.artists?.artists.items.first?.id ?? "")
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
        }
    }
    
    func spotifyAlbums(artistId: String) {
        if let encodedUrlString = "https://inbound-trainer-382006.wl.r.appspot.com/spotifyArtistAlbums?id=\(artistId)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedUrlString) {
            AF.request(url)
                .responseDecodable(of:SpotifyAlbums.self){ response in
                    switch response.result {
                    case .success(let albums):
                        DispatchQueue.main.async {
                            self.albums = albums
                            print(albums)
                            self.albumsArray[artistId] = albums
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
        }
    }
    
    func venueName(eventId: String) {
        AF.request("https://inbound-trainer-382006.wl.r.appspot.com/events-detail?word=\(eventId)")
            .responseDecodable(of:EventDetail.self){ response in
                switch response.result {
                case .success(let details):
                    DispatchQueue.main.async {
                        self.details = details
                        self.venueDetail(venueName: details._embedded?.venues?.first?.name ?? "")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    func venueDetail(venueName: String) {
        if let encodedUrlString = "https://inbound-trainer-382006.wl.r.appspot.com/venueDetail?venue=\(venueName)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedUrlString) {
            AF.request(url)
                .responseDecodable(of:VenueDetail.self){ response in
                    switch response.result {
                    case .success(let venue):
                        DispatchQueue.main.async {
                            self.venue = venue
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
        }
    }
    
    func googleMapLocation(locationName: String) {
        if let encodedUrlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(locationName)&key=AIzaSyCbF7-MBwO2GFg3qP-0VTk1n-DJIfcWuT8".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encodedUrlString) {
            AF.request(url)
                .responseDecodable(of:MapLocation.self){ response in
                    switch response.result {
                    case .success(let venueLocation):
                        DispatchQueue.main.async {
                            self.venueLocation = venueLocation
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
        }
    }
    

    func clearButton() {
        events.removeAll()
        self.eventsRequestDone = false
        self.detailsRequestDone = false
    }
}





