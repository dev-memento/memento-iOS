//
//  WorkSelectionView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import SwiftUI

struct WorkSelectionView: View {
    // 선택된 카테고리
    @State private var selectedCategory: String? = nil
    // 사용자 정의 카테고리
    @State private var customCategory: String = ""
    // TextField 포커스 상태 관리
    @FocusState private var isTextFieldFocused: Bool
    
    @Binding var path: [String] // Navigation 경로를 관리하는 바인딩 변수

    // Next 버튼 활성화 조건
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
                .background(Color.black)
                
                NextButton(isEnabled: isNextButtonEnabled)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
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
                path.removeLast() // 이전 화면으로 이동
            } label: {
                Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 7.5, height: 16.5)
                    .foregroundColor(Color("gray06"))
            }
            
            Spacer()
            
            Button {
                path.append("WorkSelectionView") // 다음 화면으로 이동
            } label: {
                Text("Skip")
                    .font(.system(size: 14))
                    .foregroundColor(Color("gray06"))
            }
        }
    }
}

// MARK: - Header and Title View
private struct HeaderTitleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("2")
                .font(.system(size: 40))
                .foregroundColor(Color("gray07"))
            
            Text("What do you do for work?")
                .font(.system(size: 24))
                .foregroundColor(Color.white)
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
                    .foregroundColor(Color("gray06"))
                    .font(.system(size: 14))
                    .padding(.leading, 14)
                Spacer()
            }
            .frame(height: 44)
            .padding(.horizontal)
            .background(Color.black)
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
                .foregroundColor((isTextFieldFocused || !customCategory.isEmpty) ? .white : Color("gray08"))
                .font(.system(size: 14))
                .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 0))

                Rectangle()
                    .frame(width: 240, height: 1)
                    .foregroundColor((isTextFieldFocused || !customCategory.isEmpty) ? .white : Color("gray08"))
                    .padding(.leading, 14)
                    .offset(y: -10)
            }

            Spacer()
        }
        .frame(height: 44)
        .padding(.horizontal)
        .background(Color.black)
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
        Image(isSelected ? "check_selected" : "check_unselected")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
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
                .font(.system(size: 16))
                .foregroundColor(isEnabled ? .black : Color("gray08"))
                .padding(.vertical, 13)
                .frame(maxWidth: .infinity)
        }
        .background(isEnabled ? Color.green : Color("gray10"))
        .cornerRadius(2)
        .disabled(!isEnabled)
    }
}

#Preview {
    WorkSelectionView(path: .constant([]))
}
