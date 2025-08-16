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

extension Tag {

    static let mockData: [Tag] = [
        Tag(tagId: 1, color: .gray05, title: "Untitled"),
        Tag(tagId: 2, color: .mementoBlue, title: "Family"),
        Tag(tagId: 3, color: .mementoCyan, title: "School"),
        Tag(tagId: 4, color: .mementoMint, title: "Project"),
        Tag(tagId: 5, color: .mementoLightGreen, title: "Meeting"),
        Tag(tagId: 6, color: .mementoYellow, title: "Daily")
    ]
}
