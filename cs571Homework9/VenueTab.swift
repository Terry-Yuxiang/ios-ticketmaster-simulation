//
//  VenueTab.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/8/23.
//

import SwiftUI

struct VenueTab: View {
    let item: TableSection
    @StateObject private var ajaxRequest = AjaxRequest()
    @State private var showMaps = false

    var body: some View {
        VStack {
            Text(item.name)
                .font(.system(size: 24))
                .bold()
                .padding(.bottom, 5)
            if ((ajaxRequest.venue?._embedded?.venues?.first?.name) != nil) {
                VStack {
                    Text("Name")
                        .font(.system(size: 20))
                        .bold()
                    Text(ajaxRequest.venue?._embedded?.venues?.first?.name ?? "sample-venue")
                        .foregroundColor(Color.gray)
                }
                .padding(.bottom, 5)
            }
            
            if ((ajaxRequest.venue?._embedded?.venues?.first?.address?.line1) != nil) {
                VStack {
                    Text("Address")
                        .font(.system(size: 20))
                        .bold()
                    Text(ajaxRequest.venue?._embedded?.venues?.first?.address?.line1 ?? "sample-venue")
                        .foregroundColor(Color.gray)
                }
                .padding(.bottom, 5)
            }
            
            if((ajaxRequest.venue?._embedded?.venues?.first?.boxOfficeInfo?.phoneNumberDetail) != nil) {
                VStack {
                    Text("Phone Number")
                        .font(.system(size: 20))
                        .bold()
                    Text(ajaxRequest.venue?._embedded?.venues?.first?.boxOfficeInfo?.phoneNumberDetail ?? "sample-venue")
                        .foregroundColor(Color.gray)
                }
                .padding(.bottom, 5)
            }
            
            if((ajaxRequest.venue?._embedded?.venues?.first?.boxOfficeInfo?.openHoursDetail) != nil) {
                VStack {
                    Text("Open Hours")
                        .font(.system(size: 20))
                        .bold()
                    HStack {
                        Spacer()
                        ScrollView {
                            Text(ajaxRequest.venue?._embedded?.venues?.first?.boxOfficeInfo?.openHoursDetail ?? "sample-venue")
                                .foregroundColor(Color.gray)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 350, height: 70)
                        Spacer()
                    }
                }
            }
            
            if((ajaxRequest.venue?._embedded?.venues?.first?.generalInfo?.generalRule) != nil) {
                VStack {
                    Text("General Rule")
                        .font(.system(size: 20))
                        .bold()
                    HStack {
                        Spacer()
                        ScrollView {
                            Text(ajaxRequest.venue?._embedded?.venues?.first?.generalInfo?.generalRule ?? "sample-venue")
                                .foregroundColor(Color.gray)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 350, height: 70)
                        Spacer()
                    }
                }
            }
            
            if((ajaxRequest.venue?._embedded?.venues?.first?.generalInfo?.childRule) != nil) {
                VStack {
                    Text("General Rule")
                        .font(.system(size: 20))
                        .bold()
                    HStack {
                        Spacer()
                        ScrollView {
                            Text(ajaxRequest.venue?._embedded?.venues?.first?.generalInfo?.childRule ?? "sample-venue")
                                .foregroundColor(Color.gray)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 350, height: 70)
                        Spacer()
                    }
                }
                .padding(.bottom, 15)
            }
            
            Button(action: {
                showMaps.toggle()
            }) {
                Text("Show venue on maps")
                    .frame(width: 200, height: 50)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .frame(width: 200, height: 30)
            .frame(maxWidth: .infinity, alignment: .center)
            .sheet(isPresented: $showMaps) {
                MapView(venueName: ajaxRequest.venue?._embedded?.venues?.first?.name ?? "")
            }
            
            Spacer()
        }
        .onAppear {
            ajaxRequest.venueName(eventId: item.id)
        }
        .padding(.top, -30)   
    }
}

struct VenueTab_Previews: PreviewProvider {
    static var previews: some View {
        VenueTab(item: TableSection(id: "sample-id", name: "sample-name", dates: TableSection.Dates(start: TableSection.Dates.Start(localDate: "sample-date", localTime: "sample-date")), images: [TableSection.Image(url: "sample-url")], _embedded: TableSection.Embedded(venues: [TableSection.Embedded.Venue(name: "sample-venue-name")]), classifications: [TableSection.Classifications(segment: TableSection.Classifications.Segment(name: "sample-classification"))]))
    }
}
