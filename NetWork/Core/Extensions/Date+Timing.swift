//
//  Date+Timing.swift
//  NetWork
//
//  Created by Rezka Yuspi on 11/10/26.
//

import Foundation

extension Date {
    var minutesFromNow: Int {
        Int(timeIntervalSinceNow / 60)
    }
    
    var hasPassed: Bool {
        self < Date()
    }

    func isWithin(_ interval: TimeInterval) -> Bool {
        self - interval < Date()
    }
}
