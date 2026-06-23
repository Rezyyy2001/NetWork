//
//  PostViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/12/26.
//

import Foundation
import FirebaseAuth

@MainActor
final class PostViewModel: ObservableObject {

    @Published var location: String = ""
    @Published var extraInfo: String = ""
    @Published var numberOfPeople: Int = 1
    @Published var selectedDate = Date()
    @Published var errorMessage: String?
    @Published var suggestions: [PlaceSuggestion] = []

    @Published var hitPost: HitPost? = nil
    @Published var isPublic: Bool = true

    private var posterUID = ""
    private var posterName = ""
    private var posterUTR: Double? = nil
    private var posterUSTA: Double? = nil
    private var selectedCity = ""
    private var didSelectSuggestion = false
    private var posterProfilePictureURL: String? = nil
    
    private let service = PostService()

    init() {
        Task { await fetchPosterInfo() }
    }

    private func fetchPosterInfo() async {
        guard let profile = try? await CurrentUserService.shared.fetchUserProfile() else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        posterUID = uid
        posterName = profile.name
        posterUTR = profile.UTR
        posterUSTA = profile.USTA
        posterProfilePictureURL = profile.profilePictureURL
    }

    func post() {
        hitPost = HitPost(
            id: UUID().uuidString, //Just generates a unique string for swift
            userID: posterUID,
            posterName: posterName,
            posterUTR: posterUTR,
            posterUSTA: posterUSTA,
            location: location,
            city: selectedCity,
            date: selectedDate,
            extraInfo: extraInfo,
            numberOfPeople: numberOfPeople,
            isPublic: isPublic,
            profilePictureURL: posterProfilePictureURL
        )
    }

    func confirmPost() {
        Task {
            guard let post = hitPost else { return }
            try? await service.savePost(post: post)
            hitPost = nil
        }
    }

    func dismissPreview() {
        hitPost = nil
    }

    func autocomplete() {
        guard !didSelectSuggestion else {
            didSelectSuggestion = false
            return
        }
        Task {
            do {
                suggestions = try await GooglePlacesService.autocomplete(input: location)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func selectSuggestion(_ suggestion: PlaceSuggestion) {
        didSelectSuggestion = true
        let parts = suggestion.description.components(separatedBy: ",")
        location = parts.first?.trimmingCharacters(in: .whitespaces) ?? suggestion.description
        selectedCity = parts.dropFirst(2).first?.trimmingCharacters(in: .whitespaces) ?? ""
        suggestions = []
    }
}
