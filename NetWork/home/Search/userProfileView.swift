//
//  userProfileView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/25/25.
//

import SwiftUI

struct userProfileView: View {
    @StateObject private var viewModel: userProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(userID: String) {
        _viewModel = StateObject(wrappedValue: userProfileViewModel(userID: userID))
    }
    
    var body: some View {
        VStack {
            Text("Name: \(viewModel.name)")
                .font(.title)
                .bold()
                .padding()
            
            Text("Bio: \(viewModel.bio ?? "No bio set")")
                .padding()
            
            Text("Usual Spot: \(viewModel.usualSpot ?? "No Spot set")")
            
            
                .padding()
            
            Spacer()
        }
        //.navigationTitle("User Profile")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            //custom back button
            ToolbarItem (placement: .navigationBarLeading) {
                Button(action: {
                    print("Back button tapped")
                    dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.blue) // Customize the icon color
                        .font(.title) // Adjust the size of the back arrow
                }
            }
        }
    }
}

#Preview {
    userProfileView(userID: "9qVSt63nrjaqiBm79ZNoOxM7AFd2")
}
