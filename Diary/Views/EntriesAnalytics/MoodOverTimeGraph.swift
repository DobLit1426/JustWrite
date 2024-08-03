//
//  MoodOverTimeGraph.swift
//  Diary
//
//  Created by Dobromir Litvinov on 28.07.24.
//

import SwiftUI
import Charts

struct MoodOverTimeGraph: View {
    // MARK: - Constants
    let data: [(Date, Double)]
    let averageMood: Double
    
    // MARK: - Init
    init(dateToAverageMoodOfDate: [(Date, Double)]) {
        self.data = MoodOverTimeGraph.makeDataUnique(dateToAverageMoodOfDate).sorted(by: { tuple1, tuple2 in
            tuple1.0 < tuple2.0
        })
        
        let summedMoods: Double = data.map { $1 } .reduce(0.0, +)
        self.averageMood = summedMoods / Double(data.count)
    }
    
    // MARK: - Body
    var body: some View {
        Chart {
            ForEach(data, id: \.0) { date, mood in
                // Point to connect lines
                LineMark(x: .value("Date", date),
                         y: .value("Mood", mood),
                         series: .value("Raw Mood Data", 1))
                .interpolationMethod(.catmullRom)
                .opacity(0.4)
                
                // Point consisting of circles
                PointMark(x: .value("Date", date),
                          y: .value("Mood", mood))
                
                .foregroundStyle(foregroundStyleBased(on: mood))
                .opacity(0.4)
                
                if let averageLineMood = averageLine(for: date) {
                    // Point for the average line
                    LineMark(x: .value("Date", date),
                             y: .value("Mood", averageLineMood),
                             series: .value("Average Mood Data", 2))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.yellow)
                }
            }
            
            if data.count >= 10 {
                RuleMark(y: .value("Average", averageMood))
                    .foregroundStyle(foregroundStyleBased(on: averageMood))
            }
//                .annotation(position: .top,
//                            alignment: .bottomLeading) {
//                    Text("Average: \(averageMood)")
//                }
        }
//        .aspectRatio(1, contentMode: .fit)
    }
    
    // MARK: - Private functions
    private func averageLine(for date: Date) -> Double? {
        guard let index = data.firstIndex(where: { $0.0 == date }) else {
            return nil
        }
        
        let distance: Int = data.count >= 100 ? 3 : 2
        
        var summedMoods: Double = 0
        var numberOfSummedMoods: Int = 0
        
        let startIndex: Int = (index - distance) < 0 ? 0 : (index - distance)
        let endIndex: Int = (index + distance) > (data.count - 1) ? (data.count - 1) : (index + distance)
        
        for i in startIndex...endIndex {
            if data.indices.contains(i) {
                let mood = data[i].1
                summedMoods += mood
                numberOfSummedMoods += 1
            }
        }
        
        let averageMoodForThisPoint: Double = summedMoods / Double(numberOfSummedMoods)
        
        return averageMoodForThisPoint
    }
    
    private func foregroundStyleBased(on mood: Double) -> Color {
        return mood > 0 ? .green: (mood == 0 ? .black : .red)
    }
    
    private static func makeDataUnique(_ dateToAverageMoodOfDate: [(Date, Double)]) -> [(Date, Double)] {
        var dict: [Date: [Double]] = [:]
        
        for (date, mood) in dateToAverageMoodOfDate {
            let key = date
            
            if dict.keys.contains(key) {
                dict[key]!.append(mood)
            } else {
                dict[key] = [mood]
            }
        }
        
        var result: [(Date, Double)] = []
        
        for date in dict.keys {
            let arr: [Double] = dict[date]!
            let summedMoods: Double = arr.reduce(0.0, +)
            let numberOfMoods: Double = Double(arr.count)
            
            let averageMood = summedMoods / numberOfMoods
            
            result.append((date, averageMood))
        }
        
        return result
    }
}




fileprivate struct MoodOverTimeGraphPreview: View {
    @State var dateToAverageMoodOfDate: [(Date, Double)] = []
    
    var body: some View {
        VStack {
            Spacer()
            MoodOverTimeGraph(dateToAverageMoodOfDate: dateToAverageMoodOfDate)
                .padding()
            Spacer()
            Button("New Data") {
                withAnimation {
                    createData()
                }
            }
            
        }
        .onAppear {
            createData()
        }
    }
    
    private func createData() {
        dateToAverageMoodOfDate = []
        
        for _ in 1...100 {
            let randomDate = randomDate()
            let randomMood = Double.random(in: -1...1)
            
            dateToAverageMoodOfDate.append((randomDate, randomMood))
        }
    }
    
    private func randomDate() -> Date {
        let startDate = Date(timeIntervalSince1970: 1625133600)
        let endDate = Date(timeIntervalSince1970: 1626775200)
        let timeIntervalRange = startDate.timeIntervalSince1970...endDate.timeIntervalSince1970
        let randomTimeInterval = TimeInterval.random(in: timeIntervalRange)
        
        return Date(timeIntervalSince1970: randomTimeInterval)
    }

}

#Preview {
    MoodOverTimeGraphPreview()
}
