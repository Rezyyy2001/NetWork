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
        
        // dataTask is asynchronous
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(TextSearchResponse.self, from: data)
        for place in decoded.results {
            print("Name:", place.name)
            print("Address:", place.formatted_address ?? "N/A")
            print("Place ID:", place.id)
            print("---")
        }
        return decoded.results
    }
}
