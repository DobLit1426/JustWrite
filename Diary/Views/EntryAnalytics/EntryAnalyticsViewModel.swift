//
//  EntryAnalyticsViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 06.10.2023.
//

import Foundation
import NaturalLanguage
import CoreML

final class EntryAnalyticsViewModel: ObservableObject {
    private let logger: AppLogger = AppLogger(category: "EntryAnalyticsViewModel")
    
    @Published var sentencesToMood: [SentenceMood] = []
    @Published var averageMood: Double = 0
    @Published var numberOfSentences: Int = 0
    @Published var numberOfWords: Int = 0
    @Published var averageNumberOfWordsInSentence: Double = 0
    
    @Published var numberOfPositiveSentences: Int = 0
    @Published var numberOfNeutralSentences: Int = 0
    @Published var numberOfNegativeSentences: Int = 0
    
    init() {
        logger.info("Initialising EntryAnalyticsViewModel...")
        
        logger.info("Successfully initialised EntryAnalyticsViewModel")
    }
    
    func update(entry: DiaryEntry, sentimentPredictor: NLModel, emotionalityRecognizer: NLModel) {
//        performSentimentAnalysis(text: entry.content, sentimentPredictor: sentimentPredictor, emotionalityRecogniser: emotionalityRecognizer)
//        numberOfWords = EntriesAnalyzer.countWords(in: entry.content)
//        numberOfSentences = EntriesAnalyzer.extractSentencesFromText(entry.content).count
        averageNumberOfWordsInSentence = Double(numberOfWords) / Double(numberOfSentences)
    }

    private func performSentimentAnalysis(text: String, sentimentPredictor: NLModel, emotionalityRecogniser: NLModel) {
        self.averageMood = EntriesAnalyzer.sentimentAnalysis(for: text, sentimentPredictor: sentimentPredictor, emotionalityRecognizer: emotionalityRecogniser) ?? 0
    }
}
