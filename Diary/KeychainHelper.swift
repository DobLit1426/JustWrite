//
//  KeychainHelper.swift
//  Diary
//
//  Created by Dobromir Litvinov on 21.09.2023.
//

import Foundation
import Security
import CryptoKit
import os


/// Used to do save, retrieve and delete the symmetric key in System Keychain
class KeychainHelper {
    /// Service name for the keychain item
    private static let serviceName = "JustWriteApp"
    /// Logger instance
    private static let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "KeychainHelper")

    
    /// Saves the provided symmetric key in the System Keychain after deleting all items from there
    /// - Parameter key: The SymmetricKey that must be saved
    static func saveSymmetricKey(_ key: SymmetricKey) {
        logger.info("Starting function to save a symmetric key...")
        
        do {
            logger.info("Converting key to keyData...")
            let keyData = key.withUnsafeBytes { Data($0) }
            logger.info("Successfully converted key to keyData")
            
            var query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecValueData as String: keyData
            ]
            

            if FileManager.default.ubiquityIdentityToken != nil {
                logger.info("iCloud Keychain is avalaible, using it")
                query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            } else {
                logger.warning("iCloud Keychain is unavalaible, using the Local Keychain")
                query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
            }
            
            
            SecItemDelete(query as CFDictionary)
            
            logger.info("Adding new key...")
            let status = SecItemAdd(query as CFDictionary, nil)
            logger.info("Successfully added new key...")
            if status != errSecSuccess {
                throw KeychainError.unhandledError(status: status)
            }
            
            logger.info("Successfully saved symmetric key")
        } catch {
            logger.critical("Couldn't save symmetric key")
        }
    }

    private static func retrieveSymmetricKey() -> SymmetricKey? {
        let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "KeychainHelper")
        do {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName,
                kSecReturnData as String: true
            ]
            
            // Try to fetch the key from the Keychain
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            if status == errSecSuccess {
                if let keyData = item as? Data {
                    // Convert Data to SymmetricKey
                    let symmetricKey = SymmetricKey(data: keyData)
                    return symmetricKey
                } else {
                    throw KeychainError.unexpectedPasswordData
                }
            } else if status == errSecItemNotFound {
                // Item not found in the Keychain
                return nil
            } else {
                throw KeychainError.unhandledError(status: status)
            }
        } catch {
            logger.critical("Got error while trying to retrieve the symmetric key")
            return nil
        }
        
    }

    // Delete the symmetric key from the Keychain
    private static func deleteSymmetricKey() {
        let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "KeychainHelper")
        logger.info("Starting function to delete saved symmetric key")
        
        do {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: serviceName
            ]
            
            // Delete the item from the Keychain
            let status = SecItemDelete(query as CFDictionary)
            
            if status != errSecSuccess && status != errSecItemNotFound {
                throw KeychainError.unhandledError(status: status)
            }
            logger.info("Successfully deleted saved symmetric key")
        } catch {
            logger.critical("Got error while trying to delete saved symmetric key")
        }
    }
    
    public static func getSymmetricKey() -> SymmetricKey {
        let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "KeychainHelper")
        
        logger.info("Starting function to get the symmetric key")
        
        if let savedKey = KeychainHelper.retrieveSymmetricKey() {
            logger.info("Successfully retrieved the saved symmetric key")
            return savedKey
        }
        
        logger.warning("No saved symmetric key was found, generating a new one...")
        
        let randomKey = KeychainHelper.generateSymmetricKey()
        
        logger.info("Successfully generated new symmetric key")
        
        saveSymmetricKey(randomKey)
        
        return randomKey
    }
    
    private static func generateSymmetricKey() -> SymmetricKey {
        let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "KeychainHelper")
        
        logger.info("Starting function to generate a random symmetric key")
        
        let key = SymmetricKey(size: .bits256)
        
        logger.info("Successfully generated a random symmetric key")
        
        return key
    }
}
