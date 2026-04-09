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
    
    func post() {
        Task {
            try await GooglePlacesService.searchTennisCourt(query: location)
        }
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
}
