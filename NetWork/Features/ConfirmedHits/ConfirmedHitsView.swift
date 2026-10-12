//
//  ConfirmedHitsView.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/4/26.
//

import SwiftUI

struct ConfirmedHitsView: View {
    @StateObject private var viewModel = ConfirmedHitsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Order", selection: $viewModel.showUpcoming) {
                    Text("Upcoming").tag(true)
                    Text("Past").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .onChange(of: viewModel.showUpcoming) {
                    viewModel.fetchConfirmedHits()
                }

                Group {
                    if viewModel.acceptedHitPosts.isEmpty {
                        ContentUnavailableView(
                            "No confirmed hits yet",
                            systemImage: "checkmark.square",
                            description: Text("Your accepted hit requests will appear here.")
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.acceptedHitPosts) { hit in
                                    ConfirmedHitCard(confirmedHit: hit)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                    }
                }
            }
            .task { viewModel.fetchConfirmedHits() }
            .navigationTitle("Confirmed Hits")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(padded: false)
                }
            }
        }
    }
}
