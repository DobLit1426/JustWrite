//
//  SettingsViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 27.09.2023.
//

import Foundation
import os
import SwiftUI
import LocalAuthentication

class SettingsViewModel: ObservableObject {
    private let logger: Logger = SettingsViewModel.logger
    private static let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "SettingsViewModel")
    private let localAuthenticationContext: LAContext = LAContext()
    private let authenticationHelper: AuthenticationHelper
    
    var settings: [Settings]
    @Published var settingsObject: Settings
    
    init(settings: [Settings] = [], determineSettingsObject: Bool = true) {
        logger.info("Initialising SettingsViewModel...")
        
        localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        self.authenticationHelper = AuthenticationHelper(localAuthenticationContext: localAuthenticationContext)
        
        self.settings = settings
        
        if determineSettingsObject {
            logger.info("determineSettingsObject is true, checking settings' count...")
            SettingsViewModel.checkCountOfSettingsObject(settings: settings)
            self.settingsObject = SettingsViewModel.determineTheSettingsObject(settings: settings)
            self.authenticateWithBiometricDataValue = settingsObject.authenticateWithBiometricData
            self.deleteEverythingAfterBeingInactiveForValue = settingsObject.deleteProfileWhenInactiveFor
        } else {
            logger.info("determineSettingsObject is false, the settings' count won't be checked and the setting's object will be set to a default value.")
            self.settingsObject = Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff)
        }
        
        logger.info("Successfully initialised SettingsViewModel.")
    }
    
    private static func checkCountOfSettingsObject(settings: [Settings]) {
        logger.info("Starting function to check settings' count.")
        
        switch settings.count {
        case 0:
            logger.critical("No settings objects found")
        case 1:
            logger.info("One settings object found")
        default:
            logger.critical("Multiple settings objects found")
        }
        
        logger.info("Successfully checked the settings' count.")
    }
    
    private static func determineTheSettingsObject(settings: [Settings]) -> Settings {
        logger.info("Starting function to determine the settings object.")
        
        var settingsObject: Settings = Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff)
        
        switch settings.count {
        case 0:
            logger.critical("No settings objects found, setting the settings object to Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff) .")
            settingsObject = Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff)
        case 1:
            logger.info("One settings object found, setting the settings object to the found object.")
            settingsObject = settings[0]
        default:
            logger.critical("Multiple settings objects found, setting the settings object to Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff) .")
            settingsObject = Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff)
        }
        
        return settingsObject
    }
    
    
    @Published var authenticateWithBiometricDataValue: Bool = false
    var authenticateWithBiometricData: Binding<Bool> {
        return Binding(
            get: { self.authenticateWithBiometricDataValue },
            set: { newValue in
                self.settingsObject.authenticateWithBiometricData = newValue
                self.authenticateWithBiometricDataValue = newValue
            }
        )
    }
    
    @Published var deleteEverythingAfterBeingInactiveForValue: DeleteUserProfileAfterBeingInactiveFor = .turnedOff
    var deleteEverythingAfterBeingInactiveFor: Binding<DeleteUserProfileAfterBeingInactiveFor> {
        return Binding(
            get: { self.deleteEverythingAfterBeingInactiveForValue },
            set: { newValue in
                self.settingsObject.deleteProfileWhenInactiveFor = newValue
                self.deleteEverythingAfterBeingInactiveForValue = newValue
            }
        )
    }
    
    func setSettingsObject(basedOn settings: [Settings]) {
        settingsObject = SettingsViewModel.determineTheSettingsObject(settings: settings)
        self.deleteEverythingAfterBeingInactiveForValue = settingsObject.deleteProfileWhenInactiveFor
        self.authenticateWithBiometricDataValue = settingsObject.authenticateWithBiometricData
    }
    
    public var deviceSupportsBiometricAuthentication: Bool { authenticationHelper.deviceSupportsBiometricAuthentication }
    public var biometricAuthenticationTypeString: String { authenticationHelper.biometricAuthenticationTypeString }
    public var deviceSupportsBiometricAuthenticationButItIsNotSetUp: Bool { authenticationHelper.deviceSupportsBiometricAuthenticationButItIsNotSetUp }
}
