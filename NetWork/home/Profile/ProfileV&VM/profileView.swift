//
//  profileView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI
    
struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel() //observes profileViewModel
    
    var body: some View {
        
        VStack{
            // This is where all the child views will stack up 
            HeaderView(viewModel: viewModel)
            InfoView(viewModel: viewModel)
            BiographyView(viewModel: viewModel)
            Spacer()
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showMessageView = true
                } label: {
                    Image(systemName: "message")
                        .font(.headline)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showFriendRequests = true
                } label: {
                    Image(systemName: "tray")
                        .font(.headline)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showSettings = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.headline)
                }
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $viewModel.showMessageView) {
            MessageListView(currentUserID: viewModel.user?.uid ?? "")
        }
        .sheet(isPresented: $viewModel.showFriendRequests) {
            FriendInboxView()
        }
        .sheet(isPresented: $viewModel.showSettings) {
            SettingsView()
        }
        //This whole block of code is to keep the data updated
        .task {
            if viewModel.user == nil {
                await viewModel.fetchUserProfile()
            }
        }
    }
}

#Preview {
    ProfileView()
}
