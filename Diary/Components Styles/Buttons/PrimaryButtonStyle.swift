//
//  PrimaryButtonStyle.swift
//  Diary
//
//  Created by Dobromir Litvinov on 25.10.2023.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Group {
            configuration.label
                .padding(.all)
                .foregroundStyle(.white)
                .bold()
                .background(
                    Capsule()
                        .fill(Color.blue)
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
    Button("Authenticate really long text ") { }
        .buttonStyle(PrimaryButtonStyle())
}
