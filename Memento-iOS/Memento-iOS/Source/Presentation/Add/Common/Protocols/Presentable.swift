//
//  Presentable.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import Foundation

protocol Presentable {
    var isPresented: Bool { get set }
    var isPressed: Bool { get set }

    func togglePresentation()
    func setPressedState(_ pressed: Bool)
    func dismiss()
}
