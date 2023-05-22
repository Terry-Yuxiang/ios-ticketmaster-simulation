//
//  SharedData.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/9/23.
//

import Foundation

class SharedData: ObservableObject {
    @Published var artistNames: [String] = []
    
    func addArtistName(_ name: String) {
        artistNames.append(name)
    }
    
}
