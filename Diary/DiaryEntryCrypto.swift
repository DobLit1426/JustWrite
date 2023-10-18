//
//  DiaryEntryCrypto.swift
//  Diary
//
//  Created by Dobromir Litvinov on 20.09.2023.
//

import Foundation
import CryptoKit
import os

/// Responsible for any cryptographic manipulations with DiaryEntry
struct DiaryEntryCrypto {
    /// Logger instance
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "DiaryEntryCrypto")
    
    // MARK: - Properties
    /// The symmetric key to encrypt and decrypt DiaryEntry with
    let key: SymmetricKey
    
    // MARK: - Init
    /// Initialises DiaryEntryCrypto by setting the key property
    /// - Parameter key: The symmetric key to encrypt and decrypt DiaryEntry with. If nil, then the key will be set using KeychainHelper.getSymmetricKey()
    init(key: SymmetricKey? = nil) {
        logger.info("Starting to initialise DiaryEntryCrypto")
        
        if let key {
            logger.warning("The symmetric key was provided, using it")
            self.key = key
        } else {
            logger.warning("The symmetric key wasn't provided, using KeychainHelper.getSymmetricKey()")
            self.key = KeychainHelper.getSymmetricKey()
        }
        
        logger.info("Successfully initialised DiaryEntryCrypto")
    }
    
    //MARK: - Public functions
    /// Encrypts a single DiaryEntry
    /// - Parameter entry: The diary entry to encrypt
    /// - Returns: If succeeds, the encrypted diary entry, otherwise nil
    public func encryptEntry(_ entry: DiaryEntry) -> EncryptedDiaryEntry? {
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
    
    
    /// Decrypts a single DiaryEntry
    /// - Parameter entry: The encrypted diary entry to decrypt
    /// - Returns: If succeeds, the decrypted diary entry, otherwise nil
    public func decryptEntry(_ encryptedEntry: EncryptedDiaryEntry) -> DiaryEntry? {
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
    
    
    /// Encrypts array of DiaryEntry
    /// - Parameter entries: The array of DiaryEntry to encrypt
    /// - Returns: If succeeds, the array of EncryptedDiaryEntry, otherwise empty array
    public func encryptEntries(_ entries: [DiaryEntry]) -> [EncryptedDiaryEntry] {
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
    
    
    /// Decrypts array of EncryptedDiaryEntry
    /// - Parameter encrypted_entries: The array of EncryptedDiaryEntry to decrypt
    /// - Returns: If succeeds, the array of DiaryEntry, otherwise empty array
    public func decryptEntries(_ encrypted_entries: [EncryptedDiaryEntry]) -> [DiaryEntry] {
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
