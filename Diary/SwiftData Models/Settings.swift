//
//  UserProfileSettings.swift
//  Diary
//
//  Created by Dobromir Litvinov on 10.09.2023.
//

import Foundation
import SwiftData

@Model
final class Settings {
    // Variables
    var authenticateWithBiometricData: Bool
    var deleteProfileWhenInactiveFor: DeleteUserProfileAfterBeingInactiveFor
    
    
    // Init
    init(authenticateWithBiometricData: Bool,
         deleteProfileWhenInactiveFor: DeleteUserProfileAfterBeingInactiveFor) {
        self.authenticateWithBiometricData = authenticateWithBiometricData
        self.deleteProfileWhenInactiveFor = deleteProfileWhenInactiveFor
    }
}
