//
//  WorkSelectionView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import SwiftUI
import MDSKit

struct WorkSelectionView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @FocusState private var isTextFieldFocused: Bool

    private var isNextButtonEnabled: Bool {
        (viewModel.workSelectionData.selectedCategory != nil && viewModel.workSelectionData.selectedCategory != "Other") || !viewModel.workSelectionData.customCategory.isEmpty
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

                StepProgressBar(currentStep: 2, totalSteps: 4)
                    .padding(.horizontal, 16)
                    .padding(.top, 10)

                WorkSelectionHeaderView()
                    .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 0) {
                        CategoryListView(isTextFieldFocused: _isTextFieldFocused) // 체크하기

                        CustomCategoryInputView(isTextFieldFocused: _isTextFieldFocused)
                    }
                }
                .padding(.top, 28)
                .background(.black)

                Spacer()

                NextButton(isEnabled: isNextButtonEnabled)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - Header and Title View
private struct WorkSelectionHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("2")
                .applyFont(.head_b_40)
                .foregroundColor(.gray07)

            Text("What do you do for work?")
                .applyFont(.title_b_24)
                .foregroundColor(.white)
        }
    }
}

// MARK: - CategoryListView
private struct CategoryListView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @FocusState var isTextFieldFocused: Bool

    var body: some View {
        ForEach(Category.mockData) { category in
            HStack {
                SelectionIndicator(isSelected: viewModel.workSelectionData.selectedCategory == category.name)
                Text(category.name)
                    .applyFont(.body_b_14)
                    .foregroundColor(Color.gray06)
                    .padding(.leading, 14)
                Spacer()
            }
            .frame(height: 44)
            .padding(.horizontal)
            .background(.black)
            .contentShape(Rectangle())
            .onTapGesture {
                selectCategory(category.name)
            }
        }
    }

    private func selectCategory(_ name: String) {
        viewModel.workSelectionData.selectedCategory = name
        viewModel.workSelectionData.customCategory = ""
        isTextFieldFocused = false
    }
}

// MARK: - CustomCategoryInputView
private struct CustomCategoryInputView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    @FocusState var isTextFieldFocused: Bool

    var body: some View {
        HStack {
            SelectionIndicator(isSelected: viewModel.workSelectionData.selectedCategory == "Other" || !viewModel.workSelectionData.customCategory.isEmpty)

            VStack(alignment: .leading, spacing: 0) {
                TextField(
                    viewModel.workSelectionData.customCategory.isEmpty ? "Other" : "",
                    text: $viewModel.workSelectionData.customCategory
                )
                .focused($isTextFieldFocused)
                .onChange(of: isTextFieldFocused) { newValue in
                    if newValue {
                        viewModel.workSelectionData.selectedCategory = "Other"
                    }
                }
                .foregroundColor((isTextFieldFocused || !viewModel.workSelectionData.customCategory.isEmpty) ? .white : .gray08)
                .applyFont(.body_b_14)
                .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 0))

                Rectangle()
                    .frame(width: 240, height: 1)
                    .foregroundColor((isTextFieldFocused || !viewModel.workSelectionData.customCategory.isEmpty) ? .white : Color.gray08)
                    .padding(.leading, 14)
                    .offset(y: -10)
            }

            Spacer()
        }
        .frame(height: 44)
        .padding(.horizontal)
        .background(.black)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.workSelectionData.selectedCategory = "Other"
            isTextFieldFocused = true
        }
    }
}

// MARK: - 선택 표시 뷰
private struct SelectionIndicator: View {
    var isSelected: Bool

    var body: some View {
        Image(isSelected ? .btn_check_selected_circle : .btn_check_unselected_circle)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundColor(isSelected ? .white : .gray)
    }
}

// MARK: - Next Button
private struct NextButton: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    var isEnabled: Bool

    var body: some View {
        Button {
            if isEnabled {
                viewModel.navigateToNext(.workPreference)
            }
        } label: {
            Text("Next")
                .applyFont(.body_b_16)
                .foregroundColor(isEnabled ? Color.black : Color.gray08)
                .padding(.vertical, 13)
                .frame(maxWidth: .infinity)
        }
        .background(isEnabled ? Color.mainGreen : Color.gray10)
        .frame(height: 50)
        .cornerRadius(2)
        .disabled(!isEnabled)
    }
}

#Preview {
    WorkSelectionView().environmentObject(OnboardingViewModel())
}
