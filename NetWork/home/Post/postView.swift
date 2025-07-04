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

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    
                    // Location
                    GroupBox(label: Label("Where will you be hitting?", systemImage: "mappin.and.ellipse")) {
                        TextField("e.g. Foss Park, Somerville", text: $location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    // Extra Info
                    GroupBox(label: Label("Extra Info", systemImage: "info.circle")) {
                        TextField("e.g. Looking for 3.5+ players", text: $extraInfo)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                        // Handle post logic
                        print("Location: \(location)")
                        print("Extra Info: \(extraInfo)")
                        print("Looking for \(numberOfPeople) player(s)")
                        print("Time: \(selectedDate)")
                    }) {
                        Text("Post")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding()
                }
                .frame(maxHeight: .infinity)
                .padding(.bottom)
            }
            .frame(maxHeight: .infinity)
        }
        .navigationTitle("New Hitting Post")
    }
}


#Preview {
    PostView()
}
