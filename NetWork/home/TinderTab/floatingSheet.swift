//
//  floatingSheet.swift
//  NetWork
//
//  Created by Rezka Yuspi on 11/6/25.
//

import SwiftUI

struct floatingSheet: View {
    var body: some View {
        Rectangle()
            .fill(Color.pink)
            .frame(width: 300, height: 500)
            .cornerRadius(30)
            .shadow(radius: 10)
            
        
    }
}
#Preview {
    ZStack {
        Color(.systemGray6).ignoresSafeArea()
        floatingSheet()
    }
}
