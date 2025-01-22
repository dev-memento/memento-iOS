//
//  TagSelectable.swift
//  Memento-iOS
//
//  Created by RAFA on 1/22/25.
//

import Foundation

protocol TagSelectable {
    var selectedTag: Tag { get set }
    func updateSelectedTag(_ tag: Tag)
}
