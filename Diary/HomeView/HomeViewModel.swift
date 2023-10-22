//
//  HomeViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 24.09.2023.
//

import Foundation
import CryptoKit
import os
import SwiftData
import SwiftUI

class HomeViewModel {
    private var logger: Logger = Logger(subsystem: ".diaryApp", category: "HomeViewViewModel")
    
    private let diaryEntryCrypto: DiaryEntryCrypto = DiaryEntryCrypto()
    
    var swiftDataContext: ModelContext
    
    @Published var decryptedDiaryEntries: [DiaryEntry]
    @Published var encryptedDiaryEntries: [EncryptedDiaryEntry]
    
    
    var dictionaryWithEntryBindings: [UUID: Binding<DiaryEntry>] {
        var dict: [UUID: Binding<DiaryEntry>] = [:]
        
        for entry in decryptedDiaryEntries {
            dict[entry.id] = Binding {
                let entryElement = self.decryptedDiaryEntries.filter { decryptedEntry in
                    decryptedEntry.id == entry.id
                }
                return entryElement[0]
            } set: { newValue in
                let predicate = #Predicate<EncryptedDiaryEntry> { $0.id == newValue.id }
                let fetchDescriptor = FetchDescriptor(predicate: predicate)
                
                if let encryptedEntryToChange = try? self.swiftDataContext.fetch(fetchDescriptor), let firstEntry = encryptedEntryToChange.first {
                    let encryptedEntry = self.encryptSingleEntry(newValue)
                    firstEntry.encrypted_data = encryptedEntry.encrypted_data
                } else {
                    print("Couldn't change encrypted entry.")
                }
            }
        }
        
        return dict
    }
    
    
    init(encryptedDiaryEntries: [EncryptedDiaryEntry], swiftDataContext: ModelContext) {
        logger.info("Starting intialising HomeViewViewModel object")
        
        self.encryptedDiaryEntries = encryptedDiaryEntries
        self.swiftDataContext = swiftDataContext
        self.decryptedDiaryEntries = []
        self.decryptedDiaryEntries = decryptEntries(encryptedDiaryEntries)
        
        logger.info("Successfully intialised ViewModel object")
    }
    
    private func decryptEntries(_ encryptedEntries: [EncryptedDiaryEntry]) -> [DiaryEntry] {
        logger.info("Starting function to decrypt the encrypted Entries")
        
        let decryptedEntries: [DiaryEntry] = diaryEntryCrypto.decryptEntries(encryptedEntries)
        
        logger.info("Ended decrypting the diary entries")
        
        return decryptedEntries
    }
    
    private func encryptEntries(_ entries: [DiaryEntry]) -> [EncryptedDiaryEntry] {
        logger.info("Starting function to encrypt the diary entries")
        
        let encryptedEntries = diaryEntryCrypto.encryptEntries(entries)
        
        logger.info("Ended encrypting the diary entries")
        
        return encryptedEntries
    }
    
    private func encryptSingleEntry(_ entry: DiaryEntry) -> EncryptedDiaryEntry {
        logger.info("Starting function to encrypt the diary entry with id '\(entry.id, privacy: .private)'")
        if let encryptedEntry = diaryEntryCrypto.encryptEntry(entry) {
            logger.info("Successfully encrypted the diary entry with id '\(entry.id, privacy: .private)'")
            return encryptedEntry
        } else {
            logger.critical("Couldn't encrypt the diary entry with id '\(entry.id, privacy: .private)', returning a EncryptedDiaryEntry with empty Data")
            return EncryptedDiaryEntry(encrypted_data: Data(), id: entry.id)
        }
    }
}
