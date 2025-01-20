//
//  DropViewDelegate.swift
//  Memento-iOS
//
//  Created by 이세민 on 1/18/25.
//

import SwiftUI

struct DropViewDelegate<Item>: DropDelegate where Item: Identifiable {
    @Binding var item: Item
    @Binding var draggedItem: Item?
    
    let onDrop: (Item?, Item) -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        draggedItem = nil
        
        return true
    }
    
    func dropEntered(info: DropInfo) {
        onDrop(draggedItem, item)
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }
    
    func dropExited(info: DropInfo) {
        print("dropExited")
    }
    
}
