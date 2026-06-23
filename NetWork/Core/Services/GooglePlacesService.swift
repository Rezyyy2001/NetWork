//
//  GooglePlacesService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/11/26.
//

import Foundation

struct GooglePlacesService {
    
    static func searchTennisCourt(query: String) async throws -> [PlaceResult] {
        let apiKey = Secrets.googleAPIKey

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        let urlString =
            "https://maps.googleapis.com/maps/api/place/textsearch/json" +
            "?query=\(encodedQuery)" +
            "&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL")
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(TextSearchResponse.self, from: data)
        return decoded.results
    }
    
    static func autocomplete(input: String) async throws -> [PlaceSuggestion] {
        let apiKey = Secrets.googleAPIKey

        let encodedInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? input
        
        let urlString =
            "https://maps.googleapis.com/maps/api/place/autocomplete/json" +
            "?input=\(encodedInput)" +
            "&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL")
            return []
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(AutoTextSearch.self, from: data)
        return decoded.predictions
    }
}
