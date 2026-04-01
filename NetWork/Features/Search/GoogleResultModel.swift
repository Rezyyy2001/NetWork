//
//  GoogleResultModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/25/26.
//

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
