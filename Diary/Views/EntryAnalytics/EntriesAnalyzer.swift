//
//  EntriesAnalyzer.swift
//  Diary
//
//  Created by Dobromir Litvinov on 07.11.2023.
//

import Foundation
import SwiftUI
import NaturalLanguage
import CoreML

final class EntriesAnalyzerResponce {
    let averageMood: Int
    let averageMoodAsString: String
    let rawMood: Double
    
    let numberOfPositiveSentences: Int
    let numberOfNeutralSentences: Int
    let numberOfNegativeSentences: Int
    
    let sentencesToMood: [SentenceMood]
    
    let numberOfWords: Int
    
    init(averageMood: Int, averageMoodAsString: String, rawMood: Double, numberOfPositiveSentences: Int, numberOfNeutralSentences: Int, numberOfNegativeSentences: Int, sentencesToMood: [SentenceMood], numberOfWords: Int) {
        self.averageMood = averageMood
        self.averageMoodAsString = averageMoodAsString
        self.rawMood = rawMood
        self.numberOfPositiveSentences = numberOfPositiveSentences
        self.numberOfNeutralSentences = numberOfNeutralSentences
        self.numberOfNegativeSentences = numberOfNegativeSentences
        self.sentencesToMood = sentencesToMood
        self.numberOfWords = numberOfWords
    }
}

final class EntriesAnalyzer: ObservableObject {
    // MARK: - Logger
    /// Static logger instance
    private static let logger: AppLogger = AppLogger(category: "EntriesAnalyzer")
    
    // MARK: Private variables
    
//    @State private var sentimentPredictor: NLModel? = nil
//    @State private var emotionalityRecognizer: NLModel? = nil
    
    
    init() { }
    
//    public func onAppear() {
//        let models = setupModels()
//        sentimentPredictor = models.0
//        emotionalityRecognizer = models.0
//    }

//    public func analytics(for entry: DiaryEntry) -> EntriesAnalyzerResponce? {
//        guard sentimentPredictor != nil else {
//            logger.critical("predictMood is called, although not set up")
//            return nil
//        }
//        
//        guard emotionalityRecognizer != nil else {
//            logger.critical("emotionalityRecognizer is called, although not set up")
//            return nil
//        }
//        
//        let sentences: [String] = extractSentencesFromText(entry.content)
//        
//        var sumOfMoods: Int = 0
//        var numberOfMoods: Int = 0
//        
//        var numberOfPositiveSentences = 0
//        var numberOfNeutralSentences = 0
//        var numberOfNegativeSentences = 0
//        
//        var sentencesToMood: [SentenceMood] = []
//        
//        for (index, sentence) in sentences.enumerated() {
//            guard countWords(in: sentence) >= 3 else { continue }
//            let textIsEmotional = isTextEmotional(sentence)
//            let mood = textIsEmotional ? performSentimentAnalysisForOneSentence(sentence) : 0
//            if mood != 0 {
//                sumOfMoods += mood
//                numberOfMoods += 1
//            }
//            
//            switch mood {
//            case 1: numberOfPositiveSentences += 1
//            case 0: numberOfNeutralSentences += 1
//            default: numberOfNegativeSentences += 1
//            }
//            
//            sentencesToMood.append(SentenceMood(sentenceNumber: index + 1, mood: mood))
//        }
//        
//        let rawMood = Double(sumOfMoods) / Double(numberOfMoods == 0 ? 1 : numberOfMoods)
//        let averageMood = formatAverageMood(rawMood)
//        
//        
//        return EntriesAnalyzerResponce(averageMood: averageMood.0, averageMoodAsString: averageMood.1, rawMood: rawMood, numberOfPositiveSentences: numberOfPositiveSentences, numberOfNeutralSentences: numberOfNeutralSentences, numberOfNegativeSentences: numberOfNegativeSentences, sentencesToMood: sentencesToMood, numberOfWords: countWords(in: entry.content))
//    }
//    
    
