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
        let apiKey = "AIzaSyCj6kFpwsGmw1tYJ4yEpy0APApzSwWOthE"

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        
        let urlString =
            "https://maps.googleapis.com/maps/api/place/textsearch/json" +
            "?query=\(encodedQuery)" +
            "&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL")
            return
        }
        
        // dataTask is asynchronous
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
                    print("Place ID:", place.id)
                    print("---")
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }
}

// Decodable

// We put the results into an array
struct TextSearchResponse: Decodable {
    let results: [PlaceResult]
}

// We define what the array is and what it contains
// Codable so it can go from JSON to swift and swift to JSON
// Identifiable to make it a list
struct PlaceResult: Codable, Identifiable {
    let id: String
    let name: String
    let formatted_address: String?
    
    // Coding keys to map JSON names to swift properties
    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case name
        case formatted_address = "formatted_address"
    }
}
