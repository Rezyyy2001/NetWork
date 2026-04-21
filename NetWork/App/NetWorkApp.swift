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
            if authState.isAuthenticated {
                HomeView()
            } else {
                ContentView()
                    .environmentObject(authState)
                    .id(UUID()) // when authState switches, it also switches the view to contentView with a new unique id
            }
        }
    }
}
