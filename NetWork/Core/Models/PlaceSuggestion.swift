//
//  PlaceSuggestion.swift
//  NetWork
//
//  Created by Rezka Yuspi on 4/9/26.
//

struct AutoTextSearch: Decodable {
    let predictions: [PlaceSuggestion]
}

struct PlaceSuggestion: Codable, Identifiable {
    let description: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case id = "place_id"
    }
}

