//
//  postView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI

struct PostView: View {
    
    @StateObject private var viewModel = PostViewModel()
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                
                // Location
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(10)

                    TextField("Where are you hitting?", text: $viewModel.location)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                
                // Recents implementation
                HStack (spacing: 2) {
                    Text("Recents")
                    Image(systemName: "chevron.right")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
            
                // HStack with players and date
                HStack {
                    // Number of players: The value on the left looks awkward, too much space.
                    VStack {
                        Text("Players \(viewModel.numberOfPeople)")
                            .font(.headline)
                        Stepper(value: $viewModel.numberOfPeople, in: 1...10) {
                            
                        }
                        .labelsHidden()
                    }
                    
                    // Date
                    VStack {
                        Text("Time")
                            .font(.headline)
                        DatePicker(
                            "",
                            selection: $viewModel.selectedDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .labelsHidden()
                    }
                }
                CustomTextbox(
                    text: $viewModel.extraInfo,
                    placeholder: "What are you looking for in this session?",
                    characterLimit: 150
                )
                
            }
            .padding(.horizontal)
            // Post Button
            Button(action: {
                viewModel.post()
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
        .padding(.bottom)
        .navigationTitle("New Hit")
        .navigationBarBackButtonHidden(true)
        
    }
}
