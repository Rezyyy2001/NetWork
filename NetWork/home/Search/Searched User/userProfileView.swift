//
//  userProfileView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/25/25.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject private var viewModel: UserProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    
    init(userID: String) {
        _viewModel = StateObject(wrappedValue: UserProfileViewModel(userID: userID))
    }
    
    var body: some View {
        VStack {
            HeaderView(viewModel: viewModel)
            InfoView(viewModel: viewModel)
            BiographyView(viewModel: viewModel)
            FriendButtonView(targetUserID: viewModel.uid)
            Spacer()
        }
        .padding(.horizontal, 2)
        .ignoresSafeArea(.container, edges: .horizontal)
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
    UserProfileView(userID: "9qVSt63nrjaqiBm79ZNoOxM7AFd2")
}
