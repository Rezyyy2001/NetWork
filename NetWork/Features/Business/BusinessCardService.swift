//
//  BusinessCardService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 7/13/26.
//

import Foundation
@preconcurrency import FirebaseFirestore
import FirebaseAuth

struct BusinessCardService: Sendable {

    static let rightSwipeCooldownDays = 21
    private static let maxReviewCards = 50
    private static let idQueryChunkSize = 30
    private static let maxDiscoveryPool = 200

    private let db = Firestore.firestore()

    func saveBusinessCard(cardID: String?, isActive: Bool, city: String, serviceType: String, pricing: Int, description: String, tags: [String], phoneNumber: String?, email: String?, insta: String?, backgroundPic: String?) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }

        let userDoc = try await db.collection(FirestoreKeys.Collections.users).document(user.uid).getDocument()
        let cardName = userDoc.data()?[FirestoreKeys.UserFields.name] as? String ?? ""
        let profilePicture = userDoc.data()?[FirestoreKeys.UserFields.profilePictureURL] as? String ?? ""

        var userData: [String: Any] = [
            FirestoreKeys.BusinessCardFields.userID: user.uid,
            FirestoreKeys.BusinessCardFields.isActive: isActive,
            FirestoreKeys.BusinessCardFields.city: city,
            FirestoreKeys.BusinessCardFields.serviceType: serviceType,
            FirestoreKeys.BusinessCardFields.pricing: pricing,
            FirestoreKeys.BusinessCardFields.description: description,
            FirestoreKeys.BusinessCardFields.tags: tags,
            FirestoreKeys.BusinessCardFields.phoneNumber: phoneNumber ?? "",
            FirestoreKeys.BusinessCardFields.email: email ?? "",
            FirestoreKeys.BusinessCardFields.insta: insta ?? "",
            FirestoreKeys.BusinessCardFields.backgroundPic: backgroundPic ?? "",
            FirestoreKeys.BusinessCardFields.cardName: cardName,
            FirestoreKeys.BusinessCardFields.profilePicture: profilePicture
        ]

        let collection = db.collection(FirestoreKeys.Collections.businessCard)
        if let cardID {
            // Merge so fields not listed above (notably likeCount) are preserved.
            try await collection.document(cardID).setData(userData, merge: true)
        } else {
            userData[FirestoreKeys.BusinessCardFields.likeCount] = 0
            try await collection.document().setData(userData)
        }
    }
    
    func fetchUserCard() async throws -> [BusinessCard] {
        let query: Query = db.collection(FirestoreKeys.Collections.businessCard)
            .whereField(FirestoreKeys.BusinessCardFields.userID, isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .limit(to: 10)
        do {
            let snapshot = try await query.getDocuments()
            return snapshot.documents.compactMap(buildCard)
        } catch {
            print("fetch Business card error \(error)")
            return []
        }
    }

    func fetchActiveCards() async throws -> [BusinessCard] {
        let snapshot = try await db.collection(FirestoreKeys.Collections.businessCard)
            .whereField(FirestoreKeys.BusinessCardFields.isActive, isEqualTo: true)
            .limit(to: Self.maxDiscoveryPool)
            .getDocuments()
        let currentUID = Auth.auth().currentUser?.uid
        return snapshot.documents
            .compactMap(buildCard)
            .filter { $0.userID != currentUID }
    }

    func fetchCards(withIDs ids: [String]) async throws -> [BusinessCard] {
        let capped = Array(ids.prefix(Self.maxReviewCards))
        guard !capped.isEmpty else { return [] }

        var fetched: [BusinessCard] = []
        var start = 0
        while start < capped.count {
            let chunk = Array(capped[start ..< min(start + Self.idQueryChunkSize, capped.count)])
            start += Self.idQueryChunkSize
            let snapshot = try await db.collection(FirestoreKeys.Collections.businessCard)
                .whereField(FieldPath.documentID(), in: chunk)
                .whereField(FirestoreKeys.BusinessCardFields.isActive, isEqualTo: true)
                .getDocuments()
            fetched.append(contentsOf: snapshot.documents.compactMap(buildCard))
        }

        let rank = Dictionary(uniqueKeysWithValues: capped.enumerated().map { ($1, $0) })
        return fetched.sorted { (rank[$0.id] ?? .max) < (rank[$1.id] ?? .max) }
    }

    func recordSwipe(cardID: String, direction: SwipeDirection) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }
        let ref = db.collection(FirestoreKeys.Collections.users).document(uid)
            .collection(FirestoreKeys.Collections.swipedCards).document(cardID)

        var data: [String: Any] = [
            FirestoreKeys.SwipedCardFields.direction: direction.rawValue,
            FirestoreKeys.SwipedCardFields.timestamp: FieldValue.serverTimestamp()
        ]
        if direction == .right {
            let expiry = Calendar.current.date(
                byAdding: .day, value: Self.rightSwipeCooldownDays, to: Date()
            ) ?? Date()
            data[FirestoreKeys.SwipedCardFields.expiresAt] = Timestamp(date: expiry)
        }
        try await ref.setData(data)
    }

    func fetchSwipeHistory() async throws -> (excluded: Set<String>, skipped: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return ([], []) }
        let collection = db.collection(FirestoreKeys.Collections.users).document(uid)
            .collection(FirestoreKeys.Collections.swipedCards)
        let snapshot = try await collection.getDocuments()

        let now = Date()
        var excluded: Set<String> = []
        var skipped: [(id: String, date: Date)] = []
        var expired: [String] = []

        for doc in snapshot.documents {
            let data = doc.data()
            let direction = data[FirestoreKeys.SwipedCardFields.direction] as? String
            if direction == SwipeDirection.left.rawValue {
                excluded.insert(doc.documentID)
            } else if direction == SwipeDirection.right.rawValue {
                let expiresAt = (data[FirestoreKeys.SwipedCardFields.expiresAt] as? Timestamp)?.dateValue()
                if let expiresAt, expiresAt > now {
                    excluded.insert(doc.documentID)
                    let swipedAt = (data[FirestoreKeys.SwipedCardFields.timestamp] as? Timestamp)?.dateValue()
                    skipped.append((doc.documentID, swipedAt ?? .distantPast))
                } else {
                    expired.append(doc.documentID)
                }
            }
        }

        if !expired.isEmpty {
            let batch = db.batch()
            for id in expired { batch.deleteDocument(collection.document(id)) }
            try? await batch.commit()
        }

        let skippedIDs = skipped.sorted { $0.date < $1.date }.map(\.id)
        return (excluded, skippedIDs)
    }

    private func buildCard(_ doc: QueryDocumentSnapshot) -> BusinessCard? {
        let data = doc.data()
        guard let serviceType = ServiceType(
            rawValue: data[FirestoreKeys.BusinessCardFields.serviceType] as? String ?? ""
        ) else {
            return nil
        }
        return BusinessCard(
            id: doc.documentID,
            userID: data[FirestoreKeys.BusinessCardFields.userID] as? String ?? "",
            isActive: data[FirestoreKeys.BusinessCardFields.isActive] as? Bool ?? false,
            serviceType: serviceType,
            pricing: data[FirestoreKeys.BusinessCardFields.pricing] as? Int ?? 0,
            city: data[FirestoreKeys.BusinessCardFields.city] as? String ?? "",
            likeCount: data[FirestoreKeys.BusinessCardFields.likeCount] as? Int ?? 0,
            description: data[FirestoreKeys.BusinessCardFields.description] as? String ?? "",
            tags: (data[FirestoreKeys.BusinessCardFields.tags] as? [String])?.compactMap { ServiceTag(rawValue: $0) } ?? [],
            phoneNumber: data[FirestoreKeys.BusinessCardFields.phoneNumber] as? String,
            email: data[FirestoreKeys.BusinessCardFields.email] as? String,
            insta: data[FirestoreKeys.BusinessCardFields.insta] as? String,
            cardName: data[FirestoreKeys.BusinessCardFields.cardName] as? String ?? "",
            profilePicture: data[FirestoreKeys.BusinessCardFields.profilePicture] as? String ?? "",
            backgroundPic: data[FirestoreKeys.BusinessCardFields.backgroundPic] as? String ?? ""
        )
    }
    
    func fetchSingleCard(cardID: String) async throws -> BusinessCard {
        let query: Query = db.collection(FirestoreKeys.Collections.businessCard)
            .whereField(FieldPath.documentID(), isEqualTo: cardID)
        
            let snapshot = try await query.getDocuments()
            guard let card = snapshot.documents.compactMap(buildCard).first else {
                throw NSError(domain: "Card not found", code: 404, userInfo: nil)
            }
        return card
    }
    
    func likeCard(cardID: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }
        let cardRef = db.collection(FirestoreKeys.Collections.businessCard).document(cardID)
        let likeRef = cardRef.collection(FirestoreKeys.Collections.likes).document(uid)

        _ = try await db.runTransaction { transaction, errorPointer in
            do {
                let likeDoc = try transaction.getDocument(likeRef)
                guard !likeDoc.exists else { return nil }
                transaction.setData([:], forDocument: likeRef)
                transaction.updateData(
                    [FirestoreKeys.BusinessCardFields.likeCount: FieldValue.increment(Int64(1))],
                    forDocument: cardRef
                )
            } catch {
                errorPointer?.pointee = error as NSError
            }
            return nil
        }
    }
    
    func hasLiked(cardID: String) async -> Bool {
        let doc = try? await db.collection(FirestoreKeys.Collections.businessCard)
            .document(cardID)
            .collection(FirestoreKeys.Collections.likes)
            .document(Auth.auth().currentUser?.uid ?? "")
            .getDocument()
        return doc?.exists ?? false
    }
}
