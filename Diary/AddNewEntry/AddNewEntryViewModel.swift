//
//  AddNewEntryViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 06.10.2023.
//

import Foundation
import CryptoKit
import os

class AddNewEntryViewModel: ObservableObject {
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "AddNewEntryViewModel")
    
    init() {
        logger.info("Successfully initialised AddDiaryEntryViewModel")
    }
    
    class LocalizedStrings {
        static let diaryHeadingTextFieldPlaceholder: String = String(localized: "Heading of the diary entry", defaultValue: "Heading of the diary entry", comment: "This text is used as a TextField placeholder where the diary entry should be written")
        static let diaryContentTextFieldPlaceholder: String = String(localized: "Your diary entry", defaultValue: "Your diary entry", comment: "This text is used as a TextField placeholder where the diary content should be written")
        static let diaryDateDatepickerDescription: String = String(localized: "Diary entry date", defaultValue: "Diary entry date", comment: "This text is used as a DatePicker placeholder where the diary date should be chosen")
        static let navigationBarTitle: String = String(localized: "New Diary Entry", defaultValue: "New Diary Entry", comment: "This text is used as the navigation bar title in the AddNewEntryView")
        static let saveButtonText: String = String(localized: "Save", defaultValue: "Save", comment: "This is text for the button that saves created entries")
    }
    
    private var datePickerStartingDate: Date {
        let currentDate = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = -150
        if let startingDate = calendar.date(byAdding: dateComponents, to: currentDate) {
            return startingDate
        } else {
            logger.critical("Couldn't create startingDate, returning Date.now")
            return Date.now
        }
    }
    
    var datePickerDateRange: ClosedRange<Date> { datePickerStartingDate...Date.now }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        if let formattedString = formatter.string(for: date) {
            return formattedString
        } else {
            logger.critical("Couldn't format the date, returning date.description")
            return date.description
        }
    }
    
    func convertRawDataToEncryptedDiaryEntry(heading: String, content: String, date: Date) -> EncryptedDiaryEntry {
        logger.info("Starting function to convert the raw entry data to an EncryptedDiaryEntry object")
        let trimmedHeading = heading.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let entry = DiaryEntry(heading: trimmedHeading, content: trimmedContent, date: date)
        let encryptedEntry = encryptEntry(entry)
        
        logger.info("Successfully converted the raw entry data to an EncryptedDiaryEntry object")
        return encryptedEntry
    }
    
    private func encryptEntry(_ entry: DiaryEntry) -> EncryptedDiaryEntry {
        logger.info("Starting function to encrypt the diary entry with id '\(entry.id, privacy: .private)'")
        let key = getSymmetricKey()
        
        let entryCrypto = DiaryEntryCrypto(key: key)
        if let encryptedDiaryEntry = entryCrypto.encryptEntry(entry) {
            logger.info("Successfully encrypted the diary entry with id '\(entry.id, privacy: .private)'")
            return encryptedDiaryEntry
        } else {
            logger.critical("Couldn't encrypt the diary entry with id '\(entry.id, privacy: .private)', throwing fatalError...")
            fatalError()
        }
    }
    
    private func getSymmetricKey() -> SymmetricKey {
        logger.info("Starting function to get the symmetric key")
        
        let symmetricKey = KeychainHelper.getSymmetricKey()
            
        logger.info("Successfully retrieved the saved symmetric key")
        return symmetricKey
    }
}
