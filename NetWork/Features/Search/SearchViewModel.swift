//
//  searchViewModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/21/25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class SearchViewModel: ObservableObject {
    
    @Published var searchText: String = "" // The string that is entered in the search bar
    @Published var searchResults: [UserStub] = [] // spits back an array of userStubs matching the searchText string
    
    private let service = SearchService()

    // searches users in firestore database
    func searchUsers() {
        Task {
            self.searchResults = await service.searchUsers(matching: searchText)
        }
    }
}
