//
//  FavoriteStore.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/11/23.
//

import SwiftUI

struct FavoriteStore: View {
    
    @AppStorage("favoriteEventsDic") private var favoriteEventsDic: String = ""
    @AppStorage("eventIdArray") private var eventIdArray: String = ""
    @AppStorage("favoriteEventsGenre") private var favoriteEventsGenre: String = ""
    
    var body: some View {
        VStack {
            VStack {
                if let idArray = decodeIdArray() {
                    Form {
                        Section {
                            List {
                                ForEach(idArray.indices, id: \.self) { item in
                                    if let dic = decodeEventsDic() {
                                        if let tableSection = dic[idArray[item]], let genre = decodeEventsGenre() {
                                            
                                                HStack {
                                                    Text(tableSection.dates.start.localDate ?? "")
                                                        .font(.system(size: 12))
                                                    Text(tableSection.name)
                                                        .font(.system(size: 12))
                                                        .lineLimit(2)
                                                    Text(genre[idArray[item]] ?? "")
                                                        .font(.system(size: 12))
                                                    Text(tableSection._embedded.venues.first?.name ?? "")
                                                        .font(.system(size: 12))
                                                }
                                            }
                                        }
                                    }
                                .onDelete{offsets in
                                    offsets.forEach { index in
                                        var id = idArray[index]
                                        delete(id: &id)
                                    }}
                            }
                        }
                    }
                } else {
                    Text("No favorites found")
                        .foregroundColor(Color.red)
                }
            }
                .navigationTitle("Event Search")
        }
    }
    
    func delete(id: inout String) {
        let encoder = JSONEncoder()
        var favoriteDictionary = decodeEventsDic()
        var favoriteArray = decodeIdArray()
        var favoriteGenre = decodeEventsGenre()
        
        if favoriteArray != nil {
            if let indexToRemove = favoriteArray?.firstIndex(of: id) {
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
            favoriteDictionary?.removeValue(forKey: id)
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
            favoriteGenre?.removeValue(forKey: id)
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
}

struct FavoriteStore_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteStore()
    }
}



