//
//  ServiceView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 10/26/24.
//

import SwiftUI

struct ServiceView: View {
    @StateObject private var viewModel = ServiceViewModel()

    var body: some View {
        NavigationStack {
            TabView {
                ForEach(viewModel.cards) { card in
                    BusinessCardView(card: card)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .navigationTitle("Services")
            .navigationBarBackButtonHidden(true)
            .task { await viewModel.fetchCards() }
        }
    }
}

#Preview {
    ServiceView()
}
