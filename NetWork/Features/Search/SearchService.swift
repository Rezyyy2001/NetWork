//
//  SearchService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/5/26.
//

@preconcurrency import Firebase

final class SearchService: Sendable {
    private let db = Firestore.firestore()

    func searchUsers(matching searchText: String) async -> [UserStub] {
        let searchLowercased = searchText.lowercased()

        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.users)
            .whereField(FirestoreKeys.UserFields.nameLowercased, isGreaterThanOrEqualTo: searchLowercased)
            .whereField(FirestoreKeys.UserFields.nameLowercased, isLessThanOrEqualTo: searchLowercased + "\u{f8ff}")
            .getDocuments()
        else { return [] }

        return snapshot.documents.compactMap { doc in
            let data = doc.data()
            let name = data[FirestoreKeys.UserFields.name] as? String
            let uid = doc.documentID
            return UserStub(uid: uid, displayName: name)
        }
    }
}
