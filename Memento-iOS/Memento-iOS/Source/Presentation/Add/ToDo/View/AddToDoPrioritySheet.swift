//
//  AddToDoPrioritySheet.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/18/25.
//

import SwiftUI

import MDSKit

struct AddToDoPrioritySheet: View {
    
    @ObservedObject var viewModel: AddToDoViewModel
    
    let viewType: ViewType
    
    var body: some View {
        ZStack {
            Color.gray10
                .ignoresSafeArea()
            
            VStack {
                HeaderView(
                    viewType: viewType,
                    onDone: {
                        viewModel.isPriorityPickerPresented = false
                    })
                
                PriorityView(priority: $viewModel.selectedPriority)
                
                MatrixGridView(selectedPriority: $viewModel.selectedPriority)
                
                FooterTextView()
                
                Spacer()
            }
        }
    }
}

struct HeaderView: View {
    
    let viewType: ViewType
    let onDone: () -> Void
    
    var body: some View {
        HStack {
            switch viewType {
            case .add:
                Button {
                    onDone()
                } label: {
                    Image(.btn_back)
                }
            case .edit:
                Button {
                    onDone()
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
            } label: {
                Text("Done")
                    .applyFont(.body_r_16)
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
        }
        .frame(height: 60)
    }
}

struct PriorityView: View {
    
    @Binding var priority: Priority
    
    var body: some View {
        HStack {
            Spacer()
            PriorityLabel(priority: priority)
        }
        .padding(.top, 38)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct MatrixGridView: View {
    
    @Binding var selectedPriority: Priority
    
    let items: [(String, Priority)] = [
        ("Important O\nUrgent O", .immediate),
        ("Important O\nUrgent X", .high),
        ("Important X\nUrgent O", .medium),
        ("Important X\nUrgent X", .low)
    ]
    
    private let gridItem = [
        GridItem(.fixed(146)),
        GridItem(.fixed(146))
    ]
    
    var body: some View {
        VStack(spacing: 6) {
            VStack(alignment: .leading, spacing: 1) {
                Text("Urgency")
                    .foregroundColor(.gray04)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .applyFont(.detail_r_12)
                
                Image(.ic_prio_arrow_v)
                    .padding(.leading, 56)
                    .padding(.trailing, 20)
            }
            
            HStack(spacing: 6) {
                HStack(spacing: -20){
                    Text("Importance")
                        .foregroundColor(.gray04)
                        .rotationEffect(.degrees(-90))
                        .applyFont(.detail_r_12)
                    
                    Image(.ic_prio_arrow_h)
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
