//
//  AlertOverlay.swift
//  Memento-iOS
//
//  Created by 이세민 on 8/23/25.
//

import SwiftUI

struct AlertOverlay<Content: View>: View {
    var isPresented: Bool
    var onDismiss: () -> Void
    var content: Content
    
    init(isPresented: Bool, onDismiss: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.isPresented = isPresented
        self.onDismiss = onDismiss
        self.content = content()
    }
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { onDismiss() }
                
                content
            }
        }
    }
}
