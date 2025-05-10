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
            HeaderView(viewModel: viewModel)
            InfoView(viewModel: viewModel)
            BiographyView(viewModel: viewModel)
            friendButtonView(targetUserID: viewModel.uid)
            Spacer()
        }
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.blue) // Customize the icon color
                        .font(.title) // Adjust the size of the back arrow 
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    userProfileView(userID: "9qVSt63nrjaqiBm79ZNoOxM7AFd2")
}
