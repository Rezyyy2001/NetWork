//
//  serviceView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI

struct serviceView: View {
    var body: some View {
        VStack {
            
            Spacer()
                .navigationBarBackButtonHidden(true)
            Text("IN PROGRESS")
                .font(.system(size: 36, weight: .bold, design: .default)) // Large font
                .foregroundColor(.red) // Red text
                .italic() // Slanted text
                .multilineTextAlignment(.center) // Center alignment
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    serviceView()
}