    // MARK: - Copy into the target class to load models and analyze entries
    
//    private func performSentimentAnalysis(for entry: DiaryEntry) -> Double? {
//        return EntriesAnalyzer.sentimentAnalysis(for: entry, sentimentPredictor: sentimentPredictor, emotionalityRecognizer: emotionalityRecognizer)
//    }
//    
//    private func setupModels() {
//        guard let models = EntriesAnalyzer.setupModels() else {
//            logger.critical("No NL models were created")
//            return
//        }
//        
//        sentimentPredictor = models.0
//        emotionalityRecognizer = models.1
//    }
//    
//    private func predictMoodForEntries() {
//        for entry in entries {
//            if entry.mood == nil {
//                entry.mood = performSentimentAnalysis(for: entry)
//            }
//        }
//    }
    
    
    /// Creates sentimentPredictor and emotionalityRecogniser and returns them
    /// - Returns: (sentimentPredictor, emotionalityRecogniser)
    public static func setupModels() -> (NLModel, NLModel)? {
        guard let sentimentPredictorMLModel = try? EntriesSentimentClassifier(configuration: MLModelConfiguration()).model else {
            logger.critical("Couldn't create sentimentPredictorMLModel")
            return nil
        }
        guard let sentimentPredictorNLModel = try? NLModel(mlModel: sentimentPredictorMLModel) else {
            logger.critical("Couldn't create sentimentPredictorModel")
            return nil
        }
        
        guard let emotionalityRecognizerMLModel = try? EmotionalityRecognizer(configuration: MLModelConfiguration()).model else {
            logger.critical("Couldn't create emotionalityRecognizer")
            return nil
        }
        
        guard let emotionalityRecognizerNLModel = try? NLModel(mlModel: emotionalityRecognizerMLModel) else {
            logger.critical("Couldn't create emotionalityRecognizer")
            return nil
        }
        
        return (sentimentPredictorNLModel, emotionalityRecognizerNLModel)
    }
    
    private static func isTextEmotional(_ text: String, emotionalityRecognizer: NLModel) -> Bool {
        return emotionalityRecognizer.predictedLabel(for: text) == "Yes"
    }
    
    private static func sentimentAnalysisForSentence(_ sentence: String, sentimentPredictor: NLModel) -> Int {
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
    
    public static func sentimentAnalysis(for entry: DiaryEntry, sentimentPredictor: NLModel?, emotionalityRecognizer: NLModel?) -> Double? {
        return sentimentAnalysis(for: entry.content, sentimentPredictor: sentimentPredictor, emotionalityRecognizer: emotionalityRecognizer)
    }
    
    public static func sentimentAnalysis(for text: String, sentimentPredictor: NLModel?, emotionalityRecognizer: NLModel?) -> Double? {
        guard let sentimentPredictor else {
            logger.critical("sentimentPredictor is called, although not set up")
            return nil
        }
        
        guard let emotionalityRecognizer else {
            logger.critical("emotionalityRecognizer is called, although not set up")
            return nil
        }
        
        let sentences: [String] = extractSentencesFromText(text)
        
        var numberOfPositiveSentences = 0
        var numberOfNeutralSentences = 0
        var numberOfNegativeSentences = 0
        
        var sentencesToMood: [SentenceMood] = []
        
        for (index, sentence) in sentences.enumerated() {
            guard countWords(in: sentence) >= 3 else { continue }
            let textIsEmotional = isTextEmotional(sentence, emotionalityRecognizer: emotionalityRecognizer)
            let mood = textIsEmotional ? sentimentAnalysisForSentence(sentence, sentimentPredictor: sentimentPredictor) : 0
            
            switch mood {
            case 1: numberOfPositiveSentences += 1
            case 0: numberOfNeutralSentences += 1
            default: numberOfNegativeSentences += 1
            }
            
            sentencesToMood.append(SentenceMood(sentenceNumber: index + 1, mood: mood))
        }
        
        let rawMood = countAverageMood(numberOfPositiveSentences: numberOfPositiveSentences, numberOfNeutralSentences: numberOfNeutralSentences, numberOfNegativeSentences: numberOfNegativeSentences)
        
        return rawMood
        
    }
    
    public static func extractSentencesFromText(_ text: String) -> [String] {
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
        
        let cleanedSentences = extractedSentences
            .map { return $0.last != "?" ? $0 : "" }
        
        return cleanedSentences
    }
    
    public static func countWords(in sentence: String) -> Int {
        let words = sentence.components(separatedBy: .whitespacesAndNewlines)
        let filteredWords = words.filter { !$0.isEmpty }
        return filteredWords.count
    }
    
    private static func roundToOneDecimalPlaces(number: Double) -> Double {
        let multiplier = pow(10.0, 1.0)
        let roundedNumber = round(number * multiplier) / multiplier
        return roundedNumber
    }
    
    public static func formatAverageMood(_ mood: Double) -> Int {
        let number = Int(round((roundToOneDecimalPlaces(number: mood) + 1) * 5))
        return number
    }
    
    public static func countAverageMood(numberOfPositiveSentences: Int, numberOfNeutralSentences: Int, numberOfNegativeSentences: Int) -> Double {
        let numberOfSentences = numberOfPositiveSentences + numberOfNegativeSentences + numberOfNeutralSentences
        
        let sumOfMoods: Int = numberOfPositiveSentences - numberOfNegativeSentences
        
        return Double(sumOfMoods) / Double(numberOfSentences == 0 ? 1 : numberOfSentences)
    }
}
