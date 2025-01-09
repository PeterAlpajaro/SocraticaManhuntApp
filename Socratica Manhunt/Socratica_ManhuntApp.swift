//
//  Socratica_ManhuntApp.swift
//  Socratica Manhunt
//
//  Created by Peter Alpajaro on 10/17/24.
//

import SwiftUI

class UserManager: ObservableObject {
    @Published var isLoggedIn = false
}

@main
// Create the content view.
struct Socratica_ManhuntApp: App {
    @StateObject private var userManager = UserManager()
    
    var body: some Scene {
        WindowGroup {
           ContentView()
                .environmentObject(userManager)
        }
    }

}


