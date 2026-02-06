//
//  Secrets.swift
//  NetWork
//
//  Created by Rezka Yuspi on 2/5/26.
//

import Foundation

enum Secrets {
    static var googleAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_KEY") as? String else {
            fatalError("Missing GOOGLE_API_KEY")
        }
        return key
    }
}
