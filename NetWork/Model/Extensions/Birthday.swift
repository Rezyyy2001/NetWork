//
//  Birthday.swift
//  NetWork
//
//  Created by Rezka Yuspi on 3/5/26.
//

import SwiftUI

extension Date {
    var age: Int {
        Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    }
}
