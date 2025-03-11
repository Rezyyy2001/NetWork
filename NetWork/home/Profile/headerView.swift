//
//  headerView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/29/25.
//

import SwiftUI

struct headerView: View {
    @ObservedObject var viewModel: ProfileViewModel // @ObservedObject because needs to update whenever profileViewModel changes
    
    var body: some View {
        
        HStack {
            // Placement for User picture
            Image(systemName: "person")
                .foregroundColor(Color(red: 30/255, green: 143/255, blue: 213/255))
                .frame(width: 80, height: 80)
                .font(.system(size: 35))
                .overlay(RoundedRectangle(cornerRadius: 40)
                    .stroke(Color(red: 30/255, green: 143/255, blue: 213/255), lineWidth: 2))
            
            VStack(alignment: .leading) {
                if let user = viewModel.user { // If signed in display name
                    Text(user.displayName ?? "Username not set")
                        .bold()
                } else {
                    Text("Loading Name...")
                        .bold()
                }
                // If utr is not nil then go one decimal place
                /*
                Text("UTR: \(viewModel.utr != nil ? String(format: "%.1f", viewModel.utr!) : "")")
                Text("USTA: \(viewModel.usta != nil ? String(format: "%.1f", viewModel.usta!) : "")")
                    */
                if let utr = viewModel.utr {
                    Text("UTR: \(String(format: "%.1f", utr))")
                }
                if let usta = viewModel.usta {
                    Text("UTR: \(String(format: "%.1f", usta))") 
                }
            }
            .padding(.leading, 5)
            Spacer()
        }
        .padding(.horizontal, 20)
        // Runs fetchuserProfile as soon as headerView is opened
        .task {
            await viewModel.fetchUserProfile()
        }
    }
}

#Preview {
    headerView(viewModel: ProfileViewModel())
}
