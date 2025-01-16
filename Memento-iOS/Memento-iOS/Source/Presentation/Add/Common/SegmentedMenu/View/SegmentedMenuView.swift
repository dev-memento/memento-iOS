//
//  SegmentedMenuView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/17/25.
//

import SwiftUI

import MDSKit

struct SegmentedMenuView: View {

    // MARK: - Properties

    @StateObject private var viewModel = SegmentedMenuViewModel()

    // MARK: - Body

    var body: some View {
        VStack {
            menuButtonsView
        }
    }
}

// MARK: - UI Components

private extension SegmentedMenuView {

    // MARK: Menu Buttons

    var menuButtonsView: some View {
        HStack(spacing: 5) {
            ForEach(SegmentedMenuType.allCases, id: \.self) { type in
                configureMenuButton(type: type)
            }
        }
        .background(
            Color.gray09
                .clipShape(Capsule())
                .frame(width: 125, height: 45)
        )
        .padding(.bottom, 5)
    }

    @ViewBuilder
    func configureMenuButton(type: SegmentedMenuType) -> some View {
        Button {
            viewModel.selectButton(type)
        } label: {
            ZStack {
                if viewModel.selectedButton == type {
                    Circle()
                        .fill(
                            viewModel.selectedButton == type
                            ? Color.grayBlack
                            : Color.clear
                        )
                }

                Image(type.image)
                    .renderingMode(.template)
                    .foregroundColor(
                        viewModel.selectedButton == type
                        ? .grayWhite
                        : .gray07
                    )
            }
            .frame(width: 36, height: 36)
        }
    }

    // MARK: Content View

    @ViewBuilder
    var contentView: some View {
        switch viewModel.selectedButton {
        case .checkbox:
            EmptyView()
        case .event:
            EmptyView()
        case .brain:
            EmptyView()
        }
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.gray10
            .ignoresSafeArea()

        VStack {
            SegmentedMenuView()

            Spacer()
        }
        .padding()
    }
}
