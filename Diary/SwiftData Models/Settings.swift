//
//  UserProfileSettings.swift
//  Diary
//
//  Created by Dobromir Litvinov on 10.09.2023.
//

import Foundation
import SwiftData

@Model
/// Represents the user set settings of the app
final class Settings {
    //MARK: - Properties
    /// Describes whether the user should authenticate biometrically when he opens the app
    var authenticateWithBiometricData: Bool
    
    /// Describes after which time should all user data be deleted if the user will be inactive for this time
    var deleteProfileWhenInactiveFor: DeleteUserProfileAfterBeingInactiveFor
    
    //MARK: - Init
    /// Initialises Settings
    /// - Parameters:
    ///   - authenticateWithBiometricData: Describes whether the user should authenticate biometrically when he opens the app
    ///   - deleteProfileWhenInactiveFor: Describes after which time should all user data be deleted if the user will be inactive for this time
    init(authenticateWithBiometricData: Bool,
         deleteProfileWhenInactiveFor: DeleteUserProfileAfterBeingInactiveFor) {
        self.authenticateWithBiometricData = authenticateWithBiometricData
        self.deleteProfileWhenInactiveFor = deleteProfileWhenInactiveFor
    }
    
    //MARK: - Computed properties
    /// Text representation of the class
    var description: String {
        return "Settings(authenticateWithBiometricData: \(self.authenticateWithBiometricData), deleteProfileWhenInactiveFor: \(self.deleteProfileWhenInactiveFor))"
    }
}
