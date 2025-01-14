//
//  StringLiteral.swift
//  Memento-iOS
//
//  Created by Gahyun Kim on 1/10/25.
//

import Foundation

enum StringLiteral {
    
    enum Priority {
        static let immediate = "Immediate"
        static let high = "High"
        static let medium = "Medium"
        static let low = "Low"
        static let none = "None"
    }
    
    enum Onboarding {
        
        // LoginView
        static let loginHeaderTitle = "Less Noise,\nMore Progress"
        static let moreProgress = "More Progress"
        static let googleButton = "Continue with Google"
        static let appleButton = "Continue with Apple"
        static let agreeToMemento = "by continuing, you agree to memento's"
        static let termsOfUse = "Terms of Use"
        
        // SleepCycleSetting
        static let oneStepTitle = "1"
        static let sleepCycleSettingHeaderTitle = "Set your\nwake-up and\nwind-down hours."
        static let wakeUpTitle = "Wake-up"
        static let windDownTitle = "Wind-down"
        static let defaultTime = "00:00 AM"
        
        // WorkSelectionView
        static let twoStepTitle = "2"
        static let workSelectionHeaderTitle = "What do you do for work?"
        
        // WorkPreferenceView
        static let threeStepTitle = "3"
        static let WorkPreferenceHederTitle = "Discover how you work best."
        static let yes = "Yes"
        static let no = "No"
        
        // CalendarConnectView
        static let CalendarConnectHeaderTitle = "Connect your calendar\nfor seamless scheduling."
        static let connectGoogleCalendar = "Connect Google Calendar"
        static let connectAppleCalendar = "Connect Apple Calendar"
        
        // Button
        static let startMementoButton = "Start MEMENTO"
        static let nextButton = "Next"
    }
}
