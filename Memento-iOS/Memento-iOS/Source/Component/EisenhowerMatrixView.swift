//  EisenhowerMatrixView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/18/25.

import SwiftUI
import MDSKit

struct EisenhowerMatrixView: View {
    let source: String
    
    let items = [
        ("Important O\nUrgent O", Color.red),
        ("Important O\nUrgent X", Color.gray09),
        ("Important X\nUrgent O", Color.gray09),
        ("Important X\nUrgent X", Color.gray09)
    ]
    
    private let gridItem = [
        GridItem(.fixed(146)),
        GridItem(.fixed(146))
    ]
    
    var body: some View {
        ZStack {
            Color.gray10
                .ignoresSafeArea()
            
            VStack {
                HeaderView()
                
                TodoItemView()
                
                MatrixGridView(items: items, gridItem: gridItem)
                .padding(.top, 12)
                
                FooterTextView()
                
                Spacer()
                
            }
        }
    }
}

struct HeaderView: View {
    var body: some View {
        HStack {
            Button {
                // Action
            } label: {
                Text("Cancel")
                    .applyFont(.body_r_16)
                    .foregroundStyle(Color.red)
            }
            .frame(width: 84, height: 48)
            
            Spacer()
            
            Button {
                // Action
            } label: {
                Text("Done")
                    .applyFont(.body_r_16)
                    .foregroundStyle(Color.white)
            }
            .frame(width: 74, height: 48)
        }
        .frame(height: 48)
    }
}

struct TodoItemView: View {
    var body: some View {
        HStack(alignment: .top) {
            Button {
                // Action
            } label: {
                Image(.ic_checkbox)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            .padding(.leading, 24)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("UXUI 과제")
                    .applyFont(.body_b_16)
                    .foregroundStyle(Color.white)
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 13) {
                        Text("Deadline")
                            .applyFont(.detail_r_12)
                            .foregroundColor(.gray05)
                            .padding(.trailing, 54)
                        
                        HStack(spacing: 3) {
                            Image(.ic_deadline)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 17, height: 17)
                            Text("Today")
                                .applyFont(.detail_r_12)
                                .foregroundColor(.grayWhite)
                        }
                    }
                    
                    HStack(spacing: 40) {
                        Text(StringLiteral.Alert.tag)
                            .applyFont(.detail_r_12)
                            .foregroundColor(.gray05)
                            .padding(.trailing, 54)
                        
                        HStack(spacing: 3) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 10, height: 10)
                            Text("SOPT")
                                .applyFont(.detail_r_12)
                                .foregroundColor(.grayWhite)
                        }
                    }
                }
            }
            .frame(width: 212, height: 76)
            .padding(.horizontal, 10)
            Spacer()
            
            PriorityLabel(priority: .immediate)
            
            Spacer()
        }
    }
}


struct MatrixGridView: View {
    let items: [(String, Color)]
    let gridItem: [GridItem]
    
    var body: some View {
        VStack{
            // Axis Labels
            Text("Urgency")
                .font(.caption)
                .foregroundColor(.gray04)
                .frame(maxWidth: .infinity, alignment: .center)
                .applyFont(.detail_r_12)
            
            HStack {
                Text("Importance")
                    .font(.caption)
                    .foregroundColor(.gray04)
                    .rotationEffect(.degrees(-90))
                    .frame(height: 200, alignment: .center)
                    .applyFont(.detail_r_12)
                
                // Grid Layout
                LazyVGrid(columns: gridItem, spacing: 8) { // 행 간격도 8로 설정
                    ForEach(items, id: \.0) { item in
                        ZStack {
                            Rectangle()
                                .fill(item.1)
                                .frame(width: 146, height: 126)
                            Text(item.0)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray04)
                                .font(.body)
                        }
                    }
                }
            }
        }
    }
}

struct FooterTextView: View {
    var body: some View {
        Text("Select an area,\nor let AI do it for you.")
            .applyFont(.body_r_18)
            .multilineTextAlignment(.center)
            .foregroundColor(.gray07)
            .padding(.top, 18)
    }
}
#Preview {
    EisenhowerMatrixView(source: "SOPT")
}
