//
//  PostService.swift
//  NetWork
//
//  Created by Rezka Yuspi on 5/30/26.
//

import Foundation
@preconcurrency
import FirebaseFirestore
import FirebaseAuth

struct PostService: Sendable {
    private let db = Firestore.firestore()
    
    func savePost(post: HitPost) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "No authenticated user found.", code: 0, userInfo: nil)
        }
        
        let postData: [String: Any] = [
            FirestoreKeys.PostFields.userID: user.uid,
            FirestoreKeys.PostFields.posterName: post.posterName,
            FirestoreKeys.PostFields.posterUTR: post.posterUTR ?? 0.0,
            FirestoreKeys.PostFields.posterUSTA: post.posterUSTA ?? 0.0,
            FirestoreKeys.PostFields.location: post.location,
            FirestoreKeys.PostFields.city: post.city,
            FirestoreKeys.PostFields.date: post.date,
            FirestoreKeys.PostFields.extraInfo: post.extraInfo,
            FirestoreKeys.PostFields.numberOfPeople: post.numberOfPeople,
            FirestoreKeys.PostFields.isPublic: post.isPublic,
            FirestoreKeys.PostFields.profilePictureURL: post.profilePictureURL ?? ""
        ]
        
        try await Firestore.firestore().collection(FirestoreKeys.Collections.posts).document().setData(postData)
    }
    
    // TODO: They return the same thing use a private helper function to clean up this DRY violation
    
    func fetchPosts(isNewest: Bool, numberOfPeople: Int, isFriends: Bool, utrRange: [CGFloat], ustaRange: [CGFloat], friendIDs: [String]) async throws -> [HitPost] {
        
        var query: Query = db.collection(FirestoreKeys.Collections.posts)
            .order(by: FirestoreKeys.PostFields.date, descending: !isNewest)
            .whereField(FirestoreKeys.PostFields.date, isGreaterThanOrEqualTo: Date())
            .limit(to: 20)
        
        if isFriends && !friendIDs.isEmpty {
            query = query.whereField(FirestoreKeys.PostFields.userID, in: friendIDs)
        }
        
        do {
            let snapshot = try await query.getDocuments()
            
            var posts = snapshot.documents.compactMap { doc in
                let userID = doc.data()[FirestoreKeys.PostFields.userID] as? String ?? ""
                let posterName = doc.data()[FirestoreKeys.PostFields.posterName] as? String ?? ""
                let posterUTR = doc.data()[FirestoreKeys.PostFields.posterUTR] as? Double
                let posterUSTA = doc.data()[FirestoreKeys.PostFields.posterUSTA] as? Double
                let location = doc.data()[FirestoreKeys.PostFields.location] as? String ?? ""
                let city = doc.data()[FirestoreKeys.PostFields.city] as? String ?? ""
                let timestamp = doc.data()[FirestoreKeys.PostFields.date] as? Timestamp
                let date = timestamp?.dateValue() ?? Date()
                let extraInfo = doc.data()[FirestoreKeys.PostFields.extraInfo] as? String ?? ""
                let numberOfPeople = doc.data()[FirestoreKeys.PostFields.numberOfPeople] as? Int ?? 1
                let isPublic = doc.data()[FirestoreKeys.PostFields.isPublic] as? Bool ?? true
                let profilePictureURL = doc.data()[FirestoreKeys.PostFields.profilePictureURL] as? String
                
                return HitPost(id: doc.documentID, userID: userID, posterName: posterName, posterUTR: posterUTR, posterUSTA: posterUSTA, location: location, city: city, date: date, extraInfo: extraInfo, numberOfPeople: numberOfPeople, isPublic: isPublic, profilePictureURL: profilePictureURL)
            }
            
            switch numberOfPeople {
            case 1:
                posts = posts.filter { $0.numberOfPeople == 1 }
            case 3:
                posts = posts.filter { $0.numberOfPeople == 3 }
            case 4:
                posts = posts.filter { $0.numberOfPeople >= 4 }
            default:
                break
            }
            
            posts = posts.filter {
                ($0.posterUTR ?? 0) >= Double(utrRange[0]) &&
                ($0.posterUTR ?? 0) <= Double(utrRange[1]) &&
                ($0.posterUSTA ?? 0) >= Double(ustaRange[0]) &&
                ($0.posterUSTA ?? 0) <= Double(ustaRange[1])
            }
            
            // TODO: Find a way to filter location or nearby location and make it look nice in filterView
            
            return posts
            
        } catch {
            print("fetchPosts error \(error)") // gives us a link that allows us to create configured indexes
            return []
        }
    }
    
    func fetchUserPosts(userID: String, active: Bool) async throws -> [HitPost] {
        
        var query: Query = db.collection(FirestoreKeys.Collections.posts)
            .whereField(FirestoreKeys.PostFields.userID, isEqualTo: userID)
            .order(by: FirestoreKeys.PostFields.date, descending: false)
        
        if active {
            query = query.whereField(FirestoreKeys.PostFields.date, isGreaterThanOrEqualTo: Date())
          } else {
              query = query.whereField(FirestoreKeys.PostFields.date, isLessThan: Date())
          }
        
        do {
            let snapshot = try await query.getDocuments()
            
            let posts = snapshot.documents.compactMap { doc in
                let userID = doc.data()[FirestoreKeys.PostFields.userID] as? String ?? ""
                let posterName = doc.data()[FirestoreKeys.PostFields.posterName] as? String ?? ""
                let posterUTR = doc.data()[FirestoreKeys.PostFields.posterUTR] as? Double
                let posterUSTA = doc.data()[FirestoreKeys.PostFields.posterUSTA] as? Double
                let location = doc.data()[FirestoreKeys.PostFields.location] as? String ?? ""
                let city = doc.data()[FirestoreKeys.PostFields.city] as? String ?? ""
                let timestamp = doc.data()[FirestoreKeys.PostFields.date] as? Timestamp
                let date = timestamp?.dateValue() ?? Date()
                let extraInfo = doc.data()[FirestoreKeys.PostFields.extraInfo] as? String ?? ""
                let numberOfPeople = doc.data()[FirestoreKeys.PostFields.numberOfPeople] as? Int ?? 1
                let isPublic = doc.data()[FirestoreKeys.PostFields.isPublic] as? Bool ?? true
                let profilePictureURL = doc.data()[FirestoreKeys.PostFields.profilePictureURL] as? String ?? ""
                
                return HitPost(id: doc.documentID, userID: userID, posterName: posterName, posterUTR: posterUTR, posterUSTA: posterUSTA, location: location, city: city, date: date, extraInfo: extraInfo, numberOfPeople: numberOfPeople, isPublic: isPublic, profilePictureURL: profilePictureURL)
            }
            return posts
            
        } catch {
            print("fetchPosts error \(error)") // gives us a link that allows us to create configured indexes
            return []
        }
    }
}
