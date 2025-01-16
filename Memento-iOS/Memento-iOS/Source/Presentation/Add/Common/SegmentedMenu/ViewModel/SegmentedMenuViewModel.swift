//
//  SegmentedMenuViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/17/25.
//

import SwiftUI

final class SegmentedMenuViewModel: ObservableObject {

    @Published var selectedButton: SegmentedMenuType = .checkbox
    @Published var isShowing: Bool = false
    @Published var isRepeat: Bool = false

    func selectButton(_ type: SegmentedMenuType) {
        selectedButton = type
    }
}
