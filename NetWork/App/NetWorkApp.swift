//
//  NetWorkApp.swift
//  NetWork
//
//  Created by Rezka Yuspi on 9/14/24.
//

import SwiftUI

@main
struct NetWorkApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authState = AuthState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authState)
        }
    }
}
