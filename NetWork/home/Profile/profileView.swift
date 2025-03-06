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
        
        VStack{ 
            headerView(viewModel: viewModel)
            infoView(viewModel: viewModel)
            BiographyView(viewModel: viewModel)
            
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
