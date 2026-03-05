//
//  messageModel.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/26/25.
//

import Foundation
import FirebaseFirestore

// Data model for messages in firestore

// Needs to be encodable and decodable so the data is converted to this model.
// It is then sent to firestore and firestore can send the model back.
// In the middle of this transaction it is a JSON file

struct Message: Identifiable, Hashable, Decodable, Encodable {
    @DocumentID var id: String? 
    let text: String
    let senderID: String
    let timestamp: Date
}
