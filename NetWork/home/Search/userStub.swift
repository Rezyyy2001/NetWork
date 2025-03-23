//
//  userStub.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/22/25.
//

import Foundation

// Just a data model
struct userStub: Identifiable {
    let id: String  // Conforms to Identifiable for SwiftUI lists
    let displayName: String?

    init(uid: String, displayName: String?) {
        self.id = uid
        self.displayName = displayName
    }
}
