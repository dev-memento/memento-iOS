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
        print("performDrop")
        DispatchQueue.main.async {
                    draggedItem = nil // 상태를 즉시 해제
                }
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem else { return }
       
            onDrop(draggedItem, item)
      
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return nil
    }
    
    func dropExited(info: DropInfo) {
        print("dropExited")
    }
    
}
