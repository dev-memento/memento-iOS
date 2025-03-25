//
//  CustomToggleStyle.swift
//  Memento-iOS
//
//  Created by RAFA on 3/25/25.
//

import SwiftUI

import MDSKit

struct CustomToggleStyle: ToggleStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            RoundedRectangle(cornerRadius: 12)
                .fill(configuration.isOn ? Color.mainGreen : Color.gray08)
                .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                .frame(width: 40, height: 24)
                .overlay(
                    Circle()
                        .fill(Color.gray02)
                        .frame(width: 20, height: 20)
                        .offset(x: configuration.isOn ? 8 : -8)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
