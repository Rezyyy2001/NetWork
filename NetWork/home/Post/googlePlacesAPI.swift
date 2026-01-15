//
//  googlePlacesAPI.swift
//  NetWork
//
//  Created by Rezka Yuspi on 1/11/26.
//

import Foundation

struct googlePlacesAPI {
    // key: AIzaSyDtNooh32BlGSCmGhgwxnrzCh-8OhU7sZ4
    
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
            
           if let jsonString = String(data: data, encoding: .utf8) {
               print(jsonString)
           }
        }.resume()
    }
    
}


