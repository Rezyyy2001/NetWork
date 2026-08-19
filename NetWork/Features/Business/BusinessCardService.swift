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
    
    private let db = Firestore.firestore()
    
    func saveBusinessCard(cardID: String?, isActive: Bool, city: String, serviceType: String, pricing: Int, likeCount: Int, description: String, tags: [String], phoneNumber: String?, email: String?, insta: String?, backgroundPic: String?) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }
        
        let userDoc = try await db.collection(FirestoreKeys.Collections.users).document(user.uid).getDocument()
        let cardName = userDoc.data()?[FirestoreKeys.UserFields.name] as? String ?? ""
        let profilePicture = userDoc.data()?[FirestoreKeys.UserFields.profilePictureURL] as? String ?? ""

        let userData: [String: Any] = [
            FirestoreKeys.BusinessCardFields.userID: user.uid,
            FirestoreKeys.BusinessCardFields.isActive: isActive,
            FirestoreKeys.BusinessCardFields.city: city,
            FirestoreKeys.BusinessCardFields.serviceType: serviceType,
            FirestoreKeys.BusinessCardFields.pricing: pricing,
            FirestoreKeys.BusinessCardFields.likeCount: likeCount,
            FirestoreKeys.BusinessCardFields.description: description,
            FirestoreKeys.BusinessCardFields.tags: tags,
            FirestoreKeys.BusinessCardFields.phoneNumber: phoneNumber ?? "",
            FirestoreKeys.BusinessCardFields.email: email ?? "",
            FirestoreKeys.BusinessCardFields.insta: insta ?? "",
            FirestoreKeys.BusinessCardFields.backgroundPic: backgroundPic ?? "",
            FirestoreKeys.BusinessCardFields.cardName: cardName,
            FirestoreKeys.BusinessCardFields.profilePicture: profilePicture
        ]
        
        let ref = cardID != nil
            ? Firestore.firestore().collection(FirestoreKeys.Collections.businessCard).document(cardID!)
            : Firestore.firestore().collection(FirestoreKeys.Collections.businessCard).document()
        try await ref.setData(userData)
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

    func fetchAllActiveCards() async throws -> [BusinessCard] {
        let query: Query = db.collection(FirestoreKeys.Collections.businessCard)
            .whereField(FirestoreKeys.BusinessCardFields.isActive, isEqualTo: true)
        do {
            let snapshot = try await query.getDocuments()
            return snapshot.documents.compactMap(buildCard)
        } catch {
            print("Could not fetch cards (error: \(error))")
            return []
        }
    }

    private func buildCard(_ doc: QueryDocumentSnapshot) -> BusinessCard {
        let data = doc.data()
        return BusinessCard(
            id: doc.documentID,
            userID: data[FirestoreKeys.BusinessCardFields.userID] as? String ?? "",
            isActive: data[FirestoreKeys.BusinessCardFields.isActive] as? Bool ?? false,
            serviceType: ServiceType(rawValue: data[FirestoreKeys.BusinessCardFields.serviceType] as? String ?? "") ?? .stringing,
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
        let docRef = db.collection(FirestoreKeys.Collections.businessCard).document(cardID)
        
        try await docRef.collection(FirestoreKeys.Collections.likes)
            .document(Auth.auth().currentUser?.uid ?? "")
            .setData([:])
        
        try await docRef.updateData(["likeCount" : FieldValue.increment(Int64(1))])
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
