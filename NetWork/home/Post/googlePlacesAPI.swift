//
//  googlePlacesAPI.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/11/26.
//

import Foundation

struct googlePlacesAPI {
    // key: AIzaSyDtNooh32BlGSCmGhgwxnrzCh-8OhU7sZ4
    // switch API key 
    
    static func searchTennisCourt(query: String) {
        let apiKey = "AIzaSyDtNooh32BlGSCmGhgwxnrzCh-8OhU7sZ4"

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        let urlString =
            "https://maps.googleapis.com/maps/api/place/textsearch/json" +
            "?query=\(encodedQuery)" +
            "&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
               print("Error:", error)
               return
           }

           guard let data = data else {
               print("No data")
               return
           }
            
            do {
                let decoded = try JSONDecoder().decode(TextSearchResponse.self, from: data)
                for place in decoded.results {
                    print("Name:", place.name)
                    print("Address:", place.formatted_address ?? "N/A")
                    print("---")
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
}

// Decodable

struct TextSearchResponse: Decodable {
    let results: [PlaceResult]
}

struct PlaceResult: Decodable {
    let name: String
    let formatted_address: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case formatted_address = "formatted_address"
    }
}
