//
//  FormView.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/6/23.
//

import SwiftUI
import UIKit
import Kingfisher
import Alamofire

struct HomeView: View {

    @State var showTable: Bool = false
    
//    let tableItems = Bundle.main.decodes([TableSection].self, from: "EventsJSON.json") // Got the data from json file
    
    @StateObject private var ajaxRequest = AjaxRequest() // ajax request class to fetch data
    
    
    var body: some View {
        NavigationView {
            Form {
                ExtractedForm(showTable:$showTable).environmentObject(ajaxRequest)

                if showTable {
                    Section{
                        Text("Results")
                            .font(.title)
                            .bold()
                        if(!ajaxRequest.eventsRequestDone) {
                            HStack {
                                VStack {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                        Spacer()
                                    }
                                    HStack {
                                        Text("Please wait...")
                                            .foregroundColor(Color.gray)
                                    }
                                }
                            }
                        }
                        if(ajaxRequest.eventsRequestDone) {
                            // Change back to ajaxRequest.events later
                            ForEach(ajaxRequest.events) { item in
                                NavigationLink(destination: DetailsCardTabs(item: item)) {
                                    HStack {
                                        let localDate = item.dates.start.localDate ?? ""
                                        let localTime = item.dates.start.localTime ?? ""
                                           
//                                        Text(item.dates.start.localDate + " " + item.dates.start.localTime)
                                        Text(localDate + " " + localTime)
                                            .foregroundColor(.gray)
                                        KFImage(URL(string: item.images[0].url)!)
                                            .resizable()
                                            .frame(width: 50, height: 50, alignment: .center)
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        Text(item.name)
                                            .fontWeight(.bold)
                                            .lineLimit(3)
                                            .truncationMode(.tail)
                                        Text(item._embedded.venues[0].name)
                                            .foregroundColor(.gray)
                                            .fontWeight(.bold)
                                    }
                                }
                            }
                            if(ajaxRequest.events.isEmpty) {
                                Text("No result available")
                                    .foregroundColor(Color.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Event Search")
            .navigationBarItems(
                trailing: NavigationLink(
                    destination: FavoriteStore(),
                    label: {
                        Image(systemName: "heart.circle")
                    }
                )
            )
        }
        
    }
 }



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct ExtractedForm: View {
    @Binding var showTable: Bool
    @State private var keyword = "" // keyword value
    @State private var distance: String = "10" // distance value
    @State private var selectedCategory = 0 // category tag
    @State private var categories = ["Default", "Music", "Sports", "Art & Theatre", "Film", "Miscellaneous"] // all category
    @State private var location = "" // location
    @State private var isAutoLocation = false // If use auto location
    @State private var formValid = false // If all required line has value
    
    
    @State private var ipinfoLocation = "" // location from ipinfo
    
    @State private var showAutoCompleteResults = false
    
    
    @State private var selectedWord: String = "" // auto complete select
    
    
    @EnvironmentObject var ajaxRequest: AjaxRequest
    
    var body: some View {
        Section{
            HStack {
                Text("Keyword:")
                TextField("Required", text: $keyword)
                    .onChange(of: keyword) {
                        _ in checkValidation()
                    }
                    .onSubmit {
                        showAutoCompleteResults = true
                    }
            }
            .sheet(isPresented: $showAutoCompleteResults) {
                AutoComplete(word: $keyword, showAutoCompleteResults: $showAutoCompleteResults)
            }
            HStack {
                Text("Distance:")
                TextField("10", text: $distance)
            }
            HStack {
                Text("Category:")
                Picker("", selection: $selectedCategory) {
                    ForEach(0..<categories.count, id: \.self) { index in
                        Text(categories[index]).tag(index)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            if !isAutoLocation {
                HStack {
                    Text("Location:")
                    TextField("Required", text:$location)
                        .onChange(of: location) { _ in checkValidation()}
                }
            }
            HStack {
                Toggle(isOn: $isAutoLocation) {
                    Text("Auto-detect my location")
                }
                .onChange(of: isAutoLocation) { _ in
                    if isAutoLocation {
                        ipinfoApi()
                    }
                    checkValidation()
                    clearLocation()
                }
            }
            HStack {
                Spacer()
                
                ZStack {
                    Button(action: {
                        if !isAutoLocation {
                            ajaxRequest.eventSearch(keyword: keyword, distance: distance, categories: categories[selectedCategory], location: location)
                        } else {
                            ajaxRequest.eventSearch(keyword: keyword, distance: distance, categories: categories[selectedCategory], location: ipinfoLocation)
                        }
                        showTable = true
                    }) {
                        Text("Submit")
                            .frame(width: 110, height: 50)
                            .background(formValid ? Color.red : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .frame(width: 110, height: 50)
                .buttonStyle(PlainButtonStyle())
                .padding()
                .disabled(!formValid)
                
                Spacer()
                Spacer()
                
                ZStack {
                    Button(action: {
                        resetForm()
                        ajaxRequest.clearButton()
                        showTable = false
                    }) {
                        Text("Clear")
                            .frame(width: 110, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .frame(width: 110, height: 50)
                .buttonStyle(PlainButtonStyle())
                .padding()
                
                
                Spacer()
            }
        }
    }
    
    func checkValidation() {
        formValid = !keyword.isEmpty && (!location.isEmpty || isAutoLocation)
    }
    func clearLocation() {
        location = ""
    }
    func resetForm() {
        keyword = ""
        distance = "10"
        selectedCategory = 0
        location = ""
        isAutoLocation = false
        formValid = false
    }
    
    func ipinfoApi() {
        if let ipinfoUrl = "https://ipinfo.io/?token=f4781763c0d86b"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: ipinfoUrl) {
             AF.request(url).responseDecodable(of: Ipinfo.self) { response in
                 switch response.result {
                 case .success(let ipinfo):
                     DispatchQueue.main.async {
                         self.ipinfoLocation = ipinfo.loc ?? ""
                     }
                 case .failure(let error):
                     print("Error: \(error)")
                 }
             }
        }
    }
    
}

