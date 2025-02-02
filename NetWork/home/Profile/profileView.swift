//
//  profileView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI
    
struct profileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    //@State private var showSettings = false

    var body: some View {
        /*
        List {
            if let user = viewModel.user {
                Text("UserID: \(user.uid)")
                Text("Name: \(user.displayName ?? "Not Set")")
                Text("Email: \(user.email ?? "Not Set")")
            } else if viewModel.errorMessage != nil {
                Text(viewModel.errorMessage!)
                    .foregroundColor(.red)
            } else {
                ProgressView("Loading...")
            }
        }
         */
        
        VStack{
            headerView(viewModel: viewModel)
            
            infoView()
            
        }
        Spacer()
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
        .task {
            await viewModel.start() //await because we use await for when calling async functions
        }                           //try is for throw functions
    }
}

#Preview {
    NavigationStack {
        profileView()
    }
}
