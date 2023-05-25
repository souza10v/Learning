//
//  LearningApp.swift
//  Learning
//
//  Created by Donizetti de Souza on 4/29/23.
//

import SwiftUI
import Firebase

@main
struct LearningApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        
        WindowGroup {
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
