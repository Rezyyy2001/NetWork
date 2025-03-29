//
//  profileView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI
    
struct profileView: View {
    @StateObject private var viewModel = ProfileViewModel() //observes profileViewModel
    //@State private var showSettings = false

    var body: some View {
        
        VStack{
            // This is where all the child views will stack up 
            headerView(viewModel: viewModel)
            infoView(viewModel: viewModel)
            BiographyView(viewModel: viewModel)
            Spacer()
            
        }
        .toolbar {
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
    profileView()
}
