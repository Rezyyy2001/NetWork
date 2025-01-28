//
//  profileView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI
    
@MainActor
final class profileViewModel: ObservableObject {
    @Published var user: AuthDataResultModel? = nil
    
    func start() async throws {
        user = try await AuthenticationManager.shared.getAuthenticatedUser()
    }
}


struct profileView: View {
    @StateObject private var viewModel = profileViewModel()
    @State private var showSettings = false

    var body: some View {
        List {
            if let user = viewModel.user {
                Text("UserID: \(user.uid)")
                Text("Name: \(user.displayName ?? "Not Set")")
                Text("Email: \(user.email ?? "Not Set")")
            } else {
                ProgressView("Loading...")
            }
                /*
                Text("UserID: \(user.uid)")
                if let displayName = user.displayName {
                    Text("Name: \(user.displayName ?? "")")
                } else {
                    Text("Name: Not Set")
                }
                if let email = user.email {
                    Text("Email: \(user.email ?? "")")
                }
            } else {
                ProgressView("loading..")
            }
                 */
                
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.headline)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .task {
            try? await viewModel.start()
        }
    }
}

#Preview {
    NavigationStack {
        profileView()
    }
}
