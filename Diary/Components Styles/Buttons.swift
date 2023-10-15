//
//  DiaryAppButton.swift
//  Diary
//
//  Created by Dobromir Litvinov on 11.09.2023.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule(style: .continuous))
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .animation(.linear(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule(style: .continuous))
            .scaleEffect(configuration.isPressed ? 1.05 : 1)
            .animation(.linear(duration: 0.1), value: configuration.isPressed)
    }
}
