//
//  EntryAnalyticsViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 06.10.2023.
//

import Foundation
import NaturalLanguage
import os
import CoreML

struct SentenceMood {
    let sentenceNumber: Int
    let mood: Int
    
    init(sentenceNumber: Int, mood: Int) {
        self.sentenceNumber = sentenceNumber
        self.mood = mood
    }
}

final class EntryAnalyticsViewModel: ObservableObject {
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "EntryAnalyticsViewModel")
    
    @Published var sentencesToMood: [SentenceMood] = []
    @Published var medianMood: Double = 0
    @Published var numberOfSentences: Int = 0
    @Published var numberOfWords: Int = 0
    @Published var averageNumberOfWordsInSentence: Double = 0
    
    @Published var numberOfPositiveSentences: Int = 0
    @Published var numberOfNeutralSentences: Int = 0
    @Published var numberOfNegativeSentences: Int = 0
    
    init() {
        logger.info("Successfully initialised")
    }
    
    func update(entry: DiaryEntry, sentimentPredictor: NLModel, emotionalityRecognizer: NLModel) {
        performSentimentAnalysis(text: entry.content, sentimentPredictor: sentimentPredictor, emotionalityRecogniser: emotionalityRecognizer)
        numberOfWords = countWords(in: entry.content)
        numberOfSentences = extractSentencesFromText(entry.content).count
        averageNumberOfWordsInSentence = Double(numberOfWords) / Double(numberOfSentences)
    }
    
    private func performSentimentAnalysisForOneSentence(_ sentence: String, sentimentPredictor: NLModel) -> Int {
        guard countWords(in: sentence) >= 3 else { return 0 }
        let predictedLabels = sentimentPredictor.predictedLabelHypotheses(for: sentence, maximumCount: 3)
        
        let positiveProbability = predictedLabels["positive"]!
        let negativeProbability = predictedLabels["negative"]!
        
        let error: Double = 0.1
        if abs(positiveProbability - negativeProbability) < error {
            return 0
        } else {
            if positiveProbability > negativeProbability {
                return 1
            } else {
                return -1
            }
        }
    }
    
    private func extractSentencesFromText(_ text: String) -> [String] {
        // Split the text into lines
        let lines = text.components(separatedBy: "\n")
        
        let stopSigns: [Character] = [".", "!", "?"]
        
        var extractedSentences = [String]()
        
        
        var currentSentence: String = ""
        for line in lines {
            for (index, character) in line.enumerated() {
                if stopSigns.contains(character) {
                    currentSentence += String(character)
                    extractedSentences.append(currentSentence)
                    currentSentence = ""
                } else if !(currentSentence == "" && character.isWhitespace) {
                    currentSentence.append(String(character))
                    
                    if index == line.count - 1 {
                        extractedSentences.append(currentSentence)
                    }
                }
            }
        }
        
        // Remove empty sentences and trim whitespace
        let cleanedSentences = extractedSentences
            .map { return $0.last != "?" ? $0 : "" }
        
        return cleanedSentences
    }
    
    
    private func performSentimentAnalysis(text: String, sentimentPredictor: NLModel, emotionalityRecogniser: NLModel) {
        let sentences: [String] = extractSentencesFromText(text)
        
        var sumOfMoods: Int = 0
        var numberOfMoods: Int = 0
        
        for (index, sentence) in sentences.enumerated() {
            guard countWords(in: sentence) >= 3 else { continue }
            let textIsEmotional = isTextEmotional(sentence, emotionalityRecogniser: emotionalityRecogniser)
            let mood = textIsEmotional ? performSentimentAnalysisForOneSentence(sentence, sentimentPredictor: sentimentPredictor) : 0
            if mood != 0 {
                sumOfMoods += mood
                numberOfMoods += 1
            }
            
            switch mood {
            case 1: numberOfPositiveSentences += 1
            case 0: numberOfNeutralSentences += 1
            default: numberOfNegativeSentences += 1
            }
            
            sentencesToMood.append(SentenceMood(sentenceNumber: index + 1, mood: mood))
        }
        
        
        let median = roundToFourDecimalPlaces(number: Double(sumOfMoods) / Double(numberOfMoods == 0 ? 1 : numberOfMoods))
        self.medianMood = median
    }
    
    private func countWords(in sentence: String) -> Int {
        let words = sentence.components(separatedBy: .whitespacesAndNewlines)
        let filteredWords = words.filter { !$0.isEmpty }
        return filteredWords.count
    }
    
    private func isTextEmotional(_ text: String, emotionalityRecogniser: NLModel) -> Bool {
        return emotionalityRecogniser.predictedLabel(for: text) == "Yes"
    }
    
    private func roundToFourDecimalPlaces(number: Double) -> Double {
        let multiplier = pow(10.0, 4.0)
        let roundedNumber = round(number * multiplier) / multiplier
        return roundedNumber
    }
}
