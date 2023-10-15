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

//class AddNewEntryViewModel: ObservableObject {
//    private var logger: Logger = Logger(subsystem: ".diaryApp", category: "FirstViewModel")
//
//    @Published var decryptedDiaryEntries: [DiaryEntry]
//    @Published var encryptedDiaryEntries: [EncryptedDiaryEntry]
//    @Published var settings: [Settings]
//
//    init(encryptedDiaryEntries: [EncryptedDiaryEntry] = [], settings: [Settings] = []) {
//        logger.info("Starting intialising FirstViewModel object")
//
//        self.settings = settings
//        self.encryptedDiaryEntries = encryptedDiaryEntries
//        self.decryptedDiaryEntries = FirstViewModel.decryptEntries(encryptedDiaryEntries)
//
//        logger.info("Successfully intialised FirstViewModel object")
//    }
//
//    func determineInitialView() -> CurrentView {
//        logger.info("Starting function to detemine the initial View")
//
//        var viewToReturn: CurrentView = .appSetup
//
//        if settings.count > 1 {
//            logger.critical("Multiply settings instances found. Returning .diary View")
//            viewToReturn = .diary
//        } else if settings.count == 1 {
//            if settings[0].authenticateWithBiometricData == true {
//                viewToReturn = .authenticationView
//            } else {
//                viewToReturn = .diary
//            }
//        } else {
//            viewToReturn = .appSetup
//        }
//
//        logger.info("Successfully determined initial View")
//        return viewToReturn
//    }
//
//    private static func decryptEntries(_ encryptedEntries: [EncryptedDiaryEntry]) -> [DiaryEntry] {
//        let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "FirstViewModel")
//
//        logger.info("Starting function to decrypt the encrypted Entries")
//        var decryptedEntries: [DiaryEntry] = []
//
//        let key = FirstViewModel.getSymmetricKey()
//
//        let entryCrypto = DiaryEntryCrypto(key: key)
//
//        for encryptedEntry in encryptedEntries {
//            guard let decryptedEntry = entryCrypto.decryptEntry(encryptedEntry) else {
//                logger.critical("Couldn't decrypt the EncryptedDiaryEntry with id \(encryptedEntry.id, privacy: .private)")
//                continue
//            }
//            decryptedEntries.append(decryptedEntry)
//        }
//
//        if encryptedEntries.count == decryptedEntries.count {
//            logger.info("Successfully decrypted all diary entries")
//        } else if encryptedEntries.count >= 0 && decryptedEntries.count == 0 {
//            logger.critical("Couldn't decrypt encrypted entries")
//        } else {
//            logger.critical("Decrypted some diary entries, but some couldn't be decrypted")
//        }
//
//        return decryptedEntries
//    }
//
//    private static func encryptEntries(_ entries: [DiaryEntry]) -> [EncryptedDiaryEntry] {
//        let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "FirstViewModel")
//        logger.info("Starting function to encrypt the diary entries")
//
//        var encryptedEntries: [EncryptedDiaryEntry] = []
//
//        let key = FirstViewModel.getSymmetricKey()
//
//        let entryCrypto = DiaryEntryCrypto(key: key)
//
//        for entry in entries {
//            if let encryptedEntry = entryCrypto.encryptEntry(entry) {
//                encryptedEntries.append(encryptedEntry)
//                logger.info("Successfully encrypted the diary entry with id '\(entry.id, privacy: .private)'")
//            } else {
//                logger.critical("Couldn't encrypt the diary entry with id '\(entry.id, privacy: .private)'")
//            }
//        }
//
//        if entries.count == encryptedEntries.count {
//            logger.info("Successfully encrypted all diary entries")
//        } else if entries.count > 0 && encryptedEntries.count == 0{
//            logger.critical("Some diary entries were encrypted, other's not")
//        } else {
//            logger.critical("Couldn't encrypt all diary entries")
//        }
//
//        return encryptedEntries
//    }
//
//    private static func getSymmetricKey() -> SymmetricKey {
//        let logger = Logger(subsystem: ".com.diaryApp", category: "FirstViewModel")
//        logger.info("Starting function to get the symmetric key")
//
//        if let savedKey = retrieveSavedSymmetricKey() {
//            logger.info("Successfully retrieved the saved symmetric key")
//            return savedKey
//        }
//
//        logger.warning("No saved symmetric key was found, generating a new one...")
//
//        let randomKey = generateSymmetricKey()
//
//        logger.info("Successfully generated new symmetric key")
//
//        saveSymmetricKey(randomKey)
//
//        return randomKey
//    }
//
//    private static func generateSymmetricKey() -> SymmetricKey {
//        let logger = Logger(subsystem: ".com.diaryApp", category: "FirstViewModel")
//        logger.info("Starting function to generate a random symmetric key")
//
//        let key = SymmetricKey(size: .bits256)
//
//        logger.info("Successfully generated a random symmetric key")
//
//        return key
//    }
//
//    private static func saveSymmetricKey(_ key: SymmetricKey) {
//        let logger = Logger(subsystem: ".com.diaryApp", category: "FirstViewModel")
//        logger.info("Starting function to save a symmetric key")
//        do {
//            try KeychainHelper.saveSymmetricKey(key)
//            logger.info("Successfully saved a symmetric key")
//        } catch {
//            logger.critical("Couldn't save symmetric key")
//        }
//    }
//
//    private static func retrieveSavedSymmetricKey() -> SymmetricKey? {
//        let logger = Logger(subsystem: ".com.diaryApp", category: "FirstViewModel")
//
//        logger.info("Starting function to retrieve the saved symmetric key if it exists")
//
//        let key = try? KeychainHelper.retrieveSymmetricKey()
//        if key == nil {
//            logger.warning("The symmetric key couldn't be retrieved, returning nil")
//        } else {
//            logger.info("Successfully retrieved the saved symmetric key")
//        }
//
//        return key
//    }
//
//    func encryptEntry(_ entry: DiaryEntry) -> EncryptedDiaryEntry {
//        logger.info("Starting function to encrypt the diary entry with id '\(entry.id, privacy: .private)'")
//        let key = FirstViewModel.getSymmetricKey()
//
//        let entryCrypto = DiaryEntryCrypto(key: key)
//        logger.info("Successfully encrypted the diary entry with id '\(entry.id, privacy: .private)'")
//        return entryCrypto.encryptEntry(entry)!
//    }
//
//    func decryptEntry(_ entry: EncryptedDiaryEntry) -> DiaryEntry {
//        logger.info("Starting function to decrypt the diary entry with id '\(entry.id, privacy: .private)'")
//        let key = FirstViewModel.getSymmetricKey()
//
//        let entryCrypto = DiaryEntryCrypto(key: key)
//        logger.info("Successfully encrypted the diary entry with id '\(entry.id, privacy: .private)'")
//
//        if let decryptedEntry = entryCrypto.decryptEntry(entry) {
//            return decryptedEntry
//        } else {
//            logger.critical("Couldn't decrypt diary entry with id '\(entry.id, privacy: .private)'")
//            fatalError()
//        }
//    }
//
//    func updateEntries(settings: [Settings], encryptedDiaryEntries: [EncryptedDiaryEntry]) {
//        logger.info("Starting function to update the FirstViewModel properties settings and encryptedDiaryEntries")
//        self.settings = settings
//        self.encryptedDiaryEntries = encryptedDiaryEntries
//        updateDecryptedDiaryEntries()
//        logger.info("Successfully finished updating the FirstViewModel properties settings and encryptedDiaryEntries")
//    }
//
//    private func updateDecryptedDiaryEntries() {
//        logger.info("Starting function to update the decrypted diary entries")
//        self.decryptedDiaryEntries = FirstViewModel.decryptEntries(self.encryptedDiaryEntries)
//        logger.info("Successfully updated the decrypted diary entries")
//    }
//
//    class LocalizedStrings {
//        static let diaryHeadingTextFieldPlaceholder: String = String(localized: "Heading of the diary entry", defaultValue: "Heading of the diary entry", comment: "This text is used as a TextField placeholder where the diary entry should be written")
//        static let diaryContentTextFieldPlaceholder: String = String(localized: "Your diary entry", defaultValue: "Your diary entry", comment: "This text is used as a TextField placeholder where the diary content should be written")
//        static let diaryDateDatepickerDescription: String = String(localized: "Diary entry date", defaultValue: "Diary entry date", comment: "This text is used as a DatePicker placeholder where the diary date should be chosen")
//        static let navigationBarTitle: String = String(localized: "New Diary Entry", defaultValue: "New Diary Entry", comment: "This text is used as the navigation bar title in the AddNewEntryView")
//        static let saveButtonText: String = String(localized: "Save", defaultValue: "Save", comment: "This is text for the button that saves created entries")
//    }
//}
