//
//  MoodIndicatorsPreview.swift
//  Diary
//
//  Created by Dobromir Litvinov on 22.11.2023.
//

import SwiftUI

fileprivate struct MoodIndicatorsPreview: View {
    @State var mood: Double = 0
    let coveredRadius: Int = 220
    let maxValue: Int = 10
    
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Spacer()
                MoodSpeedometer(value: mood)
                Spacer()
                MoodGauge(mood: 0)
                Spacer()
                MoodGauge(mood: 1)
                Spacer()
            }
            MoodGauge(mood: Int(mood))
            Spacer()
            Slider(value: $mood, in: -10...10)
        }
        .padding()
    }
}

#Preview {
    MoodIndicatorsPreview()
}
