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
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.showFilter = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.headline)
                }
            }
        }
        .sheet(isPresented: $viewModel.showFilter, onDismiss: {
            viewModel.fetchPosts()
        }) {
            FilterView(isNewest: $viewModel.isNewest, numberOfPeople: $viewModel.numberOfPeople)
                .presentationDetents([.fraction(0.25)])
        }
    }
}


#Preview {
    HitsView()
}
