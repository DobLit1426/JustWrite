//
//  MoodGaug.swift
//  Diary
//
//  Created by Dobromir Litvinov on 22.11.2023.
//

import SwiftUI

struct MoodGauge: View {
    let mood: Double
    
    init(mood: Int) {
        self.mood = Double(mood)
    }
    
    var foregroundColor: Color {
        if mood > 0 {
            return Color.init(red: 0, green: Double(mood) / Double(1) + 0.3, blue: 0)
        } else if mood == 0 {
            return Color.black
        } else {
            return Color.init(red: Double(mood) / Double(-1) + 0.3, green: 0, blue: 0)
        }
    }
    
    var body: some View {
        Gauge(value: mood, in: -10...10) {
            EmptyView()
        } currentValueLabel: {
            Text(round(mood), format: .number)
                .foregroundStyle(foregroundColor)
        } minimumValueLabel: {
            Text("-10")
                .foregroundStyle(.red)
        } maximumValueLabel: {
            Text("10")
                .foregroundStyle(.green)
        }
        .gaugeStyle(.accessoryCircular)
//        .animation(.spring(.bouncy), value: foregroundColor)
//        .scaleEffect(CGSize(width: 0.5, height: 0.5))

    }
}

#Preview {
    MoodGauge(mood: -3)
}
