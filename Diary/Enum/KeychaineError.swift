//
//  KeychaineError.swift
//  Diary
//
//  Created by Dobromir Litvinov on 14.10.2023.
//

import Foundation

/// Used to specify types of errors that can occur during keychain operations
enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
