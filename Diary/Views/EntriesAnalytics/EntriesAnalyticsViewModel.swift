//
//  EntriesAnalyticsViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 11.10.2023.
//

import Foundation

final class EntriesAnalyticsViewModel: ObservableObject {
    private let logger: AppLogger = AppLogger(category: "EntriesAnalyticsViewModel")
    
    @Published var totalNumberOfSentences: Int = 0
    @Published var averageNumberOfSentences: Double = 0
    @Published var totalNumberOfWords: Int = 0
    @Published var averageNumberOfWordsPerSentence: Double = 0
    @Published var totalNumberOfEntries: Int = 0
    @Published var averageNumberOfDaysBetweenDiaryEntries: Double = 0
    
    init() {
        logger.info("EntriesAnalyticsViewModel was initialised")
    }
    
    func update(with diaryEntries: [DiaryEntry]) {
        logger.info("Starting function to update the properties based on encryptedDiaryEntries")
        
        updateProperties(basedOn: diaryEntries)
        
        logger.info("Succesfully updated the properties based on encryptedDiaryEntries")
    }
    
    private func updateProperties(basedOn entries: [DiaryEntry]) {
        totalNumberOfSentences = 0
        averageNumberOfSentences = 0
        totalNumberOfWords = 0
        averageNumberOfWordsPerSentence = 0
        totalNumberOfEntries = 0
        averageNumberOfDaysBetweenDiaryEntries = 0
        
        
        for entry in entries {
            let sentencesCount: Int = extractSentencesFromText(entry.content).count
            let numberOfWords: Int = countWords(in: entry.content)
            
            totalNumberOfEntries += 1
            totalNumberOfWords += numberOfWords
            totalNumberOfSentences += sentencesCount
        }
        
        averageNumberOfWordsPerSentence = roundToFourDecimalPlaces(number: Double(totalNumberOfWords)/Double(totalNumberOfSentences))
        averageNumberOfSentences = roundToFourDecimalPlaces(number: Double(totalNumberOfSentences)/Double(totalNumberOfEntries))
        averageNumberOfDaysBetweenDiaryEntries = averageDateDifferenceInDays(basedOn: entries)
        
        if averageNumberOfWordsPerSentence.isNaN { averageNumberOfWordsPerSentence = 0 }
        if averageNumberOfSentences.isNaN { averageNumberOfSentences = 0 }
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
    
    private func countWords(in sentence: String) -> Int {
        let words = sentence.components(separatedBy: .whitespacesAndNewlines)
        let filteredWords = words.filter { !$0.isEmpty }
        return filteredWords.count
    }
    
    private func roundToFourDecimalPlaces(number: Double) -> Double {
        let multiplier = pow(10.0, 4.0)
        let roundedNumber = round(number * multiplier) / multiplier
        return roundedNumber
    }
    
    private func averageDateDifferenceInDays(basedOn entries: [DiaryEntry]) -> Double {
        guard entries.count > 1 else {
            return 0.0
        }
        
        var totalDifferenceInSeconds = 0.0
        
        for i in 1..<entries.count {
            let earlierDate = entries[i - 1].date
            let laterDate = entries[i].date
            
            let timeInterval = laterDate.timeIntervalSince(earlierDate)
            totalDifferenceInSeconds += timeInterval
        }
        
        // Convert the total difference from seconds to days
        let secondsInADay: Double = 24 * 60 * 60 // 1 day = 24 hours * 60 minutes * 60 seconds
        let totalDifferenceInDays = totalDifferenceInSeconds / secondsInADay

        let averageDifference = totalDifferenceInDays / Double(entries.count - 1)
        return averageDifference
    }
}
