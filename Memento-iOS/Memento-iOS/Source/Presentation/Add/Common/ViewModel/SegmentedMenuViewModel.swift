//
//  SegmentedMenuViewModel.swift
//  Memento-iOS
//
//  Created by RAFA on 1/17/25.
//

import SwiftUI

final class SegmentedMenuViewModel: ObservableObject {

    @Published var isPresented: Bool = false
    @Published var selectedMenu: SegmentedMenuType = .checkbox
    
}
