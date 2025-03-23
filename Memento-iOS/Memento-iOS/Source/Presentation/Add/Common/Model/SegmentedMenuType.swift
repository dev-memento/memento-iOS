//
//  SegmentedMenuType.swift
//  Memento-iOS
//
//  Created by RAFA on 1/17/25.
//

import Foundation

import MDSKit

enum SegmentedMenuType: CaseIterable {
    case checkbox, event, brain

    var image: MDSImageName {
        switch self {
        case .checkbox: return .ic_checkbox
        case .event: return .ic_event
        case .brain: return .ic_brain
        }
    }
}
