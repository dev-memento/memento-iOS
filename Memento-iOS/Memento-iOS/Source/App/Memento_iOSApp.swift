//
//  Memento_iOSApp.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/5/25.
//

import SwiftUI

@main
struct MementoApp: App {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(onboardingViewModel)
        }
    }
}
