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
            CardStackView(cards: viewModel.cards)
                .task { await viewModel.fetchCards() }
        }
    }
}

#Preview {
    ServiceView()
}
