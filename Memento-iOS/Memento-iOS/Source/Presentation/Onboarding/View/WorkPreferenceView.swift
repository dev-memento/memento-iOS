//
//  WorkPreferenceView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/10/25.
//

import SwiftUI
import MDSKit

struct WorkPreferenceView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel // 뷰모델 주입
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading) {
                CustomNavigationBar(
                    showBackButton: true,
                    showSkipButton: true,
                    backButtonAction: {
                        viewModel.navigateBack()
                    },
                    skipButtonAction: {
                        viewModel.navigateToNext(.calendarConnect)
                    }
                )
                .padding([.trailing, .top], 16)
                
                StepProgressBar(currentStep: 3, totalSteps: 4)
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                
                WorkPreferenceHeaderView()
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(SurveyQuestion.mockData) { question in
                            QuestionRow(
                                question: question,
                                selectedAnswer: viewModel.workPreferenceData.selectedAnswers[question.id] ?? nil,
                                onSelection: { selectedAnswer in
                                    viewModel.workPreferenceData.selectedAnswers[question.id] = selectedAnswer
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                }
                
                Spacer()
                
                NextButton()
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - Header and Title View

private struct WorkPreferenceHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(OnboardingWorkPreferenceText.threeStepTitle)
                .applyFont(.head_b_40)
                .foregroundColor(.gray07)
            
            Text(OnboardingWorkPreferenceText.workPreferenceHeaderTitle)
                .applyFont(.title_b_24)
                .foregroundColor(.white)
        }
    }
}

// MARK: - QuestionRow

struct QuestionRow: View {
    let question: SurveyQuestion
    let selectedAnswer: Bool?
    let onSelection: (Bool?) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(question.question)
                .applyFont(.body_r_16)
                .foregroundColor(.white)
            
            HStack(spacing: 11) {
                Button(action: { onSelection(true) }) {
                    Text(OnboardingWorkPreferenceText.yes)
                        .applyFont(.body_b_14)
                        .foregroundColor(selectedAnswer == true ? .white : .gray06)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedAnswer == true ? .gray08 : Color.mainNavy)
                        .cornerRadius(8)
                }
                
                Button(action: { onSelection(false) }) {
                    Text(OnboardingWorkPreferenceText.no)
                        .applyFont(.body_b_14)
                        .foregroundColor(selectedAnswer == false ? .white : .gray06)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedAnswer == false ? .gray08 : Color.mainNavy)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.gray10)
    }
}

// MARK: - Next Button

private struct NextButton: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Button {
            if viewModel.isNextButtonEnabledForWorkPreference {
                viewModel.navigateToNext(.calendarConnect)
            }
        } label: {
            Text(OnboardingPublicText.nextButton)
                .applyFont(.body_b_16)
                .foregroundColor(viewModel.isNextButtonEnabledForWorkPreference ? .black : .gray08)
                .padding(EdgeInsets(top: 13, leading: 0, bottom: 13, trailing: 0))
                .frame(maxWidth: .infinity)
        }
        .cornerRadius(2)
        .frame(height: 50)
        .background(viewModel.isNextButtonEnabledForWorkPreference ? Color.mainGreen : Color.gray10)
        .disabled(!viewModel.isNextButtonEnabledForWorkPreference)
    }
}

#Preview {
    WorkPreferenceView().environmentObject(OnboardingViewModel(authViewModel: AuthViewModel()))
}
