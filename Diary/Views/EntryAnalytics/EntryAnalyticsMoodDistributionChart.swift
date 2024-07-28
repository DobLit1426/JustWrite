//
//  EntryAnalyticsMoodDistributionChart.swift
//  Diary
//
//  Created by Dobromir Litvinov on 21.11.2023.
//

import SwiftUI
import Charts

struct EntryAnalyticsMoodDistributionChart: View {
    let medianMood: Double
    
    let numberOfPositiveSentences: Int
    let numberOfNeutralSentences : Int
    let numberOfNegativeSentences : Int
    
    let sentencesToMood: [SentenceMood]
    
    init(sentencesToMood: [SentenceMood]) {
        var positiveSentences: Int = 0
        var neutralSentences: Int = 0
        var negativeSentences: Int = 0
        var sumOfMoods: Int = 0
        
        for sentenceMood in sentencesToMood {
            switch sentenceMood.mood {
            case 1:
                positiveSentences += 1
                sumOfMoods += 1
            case 0:
                neutralSentences += 1
            case -1: 
                negativeSentences += 1
                sumOfMoods -= 1
            default: neutralSentences += 1
            }
        }
        
        self.medianMood = EntriesAnalyzer.countAverageMood(numberOfPositiveSentences: positiveSentences, numberOfNeutralSentences: neutralSentences, numberOfNegativeSentences: negativeSentences)
        
        self.numberOfPositiveSentences = positiveSentences
        self.numberOfNeutralSentences = positiveSentences
        self.numberOfNegativeSentences = negativeSentences
        self.sentencesToMood = sentencesToMood
    }
    
    @State private var graphSelectedSentence: Int? = nil
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack(alignment: .center) {
                        Spacer()
                        if DeviceSpecifications.isIPad {
                            stats
                            Spacer()
                        }
                        Chart {
                            RuleMark(y: .value("Median", medianMood))
                                .foregroundStyle(foregroundStyleForMood(medianMood))
                            
                            ForEach(sentencesToMood, id: \.sentenceNumber) { sentenceMood in
                                LineMark(
                                    x: .value("Number of sentence", sentenceMood.sentenceNumber),
                                    y: .value("Mood", sentenceMood.mood)
                                )
                                .interpolationMethod(.monotone)
                                
                                PointMark(
                                    x: .value("Number of sentence", sentenceMood.sentenceNumber),
                                    y: .value("Mood", sentenceMood.mood)
                                )
                                .foregroundStyle(foregroundStyleForMood(Double(sentenceMood.mood)))
                                .symbol(.cross)
                            }
                            
                            if let graphSelectedSentence, graphSelectedSentence <= sentencesToMood.count && graphSelectedSentence >= sentencesToMood.startIndex + 1 {
                                RuleMark(x: .value("Selected", graphSelectedSentence))
                                    .foregroundStyle(.gray.opacity(0.4))
                                    .zIndex(-1)
                                    .offset(yStart: -10)
                                    .annotation(position: .top, spacing: 0, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                                        let sentenceMood = sentencesToMood.first(where: { $0.sentenceNumber == graphSelectedSentence }) ?? SentenceMood(sentenceNumber: graphSelectedSentence, mood: 0)
                                        Text("Sentece \(graphSelectedSentence) is \(moodTextualRepresantation(sentenceMood.mood))")
                                            .background(.gray.opacity(0.4))
                                    }
                            }
                        }
                        .chartXSelection(value: $graphSelectedSentence)
                        .padding()
                        .frame(width: geometry.size.width * (DeviceSpecifications.isIPad ? 0.6 : 0.9), height: geometry.size.height < 100 ? 400 : geometry.size.height * 0.99)
                        
                        Spacer()
                    }
                    
                    
                    if !DeviceSpecifications.isIPad { stats }
                }
                .padding(.top, 20)
            }
            .scrollIndicators(.visible)
        }
    }
    
    private var stats: some View {
        VStack(alignment: .leading) {
            Divider()
            Text("Chart: Number of sentence -> mood").bold()
            Divider()
            Text("Number of positive sentences: \(numberOfPositiveSentences)")
            Text("Number of neutral sentences: \(numberOfNeutralSentences)")
            Text("Number of negative sentences: \(numberOfNegativeSentences)")
            Divider()
            Text("Average mood: ") + Text("\(medianMood) (\(moodAsString(medianMood)))").foregroundStyle(foregroundStyleForMood(medianMood))
            Divider()
            Text("Legend: ")
            Text("* 1 is a positive sentence").foregroundStyle(.green)
            Text("* 0 is a neutral sentence").foregroundStyle(.black)
            Text("* -1 is a negative sentence").foregroundStyle(.red)
        }
        .padding()
    }
    
    func moodTextualRepresantation(_ mood: Int) -> String {
        if mood > 0 {
            return "positive"
        } else if mood == 0 {
            return "neutral"
        } else {
            return "negative"
        }
    }
    
    private func foregroundStyleForMood(_ mood: Double) -> Color {
        if mood > 0 {
            return .green
        } else if mood == 0{
            return .black
        } else {
            return .red
        }
    }
    
    private func moodAsString(_ mood: Double) -> String {
        if mood > 0 {
            return "positive"
        } else if mood == 0 {
            return "neutral"
        } else {
            return "negative"
        }
    }
}

#Preview {
    var sentencesToMood: [SentenceMood] = []

    for _ in 1...30 {
        let randomMood = [-1, 0, 1].randomElement() ?? 0
        let newSentenceMood = SentenceMood(sentenceNumber: 0, mood: randomMood)
        
        sentencesToMood.append(newSentenceMood)
    }
    return EntryAnalyticsMoodDistributionChart(sentencesToMood: sentencesToMood)
}
