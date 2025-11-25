//
//  localView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI

struct LocalView: View {
    var body: some View {
        ZStack {
            Color.blue.opacity(0.2).ignoresSafeArea()
            floatingSheet()
        
        }
        .navigationBarBackButtonHidden(true)
    }
        
}

#Preview {
    LocalView()
}
