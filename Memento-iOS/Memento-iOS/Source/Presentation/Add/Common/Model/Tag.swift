//
//  Tag.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct Tag: Equatable, Identifiable {
    let id: UUID
    let tagId: Int
    var color: Color
    var title: String

    init(id: UUID = UUID(), tagId: Int, color: Color, title: String) {
        self.id = id
        self.tagId = tagId
        self.color = color
        self.title = title
    }
}
