//
//  EditToDoView.swift
//  Memento-iOS
//
//  Created by 이세민 on 9/3/25.
//

import SwiftUI
import Combine
import MDSKit

struct EditToDoView: View {
    @StateObject private var viewModel: EditToDoViewModel
    
    @Binding var isEditViewPresented: Bool
    
    @State private var isStartDatePickerPresented = false
    @State private var isDeadlinePickerPresented = false
    @State private var isTagPickerPresented = false
    @State private var isPriorityPickerPresented = false
    
    @GestureState private var translation: CGFloat = .zero
    @FocusState private var isFocused: Bool
    @State private var sheetHeight: CGFloat = .zero
    @State private var keyboardHeight: CGFloat = 0
    
    init(isEditViewPresented: Binding<Bool>, toDoItem: ToDoItem) {
        self._isEditViewPresented = isEditViewPresented
        _viewModel = StateObject(wrappedValue: EditToDoViewModel(toDoItem: toDoItem))
    }
    
    var body: some View {
        GeometryReader { geometry in
            let calculatedSheetHeight = geometry.size.height * 0.8
            
            VStack {
                Spacer()
                
                VStack(spacing: 0) {
                    HStack {
                        Button { isEditViewPresented = false } label: {
                            Text("Cancel")
                                .applyFont(.body_r_16)
                                .foregroundStyle(Color.red)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        
                        Spacer()
                        
                        Button {
                            viewModel.updateToDo {
                                isEditViewPresented = false
                            }
                        } label: {
                            Text("Done")
                                .applyFont(.body_r_16)
                                .foregroundStyle(Color.white)
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .disabled(viewModel.description.isEmpty)
                        .opacity(viewModel.description.isEmpty ? 0.3 : 1.0)
                    }
                    .padding(.vertical, 6)
                    
                    VStack(alignment: .leading, spacing: 13) {
                        HStack(spacing: 5) {
                            Text("Edit to-do,")
                                .foregroundColor(.gray07)
                                .applyFont(.body_r_18)
                            
                            Button(Date.displayEndDate2(viewModel.startDate)) {
                                isStartDatePickerPresented = true
                            }
                            .foregroundColor(.gray04)
                            .applyFont(.body_r_18)
                            .sheet(isPresented: $isStartDatePickerPresented) {
                                PickerSheet(type: .addToDo(.date)) {
                                    SheetOKButton { isStartDatePickerPresented = false }
                                    DatePicker(
                                        "",
                                        selection: Binding(
                                            get: {
                                                Date.dateFromString(viewModel.startDate, format: "yyyy-MM-dd") ?? Date()
                                            },
                                            set: { viewModel.startDate = $0.stringFromDate(with: "yyyy-MM-dd") }
                                        ),
                                        displayedComponents: .date
                                    )
                                    .colorScheme(.dark)
                                    .datePickerStyle(.graphical)
                                    .tint(.mementoBlue)
                                    .padding([.horizontal, .bottom], 10)
                                }
                            }
                        }
                        
                        ScrollViewReader { proxy in
                            ScrollView {
                                TextField("", text: $viewModel.description, axis: .vertical)
                                    .applyFont(.body_b_16)
                                    .tint(.mainGreen)
                                    .padding(.bottom, keyboardHeight)
                                    .foregroundStyle(Color.grayWhite)
                                    .lineLimit(nil)
                                    .focused($isFocused)
                                    .autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never)
                                    .id("TextFieldBottomAnchor")
                                    .onAppear { isFocused = true }
                                    .onDisappear { isFocused = false }
                                    .onChange(of: viewModel.description) {
                                        scrollToBottom(proxy: proxy)
                                    }
                            }
                            .onReceive(Publishers.keyboardHeight) { height in
                                keyboardHeight = height + 30
                                scrollToBottom(proxy: proxy)
                            }
                        }
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                EditToDoToolbarView(
                                    viewModel: viewModel,
                                    isDeadlinePickerPresented: $isDeadlinePickerPresented,
                                    isTagPickerPresented: $isTagPickerPresented,
                                    isPriorityPickerPresented: $isPriorityPickerPresented
                                )
                            }
                        }
                    }
                    .padding(.top, 15)
                    .padding(.horizontal, 23)
                }
                .frame(height: calculatedSheetHeight)
                .background(Color.gray10)
                .gesture(
                    DragGesture()
                        .updating($translation) { value, state, _ in
                            if value.translation.height > 0 {
                                state = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > calculatedSheetHeight / 3 {
                                isEditViewPresented = false
                            }
                        }
                )
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .onAppear { sheetHeight = calculatedSheetHeight }
            .background(Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { isEditViewPresented = false })
            .transition(.move(edge: .bottom))
            .animation(.spring, value: isEditViewPresented)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool = true) {
        withAnimation(animated ? .easeOut(duration: 0.2) : nil) {
            proxy.scrollTo("TextFieldBottomAnchor", anchor: .bottom)
        }
    }
}


struct EditToDoToolbarView: View {
    @ObservedObject var viewModel: EditToDoViewModel
    
    @Binding var isDeadlinePickerPresented: Bool
    @Binding var isTagPickerPresented: Bool
    @Binding var isPriorityPickerPresented: Bool
    
    private let items: [Matrix] = [
        Matrix(title: "Important O\nUrgent O", priority: .immediate),
        Matrix(title: "Important O\nUrgent X", priority: .high),
        Matrix(title: "Important X\nUrgent O", priority: .medium),
        Matrix(title: "Important X\nUrgent X", priority: .low)
    ]
    
    private let gridItem = [GridItem(.fixed(146)), GridItem(.fixed(146))]
    
    var body: some View {
        HStack {
            
            // MARK: - Deadline
            
            Button(action: { isDeadlinePickerPresented = true }) {
                HStack {
                    Image(.ic_deadline)
                    Text(Date.displayEndDate2(viewModel.endDate))
                        .applyFont(.detail_r_12)
                }
                .foregroundStyle(Color.gray02)
            }
            .frame(width: 86, height: 41)
            .background(Color.gray09)
            .cornerRadius(2)
            .sheet(isPresented: $isDeadlinePickerPresented) {
                PickerSheet(type: .addToDo(.date)) {
                    VStack {
                        SheetOKButton { isDeadlinePickerPresented = false }
                        DatePicker(
                            "",
                            selection: Binding(
                                get: {
                                    Date.dateFromString(viewModel.endDate, format: "yyyy-MM-dd") ?? Date()
                                },
                                set: { viewModel.endDate = $0.stringFromDate(with: "yyyy-MM-dd") }
                            ),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.graphical)
                        .tint(.mementoBlue)
                        .padding([.horizontal, .bottom], 10)
                    }
                }
            }
            
            // MARK: - Tag
            
            Button(action: { isTagPickerPresented = true }) {
                Circle()
                    .fill(Color.fromHex(viewModel.tagColor))
                    .frame(width: 10, height: 10)
            }
            .frame(width: 42, height: 42)
            .background(Color.gray09)
            .cornerRadius(2)
            .sheet(isPresented: $isTagPickerPresented) {
                PickerSheet(type: .addToDo(.tag)) {
                    SheetOKButton { isTagPickerPresented = false }
                    List {
                        ForEach(viewModel.tagList) { tag in
                            Button(action: {
                                viewModel.tagName = tag.name
                                viewModel.tagColor = tag.color.toHex()
                            }) {
                                HStack {
                                    Circle()
                                        .fill(tag.color)
                                        .frame(width: 12, height: 12)
                                    Text(tag.name)
                                        .applyFont(.body_r_14)
                                        .foregroundStyle(viewModel.tagName == tag.name ? Color.gray02 : Color.gray07)
                                    Spacer()
                                }
                            }
                            .listRowBackground(viewModel.tagName == tag.name ? Color.gray08 : Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .ignoresSafeArea()
                    .padding([.horizontal, .bottom], 10)
                    .scrollDisabled(viewModel.tagList.count <= 3)
                }
                .applyDynamicSheetForTagCount(tagCount: viewModel.tagList.count)
            }
            
            // MARK: - Priority
            
            Button(action: { isPriorityPickerPresented = true }) {
                Image(viewModel.priorityType.imageName)
                    .frame(width: 26, height: 26)
                    .padding(8)
                    .background(Color.gray09)
                    .cornerRadius(2)
            }
            .frame(width: 42, height: 42)
            .sheet(isPresented: $isPriorityPickerPresented) {
                PickerSheet(type: .addToDo(.priority)) {
                    VStack {
                        HStack {
                            Button {
                                isPriorityPickerPresented = false
                            } label: {
                                Text("Cancel")
                                    .applyFont(.body_r_16)
                                    .foregroundStyle(Color.red)
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                            
                            Spacer()
                            
                            Button {
                                isPriorityPickerPresented = false
                            } label: {
                                Text("Done")
                                    .applyFont(.body_r_16)
                                    .foregroundStyle(Color.white)
                            }
                            .padding(.horizontal, 18)
                            .padding(.vertical, 12)
                        }
                        .padding(.vertical, 6)
                        
                        HStack {
                            Spacer()
                            
                            PriorityLabel(priority: viewModel.priorityType)
                        }
                        .padding(.top, 38)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        
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
                                HStack(spacing: -20) {
                                    Text("Importance")
                                        .foregroundColor(.gray04)
                                        .rotationEffect(.degrees(-90))
                                        .applyFont(.detail_r_12)
                                    Image(.ic_prio_arrow_h)
                                }
                                LazyVGrid(columns: gridItem, spacing: 8) {
                                    ForEach(items) { item in
                                        Button {
                                            if viewModel.priorityType == item.priority {
                                                viewModel.priorityType = .none
                                            } else {
                                                viewModel.priorityType = item.priority
                                            }
                                        } label: {
                                            ZStack {
                                                Rectangle()
                                                    .fill(item.priority == viewModel.priorityType ?
                                                          item.priority.backgroundColor : Color.gray09)
                                                    .frame(width: 146, height: 126)
                                                Text(item.title)
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
                        Text("Select an area,\nor let AI do it for you.")
                            .applyFont(.body_r_18)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray07)
                            .padding(.top, 18)
                        
                        Spacer()
                    }
                    .background(Color.gray10)
                }
            }
            
            Spacer()
        }
        .padding(.bottom, 20)
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.gray10.ignoresSafeArea(.all))
    }
}
