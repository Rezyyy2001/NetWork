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
                Text(viewModel.user?.displayName ?? "Username not set")
                    .bold()
                
                //TODO: UTR should be a Float for two decimal points
                
                if let utr = viewModel.utr {
                    Text("UTR: \(utr, specifier: "%.01f")") //specifies the detail of one decimal point
                }
                
                if let usta = viewModel.usta {
                    Text("USTA: \(usta, specifier: "%.1f")")
                }
            }
            .padding(.leading, 5)
            Spacer()
        }
        .padding(.horizontal, 20)
        
    }
}

#Preview {
    headerView(viewModel: ProfileViewModel())
}
