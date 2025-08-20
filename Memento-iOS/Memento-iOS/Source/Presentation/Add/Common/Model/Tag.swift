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
    var name: String
    var color: Color
    
    init(id: UUID = UUID(), tagId: Int, name: String, color: Color) {
        self.id = id
        self.tagId = tagId
        self.name = name
        self.color = color
    }
}
