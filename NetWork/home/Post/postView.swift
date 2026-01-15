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
            VStack(spacing: 0) {
                
                // Location
                GroupBox(label: Label("Where will you be hitting?", systemImage: "mappin.and.ellipse")) {
                    TextField("e.g. Foss Park, Somerville", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                // Extra Info
                GroupBox(label: Label("Extra Info", systemImage: "info.circle")) {
                    LimitedLineTextEditor(
                        text: $extraInfo,
                        placeholder: "What are you looking for in this hitting session?",
                        lineLimit: 13
                    )
                }

                // Number of People
                GroupBox(label: Label("How many people?", systemImage: "person.3.fill")) {
                    Stepper(value: $numberOfPeople, in: 1...10) {
                        Text("\(numberOfPeople) player\(numberOfPeople > 1 ? "s" : "")")
                            .fontWeight(.medium)
                    }
                }

                // Preferred Time
                GroupBox(label: Label("Preferred Time", systemImage: "calendar.badge.clock")) {
                    DatePicker("Select time", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                }

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
            .frame(maxHeight: .infinity)
            .padding(.bottom)
            .navigationTitle("New Hitting Post")
            .navigationBarBackButtonHidden(true)
        }
        .frame(maxHeight: .infinity)
    }

}



#Preview {
    PostView()
}
