//
//  HitRequest.swift
//  NetWork
//
//  Created by Rezka Yuspi on 6/14/26.
//

import Foundation

struct HitRequest {
    let postID: String
    let requesterID: String
    let posterID: String
    let status: HitRequestStatus
    
    enum HitRequestStatus {
        case expired
        case pending
        case accepted
    }
}
