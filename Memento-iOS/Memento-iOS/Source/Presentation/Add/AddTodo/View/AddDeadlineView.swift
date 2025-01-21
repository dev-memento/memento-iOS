//
//  AddDeadlineView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/21/25.
//

import SwiftUI

import MDSKit

struct AddDeadlineView: View {

    // MARK: - Properties

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddTodoPickerButtonViewModel
    @Binding var selectedDateText: String

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                BrainDumpBackgroundView()

                VStack {
                    HStack {
                        Text("Deadline")
                            .applyFont(.body_r_16)
                            .foregroundStyle(Color.gray05)

                        Spacer()

                        Button {
                            viewModel.isPresented.toggle()
                        } label: {
                            HStack {
                                Image(.ic_deadline)
                                    .foregroundStyle(Color.gray05)
                                Text(viewModel.formattedPickerTitle)
                                    .applyFont(.body_r_14)
                                    .foregroundStyle(Color.gray02)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(width: 200, height: 36)
                        .background(Color.gray09)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                        .sheet(isPresented: $viewModel.isPresented) {
                            viewModel.isPresented = false
                        } content: {
                            SheetContainer(type: .date) {
                                VStack {
                                    SheetHeaderView {
                                        viewModel.isPresented = false
                                        selectedDateText = viewModel.formattedPickerTitle
                                    }

                                    DatePicker(
                                        "",
                                        selection: $viewModel.selectedDate,
                                        displayedComponents: .date
                                    )
                                    .colorScheme(.dark)
                                    .datePickerStyle(.graphical)
                                    .frame(width: 320)
                                    .transition(.move(edge: .bottom))
                                    .tint(.mementoBlue)
                                }
                                .background(Color.gray09)
                            }
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(.btn_back)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        selectedDateText = viewModel.formattedPickerTitle
                    }) {
                        Text("Done")
                            .applyFont(.body_r_16)
                            .foregroundColor(.grayWhite)
                    }
                }
            }
        }
    }
}
