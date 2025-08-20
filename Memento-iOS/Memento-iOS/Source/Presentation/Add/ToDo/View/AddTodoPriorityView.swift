//  AddTodoPriorityView.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/18/25.

import SwiftUI
import MDSKit

struct AddTodoPriorityView: View {

    let items: [(String, Priority)] = [
        ("Important O\nUrgent O", .immediate),
        ("Important O\nUrgent X", .high),
        ("Important X\nUrgent O", .medium),
        ("Important X\nUrgent X", .low)
    ]
    let viewType: ViewType
    let source: String
    @ObservedObject var viewModel: AddToDoViewModel

    private let gridItem = [
        GridItem(.fixed(146)),
        GridItem(.fixed(146))
    ]

    var body: some View {
        ZStack {
            Color.gray10
                .ignoresSafeArea()

            VStack {
                HeaderView(viewType: viewType, onDone: {
                    viewModel.showPriorityPicker = false
                })

                TodoItemView(viewType: viewType, priority: $viewModel.selectedPriority)

                MatrixGridView(
                    selectedPriority: $viewModel.selectedPriority,
                    gridItem: gridItem,
                    items: items
                )
                .padding(.top, 12)

                FooterTextView()

                Spacer()
            }
        }
    }
}

struct HeaderView: View {

    let viewType: ViewType
    let onDone: () -> Void
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack {
            switch viewType {
            case .add:
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(.btn_back)
                }
            case .edit:
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .applyFont(.body_r_16)
                        .foregroundStyle(Color.red)
                }
                .frame(width: 84, height: 48)
            }

            Spacer()

            Button {
                onDone()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Done")
                    .applyFont(.body_r_16)
                    .foregroundStyle(Color.white)
            }
            .frame(width: 74, height: 48)
        }
        .frame(height: 60)
    }
}

struct TodoItemView: View {

    let viewType: ViewType
    @Binding var priority: Priority

    var body: some View {
        switch viewType {
        case .add:
            HStack {
                Spacer()
                PriorityLabel(priority: priority)
            }
            .padding(.horizontal)
        case .edit:
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
                    Text("UXUI 과제 피그마 어디어디페이지에 몇시까지 제출하고 카톡으로")
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .applyFont(.body_b_16)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: 212, alignment: .leading)

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
                            Text(StringLiteral.Common.tag)
                                .applyFont(.detail_r_12)
                                .foregroundColor(.gray05)
                                .padding(.trailing, 54)

                            HStack(spacing: 3) {
                                Image(.ic_tag)
                                    .resizable()
                                    .scaledToFit()
                                    .colorMultiply(Color.blue)
                                    .frame(width: 17, height: 17)

                                Text("SOPT")
                                    .applyFont(.detail_r_12)
                                    .foregroundColor(.grayWhite)
                            }
                        }
                    }
                }
                .frame(width: 212)
                .frame(minHeight: 76)
                .padding(.horizontal, 10)

                Spacer()

                PriorityLabel(priority: priority)

                Spacer()
            }
        }
    }
}

struct MatrixGridView: View {
    @Binding var selectedPriority: Priority
    let gridItem: [GridItem]
    let items: [(String, Priority)]

    var body: some View {
        VStack(alignment: .leading){
            VStack(spacing: 1){
                Text("Urgency")
                    .foregroundColor(.gray04)
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .applyFont(.detail_r_12)

                Image(.ic_prio_arrow_v)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 12)
            }
            HStack() {

                HStack(spacing: -19){
                    Text("Importance")
                        .foregroundColor(.gray04)
                        .rotationEffect(.degrees(-90))
                        .applyFont(.detail_r_12)

                    Image(.ic_prio_arrow_h)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 260)
                }
                LazyVGrid(columns: gridItem, spacing: 8) {
                    ForEach(items.indices, id: \.self) { index in
                        Button {
                            selectedPriority = items[index].1
                        } label: {
                            ZStack {
                                Rectangle()
                                    .fill(items[index].1 == selectedPriority ?
                                          items[index].1.backgroundColor : Color.gray09)
                                    .frame(width: 146, height: 126)
                                Text(items[index].0)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.gray04)
                                    .applyFont(.detail_r_12)
                            }
                        }
                    }
                }
                Spacer()
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
