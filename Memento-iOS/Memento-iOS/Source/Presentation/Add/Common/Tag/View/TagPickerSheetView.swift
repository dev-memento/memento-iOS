//
//  TagPickerSheetView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct TagPickerSheetView<ViewModel: BasePickerViewModel & TagSelectable>: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel
    @State private var isPresented: Bool = false
    @State private var isPressed: Bool = false

    // MARK: - Body

    var body: some View {
        Button {
            isPresented.toggle()
            isPressed = true
        } label: {
            HStack(spacing: 5) {
                Circle()
                    .fill(viewModel.selectedTag.color)
                    .frame(width: 14, height: 14)

                Text(
                    viewModel.selectedTag.title.isEmpty
                    ? "Untitled"
                    : viewModel.selectedTag.title
                )
                .applyFont(.body_r_14)
                .foregroundColor(.gray02)
            }
            .frame(width: 200, height: 36)
            .background(isPressed ? Color.gray07 : Color.gray09)
            .cornerRadius(2)
        }
        .sheet(isPresented: $isPresented, onDismiss: {
            isPressed = false
        }) {
            VStack {
                SheetHeaderView { isPresented = false }
                TagListView(viewModel: viewModel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray09)
            .presentationCornerRadius(0)
            .presentationDragIndicator(.hidden)
            .applyDynamicSheetForTagCount()
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.gray10
            .ignoresSafeArea()

        TagPickerSheetView(viewModel: AddSchedulePickerButtonViewModel(type: .tag))
    }
}
