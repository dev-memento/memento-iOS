//
//  TagListView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/21/25.
//

import SwiftUI

import MDSKit

struct TagListView<ViewModel: BasePickerViewModel & TagSelectable>: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ViewModel

    // MARK: - Body

    var body: some View {
        // TODO: 다음 리팩토링 대상
        EmptyView()
    }
}
