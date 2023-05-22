//
//  DetailsCard.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/8/23.
//

import SwiftUI
import UIKit
import Kingfisher

struct EventsTab: View {
    
    func decodeIdArray() -> [String]? {
        if let data = Data(base64Encoded: self.eventIdArray) {
            let decoder = JSONDecoder()
            do {
                let decodedItem = try decoder.decode([String].self, from: data)
                return decodedItem
            } catch {
                print("Failed to decode item: \(error)")
            }
        } else {
            print("Failed to decode base64 string")
        }
        return nil
    }
    
    func decodeEventsDic() -> [String: TableSection]? {
        if let data = Data(base64Encoded: self.favoriteEventsDic) {
            let decoder = JSONDecoder()
            do {
                let decodedItem = try decoder.decode([String: TableSection].self, from: data)
                return decodedItem
            } catch {
                print("Failed to decode item: \(error)")
            }
        } else {
            print("Failed to decode base64 string")
        }
        return nil
    }
    
    func decodeEventsGenre() -> [String: String]? {
        if let data = Data(base64Encoded: self.favoriteEventsGenre) {
            let decoder = JSONDecoder()
            do {
                let decodedItem = try decoder.decode([String: String].self, from: data)
                return decodedItem
            } catch {
                print("Failed to decode item: \(error)")
            }
        } else {
            print("Failed to decode base64 string")
        }
        return nil
    }
    
    
    @AppStorage("favoriteEventsDic") private var favoriteEventsDic: String = ""
    @AppStorage("eventIdArray") private var eventIdArray: String = ""
    @AppStorage("favoriteEventsGenre") private var favoriteEventsGenre: String = ""
    @StateObject private var ajaxRequest = AjaxRequest()

    
    var priceRangeText: String { // Get price range text
        if let min = ajaxRequest.details?.priceRanges?.first?.min,
           let max = ajaxRequest.details?.priceRanges?.first?.max {
            return "\(min) - \(max)"
        } else if let min = ajaxRequest.details?.priceRanges?.first?.min {
            return "\(min)"
        } else if let max = ajaxRequest.details?.priceRanges?.first?.max {
            return "\(max)"
        } else {
            return ""
        }
    }
    
    var genre: String { // get genre text
        let segment = ajaxRequest.details?.classifications?.first?.segment?.name ?? ""
        let genre = ajaxRequest.details?.classifications?.first?.genre?.name ?? ""
        let subGenre = ajaxRequest.details?.classifications?.first?.subGenre?.name ?? ""
        let type = ajaxRequest.details?.classifications?.first?.type?.name ?? ""
        let subType = ajaxRequest.details?.classifications?.first?.subType?.name ?? ""
        var result = ""
        if (segment != "" && segment != "Undefined") {
            result += segment
        }
        if (genre != "" && genre != "Undefined") {
            if (result != "") {
                result += " | "
            }
            result += genre
        }
        if (subGenre != "" && subGenre != "Undefined") {
            if (result != "") {
                result += " | "
            }
            result += subGenre
        }
        if (type != "" && type != "Undefined") {
            if (result != "") {
                result += " | "
            }
            result += type
        }
        if (subType != "" && subType != "Undefined") {
            if (result != "") {
                result += " | "
            }
            result += subType
        }
        return result
    }
    
    var artistTeam: String { // get artist and team text
        var result = ""
        if let attractions = ajaxRequest.details?._embedded?.attractions {
            for artist in attractions {
                if(result != "" && artist.name != "") {
                    result += " | "
                }
                result += artist.name
            }
        }
        return result
    }
    
    var ticketStatus: String { // get ticket status
        var result = ""
        let status = ajaxRequest.details?.dates?.status?.code
        if (status == "onsale") {
            result = "On Sale"
        }
        if (status == "offsale") {
            result = "Off Sale"
        }
        if (status == "canceled") {
            result = "Canceled"
        }
        if (status == "postponed") {
            result = "Postponed"
        }
        if (status == "rescheduled") {
            result = "Rescheduled"
        }
        return result
    }

