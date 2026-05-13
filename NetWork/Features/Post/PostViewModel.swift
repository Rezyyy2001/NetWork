//
//  PostViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/12/26.
//

import Foundation

@MainActor
final class PostViewModel: ObservableObject {

    @Published var location: String = ""
    @Published var extraInfo: String = ""
    @Published var numberOfPeople: Int = 1
    @Published var selectedDate = Date()
    @Published var errorMessage: String?
    @Published var suggestions: [PlaceSuggestion] = []

    @Published var showPreview = false
    @Published var posterName = ""
    @Published var posterUTR: Double? = nil
    @Published var posterUSTA: Double? = nil

    init() {
        Task { await fetchPosterInfo() }
    }

    private func fetchPosterInfo() async {
        guard let profile = try? await CurrentUserService.shared.fetchUserProfile() else { return }
        posterName = profile.name
        posterUTR = profile.UTR
        posterUSTA = profile.USTA
    }

    func post() {
        showPreview = true
    }

    func confirmPost() {
        // TODO: save post to Firestore
        showPreview = false
    }
    func autocomplete() {
        Task {
            do {
                suggestions = try await GooglePlacesService.autocomplete(input: location)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    func selectSuggestion(_ suggestion: PlaceSuggestion) {
        location = suggestion.description
        suggestions = []
    }
}
