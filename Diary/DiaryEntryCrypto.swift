//
//  DiaryEntryCrypto.swift
//  Diary
//
//  Created by Dobromir Litvinov on 20.09.2023.
//

import Foundation
import CryptoKit
import os

struct DiaryEntryCrypto {
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "DiaryEntryCrypto")
        
    let key: SymmetricKey
    init(key: SymmetricKey? = nil) {
        if let key {
            self.key = key
        } else {
            self.key = KeychainHelper.getSymmetricKey()
        }
        
        logger.info("Initialised DiaryEntryCrypto object")
    }
    
    func encryptEntry(_ entry: DiaryEntry) -> EncryptedDiaryEntry? {
        logger.info("Starting encryption of the diary entry with id '\(entry.id, privacy: .private)'")
        
        guard let entryJSON = entry.generate_json() else {
            logger.error("Couldn't generate JSON from entry with id '\(entry.id, privacy: .private)'")
            return nil
        }
        
        guard let data = entryJSON.data(using: .utf8) else {
            logger.error("JSON of the entry with id '\(entry.id, privacy: .private)' couldn't be converted to Data")
            return nil
        }
        
        guard let sealedBox = try? AES.GCM.seal(data, using: key) else {
            logger.error("Couldn't seal diary entry data '\(data, privacy: .private)'")
            return nil
        }
        
        
        guard let encryptedData = sealedBox.combined else {
            logger.error("Couldn't encrypt diary entry data")
            return nil
        }
        
        
        let encryptedEntryObject = EncryptedDiaryEntry(encrypted_data: encryptedData, id: entry.id)
        logger.info("Successfully encrypted DiaryEntry with id '\(entry.id, privacy: .private)'")
        
        return encryptedEntryObject
    }
    
    func decryptEntry(_ encryptedEntry: EncryptedDiaryEntry) -> DiaryEntry? {
        logger.info("Starting decryption of the diary entry with id '\(encryptedEntry.id, privacy: .private)'")
        
        let encryptedEntryData = encryptedEntry.encrypted_data

        guard let sealedBox = try? AES.GCM.SealedBox(combined: encryptedEntryData) else {
            logger.error("Couldn't create SealedBox for the diary entry with id '\(encryptedEntry.id, privacy: .private)'")
            return nil
        }
        guard let decryptedData = try? AES.GCM.open(sealedBox, using: key) else {
            logger.error("Couldn't open SealedBox of the diary entry with id '\(encryptedEntry.id, privacy: .private)'")
            return nil
        }
        
        guard let decryptedJSONString = String(data: decryptedData, encoding: .utf8) else {
            logger.error("Couldn't convert the decrypted diary entry data with id '\(encryptedEntry.id, privacy: .private)' to JSON String")
            return nil
        }
        
        guard let entry = DiaryEntry(from: decryptedJSONString) else {
            logger.error("Couldn't create DiaryEntry object with id '\(encryptedEntry.id, privacy: .private)' from JSON")
            return nil
        }
        
        logger.info("Successfully decrypted the diary entry with id '\(encryptedEntry.id, privacy: .private)'")
        return entry
    }
    
    func encryptEntries(_ entries: [DiaryEntry]) -> [EncryptedDiaryEntry] {
        logger.info("Starting function to encrypt the diary entries")
        
        var encryptedEntries: [EncryptedDiaryEntry] = []
        
        
        for entry in entries {
            if let encryptedEntry = encryptEntry(entry) {
                encryptedEntries.append(encryptedEntry)
                logger.info("Successfully encrypted the diary entry with id '\(entry.id, privacy: .private)'")
            } else {
                logger.critical("Couldn't encrypt the diary entry with id '\(entry.id, privacy: .private)'")
            }
        }
        
        if entries.count == encryptedEntries.count {
            logger.info("Successfully encrypted all diary entries")
        } else if entries.count > 0 && encryptedEntries.count == 0 {
            logger.critical("Couldn't encrypt all diary entries")
        } else {
            logger.critical("Some diary entries were encrypted, other's not")
        }
        
        return encryptedEntries
    }
    
    func decryptEntries(_ encrypted_entries: [EncryptedDiaryEntry]) -> [DiaryEntry] {
        logger.info("Starting function to decrypt the diary entries")
        
        var decryptedEntries: [DiaryEntry] = []
        
        
        for entry in encrypted_entries {
            if let decryptedEntry = decryptEntry(entry) {
                decryptedEntries.append(decryptedEntry)
                logger.info("Successfully decrypted the diary entry with id '\(entry.id, privacy: .private)'")
            } else {
                logger.critical("Couldn't decrypt the diary entry with id '\(entry.id, privacy: .private)'")
            }
        }
        
        if encrypted_entries.count == decryptedEntries.count {
            logger.info("Successfully decrypted all diary entries")
        } else if encrypted_entries.count > 0 && decryptedEntries.count == 0 {
            logger.critical("Couldn't decrypt all diary entries")
        } else {
            logger.critical("Some diary entries were decrypted, other's not")
        }
        
        return decryptedEntries
    }
}
