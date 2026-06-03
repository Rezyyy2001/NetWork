//
//  HitsView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI

struct HitsView: View {
    
    @StateObject private var viewModel = HitsViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.hits) { post in
                    PostPreviewCard(post: post, showConfirm: false, onConfirm: {})
                }
            }
            .onAppear {
                viewModel.fetchPosts()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}


#Preview {
    HitsView()
}
