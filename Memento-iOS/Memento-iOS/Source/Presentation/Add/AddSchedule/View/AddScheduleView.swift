//
//  AddScheduleView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct AddScheduleView: View {

    // MARK: - Properties

    @StateObject private var titleViewModel = AddEventTitleViewModel()

    // MARK: - Body

    var body: some View {
        ZStack {
            Color.gray10.ignoresSafeArea()

            VStack {
                AddEventTitleView(viewModel: titleViewModel)
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview

#Preview {
    AddScheduleView()
}
