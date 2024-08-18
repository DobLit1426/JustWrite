//
//  MoodGauge.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.11.2023.
//

import SwiftUI

struct MoodSpeedometer: View {
    private let coveredRadius: Double = 220
    private let maxValue: Int = 10
    private let minValue: Int = -10
    private let steperSplit: Int = 2
    
    let value: Int
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let tickCount: Int
    private let numberOfTicks: Int
    
    init(value: Double?) {
        self.value = value == nil ? 0 : Int((10 * value!).rounded())
        self.tickCount = (abs(maxValue) + abs(minValue)) / steperSplit
        self.numberOfTicks = tickCount * 2 + 1
    }
    
    var ticks: some View {
        ForEach(0..<numberOfTicks, id: \.description) { tick in
            self.tick(at: tick,
                      totalTicks: tickCount*2, value: tick - abs(minValue))
        }
    }
    
    var body: some View {
        ZStack {
            Text("\(value)")
                .font(.system(size: 40, weight: Font.Weight.bold))
                .foregroundStyle(color(for: Int(value)))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 4)
                        .frame(width: 100, height: 50)
                    
                }
                .offset(x: 0, y: 50)
            
            ticks
            
            ForEach(0..<numberOfTicks, id: \.description) { tick in
                if tick % 2 == 0 {
                    self.tickText(at: tick / 2, value: tick - abs(minValue))
                }
            }
            
            Needle()
                .frame(width: 140, height: 6)
                .minimumScaleFactor(1)
                .offset(x: -70, y: 0)
                .rotationEffect(.init(degrees: getAngle(value: Double(value))), anchor: .center)
                .animation(.easeInOut, value: value)
            
            Circle()
                .frame(width: 20, height: 20)
        }
        .frame(width: 300, height: 300, alignment: .center)
        .padding()
        .overlay {
            Circle()
                .stroke(lineWidth: 5)
        }
    }
    
    private func getAngle(value: Double) -> Double {
        return (value/Double(abs(minValue) + abs(maxValue)) + 0.5) * coveredRadius - coveredRadius / 2 + 90
    }
    
    private func color(for mood: Int) -> Color {
        if mood > 0 {
            if Double(mood) / Double(maxValue) + 0.4 > 0.7 {
                return Color.init(red: 0, green: 0.7, blue: 0)
            } else {
                return Color.init(red: 0, green: Double(mood) / Double(maxValue) + 0.4, blue: 0)
            }
        } else if mood == 0 {
            return colorScheme == .light ? Color.black : Color.gray
        } else {
            return Color.init(red: Double(mood) / Double(minValue) + 0.4, green: 0, blue: 0)
        }
    }
    
    private func tick(at tick: Int, totalTicks: Int, value: Int) -> some View {
        let startAngle = coveredRadius / 2 * -1
        let stepper = coveredRadius / Double(totalTicks)
        let rotation = Angle.degrees(startAngle + stepper * Double(tick))
        let color = color(for: value)
        let width: CGFloat = tick % 2 == 0 ? 5 : 3
        let height: CGFloat = tick % 2 == 0 ? 20 : 10
        
        return VStack {
            Rectangle()
                .foregroundColor(color)
                .frame(width: width, height: height)
            Spacer()
        }
        .rotationEffect(rotation)
    }
    
    private func tickText(at tick: Int, value: Int) -> some View {
        let startAngle = coveredRadius / 2 * (-1) + 90
        let stepper = coveredRadius / Double(tickCount)
        let rotation = startAngle + stepper * Double(tick)
        return Group {
            Text("\(value)")
                .foregroundColor(color(for: value))
                .rotationEffect(.init(degrees: -1 * rotation), anchor: .center)
                .offset(x: -115, y: 0)
                .rotationEffect(Angle.degrees(rotation))
        }
    }
}
