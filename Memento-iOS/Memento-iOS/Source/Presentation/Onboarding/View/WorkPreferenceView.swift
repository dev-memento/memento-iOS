//
//  WorkPreferenceView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/10/25.
//

import SwiftUI
import MDSKit

struct WorkPreferenceView: View {
    @State private var selectedAnswers: [UUID: Bool?] = [:] // 각 질문에 대한 선택 상태 저장 (초기값은 선택 안 됨)
    @Binding var path: [OnBoardingNavigationDestination]

    private var isNextButtonEnabled: Bool {
        // allSatisfy는 클로저(조건)로 전달된 코드가 컬렉션의 모든 요소에 대해 true를 반환해야만 최종적으로 true를 반환
        SurveyQuestion.mockData.allSatisfy { selectedAnswers[$0.id] != nil }
    }

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(alignment: .leading) {
                CustomNavigationBar(path: $path)
                    .padding(.horizontal)
                    .padding(.top, 16)

                StepProgressBar(currentStep: 3, totalSteps: 4)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)

                HeaderTitleView()
                    .padding(.horizontal)
                    .padding(.top, 8)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(SurveyQuestion.mockData) { question in
                            QuestionRow(
                                question: question,
                                selectedAnswer: selectedAnswers[question.id] ?? nil,
                                onSelection: { selectedAnswer in
                                    selectedAnswers[question.id] = selectedAnswer
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                }

                Spacer()

                NextButton(isEnabled: isNextButtonEnabled, path: $path)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - CustomNavigationBar
private struct CustomNavigationBar: View {
    @Binding var path: [OnBoardingNavigationDestination]
    
    var body: some View {
        HStack(alignment: .top) {
            Button {
                path.removeLast()
            } label: {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 7.5, height: 16.5)
                    .foregroundColor(.gray06)
            }
            
            Spacer()
            
            Button {
                path.append(.workSelection)
            } label: {
                Text("Skip")
                    .applyFont(.body_b_14)
                    .foregroundColor(.gray06)
            }
        }
    }
}

// MARK: - Header and Title View
private struct HeaderTitleView: View {
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
    var isEnabled: Bool
    @Binding var path: [OnBoardingNavigationDestination]
    
    var body: some View {
        Button {
            if isEnabled {
                path.append(.workSelection)
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
    WorkPreferenceView(path: .constant([]))
}

