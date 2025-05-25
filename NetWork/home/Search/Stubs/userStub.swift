//
//  userStub.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/22/25.
//

import Foundation

// Just a data model
struct userStub: Identifiable, Hashable, Decodable {
    
    let id: String  // Conforms to Identifiable for SwiftUI lists
    let displayName: String?

    init(uid: String, displayName: String?) {
        self.id = uid
        self.displayName = displayName
    }
    
    // Implement the equality check based on 'id' (or any other unique property)
    static func == (lhs: userStub, rhs: userStub) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Implement hash(into:) to conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