    let item: TableSection
    
    @State var favoriteToast: Bool = false
    
    @State private var favorite: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                VStack {
                    if favorite {
                        VStack {
                            Text("Added to favorites")
                                .zIndex(1)
                        }
                        .frame(width: 200,
                               height: 70)
                        .background(Color.secondary.colorInvert())
                        .foregroundColor(Color.primary)
                        .cornerRadius(10)
                        .transition(.slide)
                        .opacity(self.favoriteToast ? 1 : 0)
                        .zIndex(1)
                    }
                    if !favorite {
                        VStack {
                            Text("Remove from favorites")
                                .zIndex(1)
                        }
                        .frame(width: 200,
                               height: 70)
                        .background(Color.secondary.colorInvert())
                        .foregroundColor(Color.primary)
                        .cornerRadius(10)
                        .transition(.slide)
                        .opacity(self.favoriteToast ? 1 : 0)
                        .zIndex(1)
                    }
                }
                .padding(.top, 500)
                .zIndex(1)
                if !ajaxRequest.detailsRequestDone {
                    VStack {
                        ProgressView()
                            .progressViewStyle(.circular)
                        Text("Please wait...")
                            .foregroundColor(Color.gray)
                    }
                }
                if ajaxRequest.detailsRequestDone {
                    VStack {
                        Text(item.name)
                            .font(.system(size: 24))
                            .bold()
                            .padding(0)
                        
                        
                        HStack {
                            if((ajaxRequest.details?.dates?.start?.localDate) != nil) {
                                VStack{
                                    Text("Date")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .bold()
                                        .padding(.leading, 10)
                                    // ajaxRequest.details.first.dates.start.localDate
                                    Text(ajaxRequest.details?.dates?.start?.localDate ?? "0000-00-00")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 10)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            if(artistTeam != "") {
                                VStack {
                                    Text("Artist | Team")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .bold()
                                        .padding(.trailing, 10)
                                    Text(artistTeam)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 10)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                        }
                        Spacer()
                            .frame(height: 10)
                        
                        HStack {
                            if((ajaxRequest.details?._embedded?.venues?.first?.name) != nil) {
                                VStack{
                                    Text("Venue")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .bold()
                                        .padding(.leading, 10)
                                    Text(ajaxRequest.details?._embedded?.venues?.first?.name ?? "sample-venue")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 10)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            if(genre != "") {
                                VStack {
                                    Text("Genre")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .bold()
                                        .padding(.trailing, 10)
                                    Text(genre)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .padding(.trailing, 10)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 10)
                        
                        HStack {
                            if ((ajaxRequest.details?.priceRanges?.first?.min) != nil), ((ajaxRequest.details?.priceRanges?.first?.max) != nil) {
                                VStack{
                                    Text("Price Range")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .bold()
                                        .padding(.leading, 10)
                                    Text(priceRangeText)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 10)
                                        .foregroundColor(.gray)
                                    
                                }
                            }
                            
                            if(ticketStatus != "") {
                                VStack {
                                    Text("Ticket Status")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .bold()
                                        .padding(.trailing, 10)
                                    
                                    Button(action: {
                                        
                                    }) {
                                        if (ticketStatus == "On Sale")  {
                                            Text(ticketStatus)
                                                .frame(width: 100, height: 30)
                                                .background(Color.green)
                                                .foregroundColor(.white)
                                                .cornerRadius(5)
                                        }
                                        if (ticketStatus == "Off Sale")  {
                                            Text(ticketStatus)
                                                .frame(width: 100, height: 30)
                                                .background(Color.red)
                                                .foregroundColor(.white)
                                                .cornerRadius(5)
                                        }
                                        if (ticketStatus == "Canceled")  {
                                            Text(ticketStatus)
                                                .frame(width: 100, height: 30)
                                                .background(Color.black)
                                                .foregroundColor(.white)
                                                .cornerRadius(5)
                                        }
                                        if (ticketStatus == "Postponed")  {
                                            Text(ticketStatus)
                                                .frame(width: 100, height: 30)
                                                .background(Color.orange)
                                                .foregroundColor(.white)
                                                .cornerRadius(5)
                                        }
                                        if (ticketStatus == "Rescheduled")  {
                                            Text(ticketStatus)
                                                .frame(width: 100, height: 30)
                                                .background(Color.orange)
                                                .foregroundColor(.white)
                                                .cornerRadius(5)
                                        }
                                    }
                                    .frame(width: 100, height: 30)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 10)
                                    
                                }
                            }
                        }
                        Spacer()
                            .frame(height: 10)
                        
                        ZStack {
                            Button(action: {
                                favorite.toggle()
                                self.favoriteToast.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                  withAnimation {
                                    self.favoriteToast = false
                                  }
                                }
                                
                                if favorite {
                                    let encoder = JSONEncoder()
                                    var favoriteDictionary = decodeEventsDic()
                                    var favoriteArray = decodeIdArray()
                                    var favoriteGenre = decodeEventsGenre()

                                    if favoriteDictionary != nil {
                                        favoriteDictionary?[item.id] = item
                                        if let dicDecoder = try? encoder.encode(favoriteDictionary) {
                                            let dicDecoderString = dicDecoder.base64EncodedString()
                                            favoriteEventsDic = dicDecoderString
                                        }
                                    } else {
                                        var firstDic: [String:TableSection] = [:]
                                        firstDic[item.id] = item
                                        if let dicDecoder = try? encoder.encode(firstDic) {
                                            let dicDecoderString = dicDecoder.base64EncodedString()
                                            favoriteEventsDic = dicDecoderString
                                        }
                                    }
                                    
                                    if favoriteArray != nil {
                                        favoriteArray?.append(item.id)
                                        if let arrayDecoder = try? encoder.encode(favoriteArray) {
                                            let arrayDecoderString = arrayDecoder.base64EncodedString()
                                            eventIdArray = arrayDecoderString
                                        }
                                    } else {
                                        var firstArray: [String] = []
                                        firstArray.append(item.id)
                                        if let arrayDecoder = try? encoder.encode(firstArray) {
                                            let arrayDecoderString = arrayDecoder.base64EncodedString()
                                            eventIdArray = arrayDecoderString
                                        }
                                    }
                                    
                                    if favoriteGenre != nil {
                                        favoriteGenre?[item.id] = genre
                                        if let genreDecoder = try? encoder.encode(favoriteGenre) {
                                            let genreDecoderString = genreDecoder.base64EncodedString()
                                            favoriteEventsGenre = genreDecoderString
                                        }
                                    } else {
                                        var FirstGenre: [String:String] = [:]
                                        FirstGenre[item.id] = genre
                                        if let genreDecoder = try? encoder.encode(FirstGenre) {
                                            let genreDecoderString = genreDecoder.base64EncodedString()
                                            favoriteEventsGenre = genreDecoderString
                                        }
                                    }
                                }
                                
                                if !favorite {
                                    let encoder = JSONEncoder()
                                    var favoriteDictionary = decodeEventsDic()
                                    var favoriteArray = decodeIdArray()
                                    var favoriteGenre = decodeEventsGenre()
                                    
                                    if favoriteArray != nil {
                                        if let indexToRemove = favoriteArray?.firstIndex(of: item.id) {
                                            favoriteArray?.remove(at: indexToRemove)
                                        }
                                        if favoriteArray?.count != 0 {
                                            if let arrayDecoder = try? encoder.encode(favoriteArray) {
                                                let arrayDecoderString = arrayDecoder.base64EncodedString()
                                                eventIdArray = arrayDecoderString
                                            }
                                        } else {
                                            eventIdArray = ""
                                        }
                                        
                                    }
                                    
                                    if favoriteDictionary != nil {
                                        favoriteDictionary?.removeValue(forKey: item.id)
                                        if favoriteArray?.count != 0 {
                                            if let dicDecoder = try? encoder.encode(favoriteDictionary) {
                                                let dicDecoderString = dicDecoder.base64EncodedString()
                                                favoriteEventsDic = dicDecoderString
                                            }
                                        } else {
                                            favoriteEventsDic = ""
                                        }
                                        
                                    }

                                    if favoriteGenre != nil {
                                        favoriteGenre?.removeValue(forKey: item.id)
                                        if favoriteArray?.count != 0 {
                                            if let genreDecoder = try? encoder.encode(favoriteGenre) {
                                                let genreDecoderString = genreDecoder.base64EncodedString()
                                                favoriteEventsGenre = genreDecoderString
                                            }
                                        } else {
                                            favoriteEventsGenre = ""
                                        }
                                    }
                                    
                                }
                                
   
                            }) {
                                if !favorite {
                                    Text("Save Event")
                                        .frame(width: 110, height: 50)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                } else {
                                    Text("Remove Favorite")
                                        .padding(.all, 10)
                                        .frame(width: 110, height: 50)
                                        .lineLimit(1)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                }
                            }
                            .onAppear {
                                let favoriteArray = decodeIdArray()
                                if favoriteArray != nil {
                                    if ((favoriteArray?.firstIndex(of: item.id)) != nil) {
                                        favorite = true
                                    }
                                }
                            }
                        }
                        .frame(width: 110, height: 50)
                        .buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                            .frame(height: 10)
                        
                        VStack {
                            HStack {
                                if let imageUrl = ajaxRequest.details?.seatmap?.staticUrl, let URL_imageUrl = URL(string: imageUrl) {
                                    KFImage(URL_imageUrl)
                                        .resizable()
                                        .frame(width: 250, height: 250, alignment: .center)
                                }
                            }
                            
                            HStack {
                                Text("Buy Ticket At: ")
                                    .bold()
                                if let ticketmasterUrl = ajaxRequest.details?.url,
                                    let URL_ticketmasterUrl = URL(string: ticketmasterUrl) {
                                    Link("TicketMaster", destination: URL_ticketmasterUrl)
                                }
                            }
                            
                            HStack() {
                                Text("Share on:")
                                    .bold()
                                Button(action: {
                                    if let ticketmasterUrl = ajaxRequest.details?.url,
                                        let URL_ticketmasterUrl = URL(string: ticketmasterUrl) {
                                        if let encodedUrlString = "https://www.facebook.com/sharer.php?u=\(URL_ticketmasterUrl)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                           let facebookUrl = URL(string: encodedUrlString) {
                                            UIApplication.shared.open(facebookUrl)
                                        }
                                    }
                                }) {
                                    Image("f_logo_RGB-Blue_144")
                                        .resizable()
                                        .scaledToFit()
                                }
                                Button(action: {
                                    if let ticketmasterUrl = ajaxRequest.details?.url,
                                        let URL_ticketmasterUrl = URL(string: ticketmasterUrl) {
                                        if let encodedUrlString = "https://twitter.com/intent/tweet?text=Check \(item.name) on Ticketmaster&url=\(URL_ticketmasterUrl)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                           let twitterUrl = URL(string: encodedUrlString) {
                                            UIApplication.shared.open(twitterUrl)
                                        }
                                    }
                                }) {
                                    Image("Twitter social icons - circle - blue")
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                            .frame(height: 40)
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, -20)

                }
            }
        }
        .onAppear{
            ajaxRequest.eventDetail(eventId: item.id)
        }
    }
}

struct EventsTab_Previews: PreviewProvider {
    static var previews: some View {
        EventsTab(item: TableSection(id: "sample-id", name: "sample-name", dates: TableSection.Dates(start: TableSection.Dates.Start(localDate: "sample-date", localTime: "sample-date")), images: [TableSection.Image(url: "sample-url")], _embedded: TableSection.Embedded(venues: [TableSection.Embedded.Venue(name: "sample-venue-name")]), classifications: [TableSection.Classifications(segment: TableSection.Classifications.Segment(name: "sample-classification"))]))
    }
}
