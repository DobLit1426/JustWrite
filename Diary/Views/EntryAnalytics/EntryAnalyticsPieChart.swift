//
//  EntryAnalyticsPieChart.swift
//  Diary
//
//  Created by Dobromir Litvinov on 21.11.2023.
//

import SwiftUI
import Charts

struct EntryAnalyticsPieChart: View {
    let numberOfPositiveSentences: Int
    let numberOfNegativeSentences: Int
    let numberOfNeutralSentences: Int
    
    let chartSectors: [ChartSector]
    
    init(numberOfPositiveSentences: Int, numberOfNegativeSentences: Int, numberOfNeutralSentences: Int) {
        var numberOfSentences = numberOfNeutralSentences + numberOfNegativeSentences + numberOfNeutralSentences
        
        if numberOfSentences <= 0 {
            numberOfSentences = 1
        }
        
        chartSectors = [
            ChartSector(part: Double(numberOfPositiveSentences) / Double(numberOfSentences), name: "Positive sentences"),
            ChartSector(part: Double(numberOfNegativeSentences) / Double(numberOfSentences), name: "Negative sentences"),
            ChartSector(part: Double(numberOfNeutralSentences) / Double(numberOfSentences), name: "Neutral sentences")
        ]
        self.numberOfPositiveSentences = numberOfPositiveSentences
        self.numberOfNegativeSentences = numberOfNegativeSentences
        self.numberOfNeutralSentences = numberOfNeutralSentences
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Spacer()
                Chart(chartSectors) { sector in
                    SectorMark (
                        angle: .value(Text(verbatim: sector.name), sector.part),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value(Text(sector.name), sector.name))
                }
                .padding()
                .frame(width: geometry.size.width * 0.9, height: geometry.size.height < 100 ? 400 : geometry.size.height * 0.9)
                Spacer()
            }
        }
    }
}

#Preview {
    EntryAnalyticsPieChart(numberOfPositiveSentences: 3, numberOfNegativeSentences: 5, numberOfNeutralSentences: 10)
}
