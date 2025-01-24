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
        
        enum LoginView {
            static let loginHeaderTitle = "Less Noise,\nMore Progress"
            static let moreProgress = "More Progress"
            static let googleButton = "Continue with Google"
            static let appleButton = "Continue with Apple"
            static let agreeToMemento = "by continuing, you agree to memento's"
            static let termsOfUse = "Terms of Use"
        }
        
        enum SleepCycleSettingView {
            static let oneStepTitle = "1"
            static let sleepCycleSettingHeaderTitle = "하루를 시작하는 시간과"
            static let sleepCycleSettingHeaderTitle2 = "끝내는 시간을 설정합니다."
            static let wakeUpTitle = "Wake-up"
            static let windDownTitle = "Wind-down"
            static let defaultTime = "00:00 AM"
        }
        
        enum WorkSelectionView {
            static let twoStepTitle = "2"
            static let workSelectionHeaderTitle = "어떤 일을 하시나요?"
        }
        
        enum WorkPreferenceView {
            static let threeStepTitle = "3"
            static let workPreferenceHeaderTitle = "어떤 방식으로 업무를 하시나요?"
            static let yes = "Yes"
            static let no = "No"
            static let surveyQuestion1 = "하루를 시작할 때 중요한 일을 먼저 처리하는 것을 선호하시나요?"
            static let surveyQuestion2 = "마감 기한이 여유 있을 때도, 마감일에 가까워지기 전에 일을 시작하시나요?"
            static let surveyQuestion3 = "한 번에 여러 가지 일을 동시에 처리하는 것이 더 효율적이라고 느끼시나요?"
            static let surveyQuestion4 = "업무/학업 관련 일정을 개인 일정보다 더 중요하게 생각하시나요?"

        }
        
        enum CalendarConnectView {
            static let calendarConnectHeaderTitle = "기존의 사용하던 캘린더로부터 일정을 불러옵니다."
            static let connectGoogleCalendar = "Connect Google Calendar"
            static let connectAppleCalendar = "Connect Apple Calendar"
            static let startMementoButton = "Start MEMENTO"
        }

        static let nextButton = "Next"
    }
    
    enum Alert {
        static let deadline = "Deadline"
        static let tag = "Tag"
        static let priority = "Priority"
        static let delete = "Delete"
        static let edit = "Edit"
        static let start = "Starts"
        static let end = "Ends"
        static let from = "From"
    }
    
    enum Today {
        static let wakeUp = "Wake up"
        static let windDown = "Wind down"
    }

    enum AddEvent {
        static let title = "Add your event"
    }
}

//MARK: typealias

typealias OnboardingLoginText = StringLiteral.Onboarding.LoginView
typealias OnboardingSleepCycleText = StringLiteral.Onboarding.SleepCycleSettingView
typealias OnboardingWorkSelectionText = StringLiteral.Onboarding.WorkSelectionView
typealias OnboardingWorkPreferenceText = StringLiteral.Onboarding.WorkPreferenceView
typealias OnboardingCalendarConnectText = StringLiteral.Onboarding.CalendarConnectView
typealias OnboardingPublicText = StringLiteral.Onboarding
