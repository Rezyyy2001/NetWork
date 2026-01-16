//
//  postView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI

struct PostView: View {
    @State private var location: String = ""
    @State private var extraInfo: String = ""
    @State private var numberOfPeople: Int = 1
    @State private var selectedDate = Date()
    @State private var hasEdited: Bool = false

    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                
                // Location
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(10)

                    TextField("Where are you hitting?", text: $location)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                
                // Recents implementation
                VStack(alignment: .leading) {
                    Text("Recents")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
        
                // HStack with players and date
                HStack {
                    // Number of players: The value on the left looks awkward, too much space.
                    VStack {
                        Text("Players")
                            .font(.headline)
                        
                        Stepper(value: $numberOfPeople, in: 1...10) {
                            Text("\(numberOfPeople)")
                        }
                    }
                    
                    // Date
                    VStack {
                        Text("Time")
                            .font(.headline)
                        DatePicker(
                            "",
                            selection: $selectedDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                    }
                }
                
                LimitedLineTextEditor(
                    text: $extraInfo,
                    placeholder: "What are you looking for in this session?",
                    lineLimit: 13
                )
                
            }
            .padding(.horizontal)
            // Post Button
            Button(action: {
                googlePlacesAPI.searchTennisCourt(query: location)
                // rest of the output

            }) {
                Text("Post")
                    .fontWeight(.bold)
                    .frame(maxWidth: 100)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
//        .frame(maxHeight: .infinity)
        .padding(.bottom)
        .navigationTitle("New Hit")
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    PostView()
}
