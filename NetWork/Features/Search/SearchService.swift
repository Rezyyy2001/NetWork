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

        async let firstNameResults = query(field: FirestoreKeys.UserFields.nameLowercased, matching: searchLowercased)
        async let lastNameResults = query(field: FirestoreKeys.UserFields.lastNameLowercased, matching: searchLowercased)

        let combined = await firstNameResults + lastNameResults
        var seen = Set<String>()
        return combined.filter { seen.insert($0.id).inserted }
    }

    private func query(field: String, matching searchLowercased: String) async -> [UserStub] {
        guard let snapshot = try? await db.collection(FirestoreKeys.Collections.users)
            .whereField(field, isGreaterThanOrEqualTo: searchLowercased)
            .whereField(field, isLessThanOrEqualTo: searchLowercased + "\u{f8ff}")
            .getDocuments()
        else { return [] }

        return snapshot.documents.compactMap { doc in
            let name = doc.data()[FirestoreKeys.UserFields.name] as? String
            let profilePictureURL = doc.data()[FirestoreKeys.UserFields.profilePictureURL] as? String
            return UserStub(uid: doc.documentID, displayName: name, profilePictureURL: profilePictureURL)
        }
    }
}
