//
//  SegmentedMenuView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/17/25.
//

import SwiftUI

import MDSKit

struct SegmentedMenuView: View {
    
    @ObservedObject var viewModel: SegmentedMenuViewModel
    
    @Binding var sheetHeight: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let calculatedSheetHeight = geometry.size.height * 0.8
            
            VStack {
                Spacer()
                
                VStack {
                    menuButtonsView
                    
                    contentView
                }
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

extension SegmentedMenuView {
    var menuButtonsView: some View {
        HStack(spacing: 0) {
            ForEach(SegmentedMenuType.allCases, id: \.self) { type in
                let isSelectedMenu = (viewModel.selectedMenu == type)
                
                Button {
                    viewModel.selectedMenu = type
                } label: {
                    ZStack {
                        Circle()
                            .fill(isSelectedMenu ? Color.grayBlack : Color.clear)
                        
                        Image(type.image)
                            .renderingMode(.template)
                            .foregroundColor(isSelectedMenu ? .grayWhite : .gray07)
                    }
                    .frame(width: 38, height: 38)
                }
            }
        }
        .padding(3)
        .background(
            Color.gray09
                .clipShape(Capsule())
                .frame(height: 44)
        )
        .padding(.vertical, 13)
    }
    
    @ViewBuilder
    var contentView: some View {
        switch viewModel.selectedMenu {
        case .checkbox:
            AddToDoView(isAddViewPresented: $viewModel.isPresented)
        case .event:
            AddScheduleView(isAddViewPresented: $viewModel.isPresented)
        }
    }
}
