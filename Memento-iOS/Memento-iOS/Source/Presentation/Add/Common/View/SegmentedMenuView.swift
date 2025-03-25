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

    @ObservedObject private var viewModel: SegmentedMenuViewModel
    @Binding var sheetHeight: CGFloat

    // MARK: - Initializer

    init(viewModel: SegmentedMenuViewModel, sheetHeight: Binding<CGFloat>) {
        self.viewModel = viewModel
        self._sheetHeight = sheetHeight
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            let calculatedSheetHeight = screenHeight * 0.8

            VStack {
                Spacer()
                VStack {
                    menuButtonsView
                    contentView
                }
                .frame(maxWidth: .infinity)
                .frame(height: calculatedSheetHeight)
                .background(Color.gray10)
                .transition(.move(edge: .bottom))
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .onAppear { sheetHeight = calculatedSheetHeight }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// MARK: - UI Components

private extension SegmentedMenuView {

    // MARK: Menu Buttons

    var menuButtonsView: some View {
        HStack {
            ForEach(SegmentedMenuType.allCases, id: \.self) { type in
                configureMenuButton(type: type)
            }
        }
        .background(
            Color.gray09
                .clipShape(Capsule())
                .frame(width: 90, height: 48)
        )
        .padding(.top, 20)
        .padding(.bottom, 10)
    }

    @ViewBuilder
    func configureMenuButton(type: SegmentedMenuType) -> some View {
        Button {
            viewModel.selectButton(type)
        } label: {
            ZStack {
                if viewModel.selectedButton == type {
                    Circle()
                        .fill(viewModel.selectedButton == type ? Color.grayBlack : Color.clear)
                }

                Image(type.image)
                    .renderingMode(.template)
                    .foregroundColor(viewModel.selectedButton == type ? .grayWhite : .gray07)
            }
            .frame(width: 38, height: 38)
        }
    }

    // MARK: Content View

    @ViewBuilder
    var contentView: some View {
        switch viewModel.selectedButton {
        case .checkbox: AddTodoView()
        case .event: AddScheduleView()
        }
    }
}
