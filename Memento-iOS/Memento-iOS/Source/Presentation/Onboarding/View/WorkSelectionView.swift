//
//  WorkSelectionView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import SwiftUI
import MDSKit

struct WorkSelectionView: View {
  
    @State private var selectedCategory: String? = nil
    @State private var customCategory: String = ""
    // TextField 포커스 상태 관리
    @FocusState private var isTextFieldFocused: Bool
    @Binding var path: [String]
    
    private var isNextButtonEnabled: Bool {
        (selectedCategory != nil && selectedCategory != "Other") || !customCategory.isEmpty
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(alignment: .leading) {
                CustomNavigationBar(path: $path)
                    .padding(.horizontal)
                    .padding(.top, 16)
                
                StepProgressBar(currentStep: 2, totalSteps: 4)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                
                HeaderTitleView()
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 0) {
                        CategoryListView(
                            selectedCategory: $selectedCategory,
                            customCategory: $customCategory,
                            isTextFieldFocused: _isTextFieldFocused
                        )
                        
                        CustomCategoryInputView(
                            selectedCategory: $selectedCategory,
                            customCategory: $customCategory,
                            isTextFieldFocused: _isTextFieldFocused
                        )
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

// MARK: - CustomNavigationBar
private struct CustomNavigationBar: View {
    @Binding var path: [String]

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
                path.append("WorkSelectionView") 
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
    @Binding var selectedCategory: String?
    @Binding var customCategory: String
    @FocusState var isTextFieldFocused: Bool

    var body: some View {
        ForEach(Category.mockData) { category in
            HStack {
                SelectionIndicator(isSelected: selectedCategory == category.name)
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
        selectedCategory = name
        customCategory = ""
        isTextFieldFocused = false
    }
}

// MARK: - CustomCategoryInputView
private struct CustomCategoryInputView: View {
    @Binding var selectedCategory: String?
    @Binding var customCategory: String
    @FocusState var isTextFieldFocused: Bool

    var body: some View {
        HStack {
            SelectionIndicator(isSelected: selectedCategory == "Other" || !customCategory.isEmpty)

            VStack(alignment: .leading, spacing: 0) {
                TextField(
                    customCategory.isEmpty ? "Other" : "",
                    text: $customCategory
                )
                .focused($isTextFieldFocused) // FocusState 바인딩
                .onChange(of: isTextFieldFocused) { newValue in
                    if newValue {
                        selectedCategory = "Other"
                    }
                }
                .foregroundColor((isTextFieldFocused || !customCategory.isEmpty) ? .white : .gray08)
                .applyFont(.body_b_14)
                .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 0))

                Rectangle()
                    .frame(width: 240, height: 1)
                    .foregroundColor((isTextFieldFocused || !customCategory.isEmpty) ? .white : Color.gray08)
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
            selectedCategory = "Other"
            isTextFieldFocused = true
        }
    }
}

// MARK: - 선택 표시 뷰
private struct SelectionIndicator: View {
    var isSelected: Bool

    var body: some View {
        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundColor(isSelected ? .white : .gray) // 색상 선택
    }
}

// MARK: - Next Button
private struct NextButton: View {
    var isEnabled: Bool

    var body: some View {
        Button {
            if isEnabled {
                // Next action
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
    WorkSelectionView(path: .constant([]))
}
