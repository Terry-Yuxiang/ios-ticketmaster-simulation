//
//  MapView.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/10/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    
    
    @StateObject private var ajaxRequest = AjaxRequest()
    let venueName: String
    
    @State var coordinateRegion = MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: 56.948889, longitude: 24.106389),
      span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: ajaxRequest.venueLocation?.results?.first?.geometry?.location?.lat ?? 0, longitude: ajaxRequest.venueLocation?.results?.first?.geometry?.location?.lng ?? 0),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))),
                annotationItems: [
                    venuePlace(name: venueName, latitude: ajaxRequest.venueLocation?.results?.first?.geometry?.location?.lat ?? 0, longitude: ajaxRequest.venueLocation?.results?.first?.geometry?.location?.lng ?? 0)
                  ]) { place in
                MapMarker(coordinate: place.coordinate, tint: .red)
            }
        }
        .padding(15)
        .onAppear {
            ajaxRequest.googleMapLocation(locationName: venueName)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(venueName: "")
    }
}

struct venuePlace: Identifiable {
  var id = UUID()
  let name: String
  let latitude: Double
  let longitude: Double
  
  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}


struct MapLocation: Codable, Identifiable {
    var id: String?
    var results: [Results]?
    
    struct Results: Codable {
        var geometry: Geometry?
        
        struct Geometry: Codable {
            var location: Location?
            
            struct Location: Codable {
                var lat: Double?
                var lng: Double?
            }
        }
    }
}
