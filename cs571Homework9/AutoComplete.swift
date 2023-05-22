//
//  AutoComplete.swift
//  cs571Homework9
//
//  Created by 樊宇祥 on 4/30/23.
//

import SwiftUI

struct AutoComplete: View {
    @StateObject private var ajaxRequest = AjaxRequest()
    @Binding var word: String
    @Binding var showAutoCompleteResults: Bool
    
    var body: some View {
        if !ajaxRequest.autoCompleteResultDone {
            VStack {
                ProgressView()
                    .progressViewStyle(.circular)
                Text("loading...")
                    .foregroundColor(Color.gray)
            }
            .onAppear {
                ajaxRequest.autoComplete(word: word)
            }
        }
        if ajaxRequest.autoCompleteResultDone {
            VStack {
                Text("Suggestions")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 30)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .foregroundColor(.black)
                
                List {
                    ForEach(ajaxRequest.autoCompleteResult?._embedded?.attractions ?? []) { item in
                        Button( action: {
                            word = item.name ?? ""
                            showAutoCompleteResults = false
                        }) {
                            Text(item.name ?? "")
                                .foregroundColor(.black)
                        }
                    }
                }
                Spacer()
            }
        }
        
    }
}

struct AutoComplete_Previews: PreviewProvider {
    static var previews: some View {
        AutoComplete(word: .constant(""), showAutoCompleteResults: .constant(true))
    }
}
