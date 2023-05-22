//
//  ArtistTeamTab.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/8/23.
//

import SwiftUI
import Kingfisher

struct ArtistTeamTab: View {
    
    let item: TableSection
    @StateObject private var ajaxRequest = AjaxRequest()
    
    var artistNames: [String] { // get artist and team text
        var sample: [String] = []
        if let attractions = ajaxRequest.details?._embedded?.attractions {
            for artist in attractions {
                sample.append(artist.name)
            }
        }
        return sample
    }
    
    var body: some View {
        
        VStack {
            if(ajaxRequest.detailsRequestDone) {
                VStack {
                    if(ajaxRequest.noMusic) {
                        VStack {
                            Text("No music related artist details to show")
                                .font(.system(size: 35))
                                .bold()
                                .multilineTextAlignment(.center)
                        }
                        .background(Color.white)
                    }
                    if(!ajaxRequest.noMusic) {
                        Spacer()
                        Form {
                            ForEach(artistNames.indices, id: \.self) { index in
                                Section(header: EmptyView(), footer: EmptyView()) {
                                    VStack (alignment:.leading, spacing: 0) {
                                        HStack {
                                            HStack  {
                                                if let artistImageUrl = ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.images.first?.url, let URL_artistImageUrl = URL(string: artistImageUrl) {
                                                    KFImage(URL_artistImageUrl)
                                                        .resizable()
                                                }
                                            }
                                            .frame(width: 120, height: 120)
                                            .cornerRadius(15)
                                            HStack (spacing: 0) {
                                                VStack (spacing: 0) {
                                                    HStack {
                                                        Text(ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.name ?? "")
                                                            .font(.system(size: 20))
                                                            .bold()
                                                            .foregroundColor(Color.white)
                                                    }
                                                    .frame(width: 120, height: 40)
                                                    
                                                    HStack {
                                                        if Float(ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.followers.total ?? 0) > 1000000 {
                                                            Text(String(Float((ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.followers.total ?? 0)) / 1000000).prefix(3) + "M")
                                                                .foregroundColor(Color.white)
                                                                .bold()
                                                        }
                                                        else if Float(ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.followers.total ?? 0) > 1000 {
                                                            Text(String(Float((ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.followers.total ?? 0)) / 1000).prefix(3) + "K")
                                                                .foregroundColor(Color.white)
                                                                .bold()
                                                        }
                                                        Text("Followers")
                                                            .foregroundColor(Color.white)
                                                            .font(.system(size: 14))
                                                    }
                                                    .frame(width: 120, height: 40)
                                                    
                                                    HStack {
                                                        if let spotifyURL = ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.external_urls.spotify, let URL_spotifyURL = URL(string: spotifyURL) {
                                                            Link(destination: URL_spotifyURL) {
                                                                HStack {
                                                                    Image("spotify_logo")
                                                                        .resizable()
                                                                        .scaledToFit()
                                                                    Text("Spotify")
                                                                        .foregroundColor    (Color.green)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    .frame(width: 120, height: 40)
                                                }
                                                .frame(width: 120, height: 120)
                                                
                                                VStack {
                                                    Text("Popularity")
                                                        .foregroundColor(Color.white)
                                                    
                                                    
                                                    ZStack {
                                                        Circle()
                                                            .stroke(lineWidth: 15)
                                                            .opacity(0.3)
                                                            .foregroundColor(.orange)
                                                        Circle()
                                                            .trim(from: 0.0, to: CGFloat((ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.popularity ?? 0) / 100))
                                                            .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .butt, lineJoin: .round))
                                                            .foregroundColor(.orange)
                                                            .rotationEffect(Angle(degrees: -90))
                                                            .rotationEffect(Angle(degrees: 90), anchor: .center)
                                                        
                                                        Text(String(Int(ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.popularity ?? 0)))
                                                            .foregroundColor(Color.white)
                                                    }
                                                    .frame(width: 60, height: 70)
                                                }
                                                .frame(width: 80, height: 120)
                                            }
                                            .frame(width: 200, height: 120)
                                        }
                                        .frame(width: 350, height: 150)
                                        HStack  {
                                            VStack (spacing: 0) {
                                                HStack {
                                                    Text("Popular Albums")
                                                        .font(.system(size: 20))
                                                        .bold()
                                                        .foregroundColor(Color.white)
                                                        .padding(.leading, 20)
                                                    Spacer()
                                                }
                                                .padding(.bottom, 5)
                                                
                                                HStack {
                                                    if let albumImageUrl = ajaxRequest.albumsArray[ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.id ?? ""]?.items[0].images[0].url, let URL_albumImageUrl = URL(string: albumImageUrl) {
                                                        HStack {
                                                            KFImage(URL_albumImageUrl)
                                                                .resizable()
                                                        }
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(10)
                                                    }
                                                    
                                                    if let albumImageUrl = ajaxRequest.albumsArray[ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.id ?? ""]?.items[1].images[0].url, let URL_albumImageUrl = URL(string: albumImageUrl) {
                                                        HStack {
                                                            KFImage(URL_albumImageUrl)
                                                                .resizable()
                                                        }
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(10)
                                                    }
                                                    
                                                    if let albumImageUrl = ajaxRequest.albumsArray[ajaxRequest.artistsArray[artistNames[index]]?.artists.items.first?.id ?? ""]?.items[2].images[0].url, let URL_albumImageUrl = URL(string: albumImageUrl) {
                                                        HStack {
                                                            KFImage(URL_albumImageUrl)
                                                                .resizable()
                                                        }
                                                        .frame(width: 100, height: 100)
                                                        .cornerRadius(10)
                                                    }
                                                }
                                            }
                                            
                                        }
                                        .frame(width: 350, height: 150)
                                    }
                                    .frame(width: 350, height: 300)
                                    .background(Color(red:69/255 , green:69/255 , blue:69/255))
                                    .cornerRadius(10)
                                    .onAppear {
                                        ajaxRequest.spotifyArtist(artistName: artistNames[index])
                                    }
                                    .padding(0)
                                }
                                .listRowInsets(EdgeInsets())
                            }
                        }
                        Spacer()
                    }
                }
                .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                .padding(.top, -5)
                
            }
        }
        .onAppear {
            ajaxRequest.eventDetail(eventId: item.id)
        }
        
    }
    
}

struct ArtistTeamTab_Previews: PreviewProvider {
    static var previews: some View {
        ArtistTeamTab(item: TableSection(id: "sample-id", name: "sample-name", dates: TableSection.Dates(start: TableSection.Dates.Start(localDate: "sample-date", localTime: "sample-date")), images: [TableSection.Image(url: "sample-url")], _embedded: TableSection.Embedded(venues: [TableSection.Embedded.Venue(name: "sample-venue-name")]), classifications: [TableSection.Classifications(segment: TableSection.Classifications.Segment(name: "sample-classification"))]))
    }
}
