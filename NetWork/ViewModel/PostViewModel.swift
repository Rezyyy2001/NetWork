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
    
    func post() {
        googlePlacesAPI.searchTennisCourt(query: location)
    }
}
