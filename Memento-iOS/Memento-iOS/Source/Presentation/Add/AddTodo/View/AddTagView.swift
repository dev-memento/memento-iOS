//
//  AddTagView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/22/25.
//

import SwiftUI

import MDSKit

struct AddTagView<ViewModel: BasePickerViewModel & TagSelectable>: View {

    // MARK: - Properties

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                BrainDumpBackgroundView()

                VStack {
                    TagView(viewModel: viewModel)
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
