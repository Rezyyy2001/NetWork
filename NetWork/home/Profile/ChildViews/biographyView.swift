//
//  biographyView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/5/25.
//

import SwiftUI

struct BiographyView: View {
    @ObservedObject var viewModel: ProfileViewModel
    

    var body: some View {
        VStack {
            //
            Text(viewModel.bio ?? "No Biography Set") //gets the bio from profileViewModel
                .padding()
                .font(.system(size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal, 20)
                //.foregroundColor(.black)
        }
    }
}

#Preview {
    NavigationStack {
        profileView()
    }
}



