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

    private var isNextButtonEnabled: Bool {
        // 모든 질문이 선택되었는지 확인
        SurveyQuestion.mockData.allSatisfy { viewModel.workPreferenceData.selectedAnswers[$0.id] != nil }
    }

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
                        viewModel.navigateToNext(.calendarConnectView)
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

                NextButton(isEnabled: isNextButtonEnabled)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - Header and Title View
private struct WorkPreferenceHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("3")
                .applyFont(.head_b_40)
                .foregroundColor(.gray07)

            Text("Discover how you work best.")
                .applyFont(.title_b_24)
                .foregroundColor(.white)
                .padding(.top, 18)
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
                    Text("Yes")
                        .applyFont(.body_b_14)
                        .foregroundColor(selectedAnswer == true ? .white : .gray06)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedAnswer == true ? .gray08 : Color.mainNavy)
                        .cornerRadius(8)
                }

                Button(action: { onSelection(false) }) {
                    Text("No")
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
    var isEnabled: Bool

    var body: some View {
        Button {
            if isEnabled {
                viewModel.navigateToNext(.calendarConnectView)
            }
        } label: {
            Text("Next")
                .applyFont(.body_b_16)
                .foregroundColor(isEnabled ? .black : .gray08)
                .padding(EdgeInsets(top: 13, leading: 0, bottom: 13, trailing: 0))
                .frame(maxWidth: .infinity)
        }
        .cornerRadius(2)
        .frame(height: 50)
        .background(isEnabled ? Color.green : Color.gray10)
        .disabled(!isEnabled)
    }
}

#Preview {
    WorkPreferenceView().environmentObject(OnboardingViewModel())
}
