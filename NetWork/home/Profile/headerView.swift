//
//  headerView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/29/25.
//

import SwiftUI

struct headerView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        
        HStack {
            Image(systemName: "person")
                .foregroundColor(Color(red: 30/255, green: 143/255, blue: 213/255))
                .frame(width: 80, height: 80)
                .font(.system(size: 35))
                .overlay(RoundedRectangle(cornerRadius: 40)
                    .stroke(Color(red: 30/255, green: 143/255, blue: 213/255), lineWidth: 2))
            
            VStack(alignment: .leading) {
                if let user = viewModel.user {
                    Text(user.displayName ?? "Username not set")
                        .bold()
                } else {
                    Text("Loading Name...")
                        .bold()
                }

                Text("UTR: \(viewModel.utr != nil ? String(format: "%.1f", viewModel.utr!) : "")")
                Text("USTA: \(viewModel.usta != nil ? String(format: "%.1f", viewModel.usta!) : "")")
                    
            }
            .padding(.leading, 5)
            Spacer()
        }
        .padding(.horizontal, 20)
        .task {
            await viewModel.fetchUserProfile()
        }
    }
}

#Preview {
    headerView(viewModel: ProfileViewModel())
}
