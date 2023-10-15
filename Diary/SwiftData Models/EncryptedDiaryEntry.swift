//
//  EncryptedDiaryEntry.swift
//  Diary
//
//  Created by Dobromir Litvinov on 20.09.2023.
//

import Foundation
import SwiftData

@Model
final class EncryptedDiaryEntry {
    var encrypted_data: Data
    @Attribute(.unique) var id: UUID
    
    init(encrypted_data: Data, id: UUID = UUID()) {
        self.encrypted_data = encrypted_data
        self.id = id
    }
}
