//  EisenhowerMatrixView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/18/25.

import SwiftUI
import MDSKit

struct EisenhowerMatrixView: View {
    let source: String
    @Binding var externalPriority: Priority  // 외부에서 받는 Priority
    
    let items: [(String, Priority)] = [
        ("Important O\nUrgent O", .immediate),
        ("Important O\nUrgent X", .high),
        ("Important X\nUrgent O", .medium),
        ("Important X\nUrgent X", .low)
    ]
    
    @State private var selectedPriority: Priority
    @State private var priorities: [Priority]

    private let gridItem = [
        GridItem(.fixed(146)),
        GridItem(.fixed(146))
    ]

    init(source: String, externalPriority: Binding<Priority>) {
        self.source = source
        self._externalPriority = externalPriority
        self._selectedPriority = State(initialValue: externalPriority.wrappedValue)
        self._priorities = State(initialValue: [.immediate, .high, .medium, .low])
    }
    
    var body: some View {
        ZStack {
            Color.gray10
                .ignoresSafeArea()
            
            VStack {
                HeaderView()
                
                TodoItemView(priority: $selectedPriority)  // selectedPriority로 변경
                
                MatrixGridView(
                    priorities: $priorities,
                    selectedPriority: $selectedPriority,  // 선택된 Priority 전달
                    gridItem: gridItem,
                    items: items
                )
                .padding(.top, 12)
                
                FooterTextView()
                
                Spacer()
            }
        }
        .onChange(of: selectedPriority) { newValue in
            externalPriority = newValue  // 외부 Priority 업데이트
        }
        .onChange(of: externalPriority) { newValue in
            selectedPriority = newValue  // 외부 Priority 변경 시 내부 상태 업데이트
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
    @Binding var priority: Priority

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
            
            PriorityLabel(priority: priority)
            
            Spacer()
        }
    }
}

struct MatrixGridView: View {
    @Binding var priorities: [Priority]
    @Binding var selectedPriority: Priority
    let gridItem: [GridItem]
    let items: [(String, Priority)]

    var body: some View {
        VStack {
            Text("Urgency")
                .font(.caption)
                .foregroundColor(.gray04)
                .padding(.top, 16)
                .frame(maxWidth: .infinity, alignment: .center)
                .applyFont(.detail_r_12)
            
            HStack {
                Text("Importance")
                    .font(.caption)
                    .foregroundColor(.gray04)
                    .rotationEffect(.degrees(-90))
                    .frame(height: 200, alignment: .center)
                    .applyFont(.detail_r_12)
                
                LazyVGrid(columns: gridItem, spacing: 8) {
                    ForEach(priorities.indices, id: \.self) { index in
                        Button {
                            selectedPriority = items[index].1
                        } label: {
                            ZStack {
                                Rectangle()
                                    .fill(items[index].1 == selectedPriority ?
                                          items[index].1.backgroundColor : Color.gray09)  // 수정된 부분
                                    .frame(width: 146, height: 126)
                                Text(items[index].0)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.gray04)
                                    .applyFont(.detail_r_12)
                            }
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
    EisenhowerMatrixView(
        source: "SOPT",
        externalPriority: .constant(.immediate)  // .constant()를 사용하여 Binding 생성
    )
}
