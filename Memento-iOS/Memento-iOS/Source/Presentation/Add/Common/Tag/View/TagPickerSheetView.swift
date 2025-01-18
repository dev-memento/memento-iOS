//
//  TagPickerSheetView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct TagPickerSheetView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: PickerButtonViewModel
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
                HStack {
                    Spacer()
                    Button("OK") {
                        isPresented = false
                    }
                    .applyFont(.body_r_14)
                    .foregroundColor(Color.gray04)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .padding(.trailing, 22)
                }

                List {
                    ForEach(Tag.mockData) { tag in
                        Button(action: {
                            viewModel.selectedTag = tag
                        }) {
                            HStack {
                                Circle()
                                    .fill(tag.color)
                                    .frame(width: 12, height: 12)

                                Text(tag.title)
                                    .applyFont(.body_r_14)
                                    .foregroundColor(
                                        viewModel.selectedTag.id == tag.id
                                        ? .gray02
                                        : .gray07
                                    )

                                Spacer()
                            }
                        }
                        .listRowBackground(
                            viewModel.selectedTag.id == tag.id
                            ? Color.gray08
                            : Color.clear
                        )
                    }
                }
                .listStyle(PlainListStyle())
                .ignoresSafeArea()
                .padding([.horizontal, .bottom], 10)
                .scrollDisabled(Tag.mockData.count <= 4)
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

        TagPickerSheetView(viewModel: PickerButtonViewModel(type: .tag))
    }
}
