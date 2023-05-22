//
//  DetailsCardTabs.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/8/23.
//

import SwiftUI

struct DetailsCardTabs: View {
    let item: TableSection
    
    var body: some View {
            TabView {
                EventsTab(item: item)
                    .tabItem {
                        Label("Events", systemImage: "text.bubble.fill")
                    }
                ArtistTeamTab(item: item)
                    .tabItem {
                        Label("Artist/Team", systemImage: "guitars.fill")
                    }
                VenueTab(item: item)
                    .tabItem {
                        Label("Venue", systemImage: "location.fill")
                    }
            }
            .navigationBarHidden(false)
    }
}

struct DetailsCardTabs_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCardTabs(item: TableSection(id: "sample-id", name: "sample-name", dates: TableSection.Dates(start: TableSection.Dates.Start(localDate: "sample-date", localTime: "sample-date")), images: [TableSection.Image(url: "sample-url")], _embedded: TableSection.Embedded(venues: [TableSection.Embedded.Venue(name: "sample-venue-name")]), classifications: [TableSection.Classifications(segment: TableSection.Classifications.Segment(name: "sample-classification"))]))
    }
}
