//
//  EncryptedDiaryEntry.swift
//  Diary
//
//  Created by Dobromir Litvinov on 20.09.2023.
//

import Foundation
import SwiftData

@Model
/// Represents an encrypted DiaryEntry
final class EncryptedDiaryEntry {
    //MARK: - Properties
    var encrypted_data: Data
    @Attribute(.unique) var id: UUID
    
    //MARK: - Init
    /// Initialises EncryptedDiaryEntry
    /// - Parameters:
    ///   - encrypted_data: The encrypted data of DiaryEntry
    ///   - id: The ID of the encrypted diary entry
    init(encrypted_data: Data, id: UUID) {
        self.encrypted_data = encrypted_data
        self.id = id
    }
}
