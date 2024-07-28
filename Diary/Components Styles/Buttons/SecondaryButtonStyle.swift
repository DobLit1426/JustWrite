//
//  DiaryAppButton.swift
//  Diary
//
//  Created by Dobromir Litvinov on 11.09.2023.
//

import Foundation
import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Group {
            configuration.label
                .padding(.all)
                .foregroundStyle(.white)
                .background(
                    Capsule()
                        .fill(Color.mint)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 3)
                )
        }
        .scaleEffect(configuration.isPressed ? 1.015 : 1)
        .animation(.linear(duration: 0.1), value: configuration.isPressed)
        .padding()
    }
    
}

#Preview {
    Button("Secondary button") { }
        .buttonStyle(SecondaryButtonStyle())
}
