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
import SwiftData

class SettingsViewModel: ObservableObject {
    /// Logger instance
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "SettingsViewModel")
    
    private let localAuthenticationContext: LAContext = LAContext()
    private let authenticationHelper: AuthenticationHelper
    
    var settings: [Settings]
    var settingsObject: Settings { Settings(authenticateWithBiometricData: self.authenticateWithBiometricData, deleteProfileWhenInactiveFor: self.deleteEverythingAfterBeingInactiveFor) }
    
    init(settings: [Settings] = [], determineSettingsObject: Bool = true) {
        logger.info("Initialising SettingsViewModel...")
        
        localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        self.authenticationHelper = AuthenticationHelper(localAuthenticationContext: localAuthenticationContext)
        
        self.settings = settings
        
        if determineSettingsObject {
            logger.info("determineSettingsObject is true, checking settings' count...")
            
            checkCountOfSettingsObject(settings: settings)
            
            let settingsObject = determineTheSettingsObject(settings: settings)
            self.authenticateWithBiometricData = settingsObject.authenticateWithBiometricData
            self.deleteEverythingAfterBeingInactiveFor = settingsObject.deleteProfileWhenInactiveFor
        } else {
            logger.info("determineSettingsObject is false, the settings' count won't be checked and the setting's object will be set to a default value.")
            let settingsObject = Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff)
            self.authenticateWithBiometricData = settingsObject.authenticateWithBiometricData
            self.deleteEverythingAfterBeingInactiveFor = settingsObject.deleteProfileWhenInactiveFor
        }
        
        logger.info("Successfully initialised SettingsViewModel.")
    }
    
    private func checkCountOfSettingsObject(settings: [Settings]) {
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
    
    private func determineTheSettingsObject(settings: [Settings]) -> Settings {
        logger.info("Starting function to determine the settings object.")
        
        var settingsObject: Settings = Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff)
        
        switch settings.count {
        case 0:
            logger.critical("No settings objects found, returning default value.")
            settingsObject = Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff)
        case 1:
            logger.info("One settings object found, returning the found settings object.")
            settingsObject = settings[0]
        default:
            logger.critical("Multiple settings objects found, setting the settings object to Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff) .")
            settingsObject = Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff)
        }
        
        return settingsObject
    }
    
    
    @Published var authenticateWithBiometricData: Bool = false
    @Published var deleteEverythingAfterBeingInactiveFor: DeleteUserProfileAfterBeingInactiveFor = .turnedOff

    
    func setSettingsObject(basedOn settings: [Settings]) {
        let settingsObject = determineTheSettingsObject(settings: settings)
        self.deleteEverythingAfterBeingInactiveFor = settingsObject.deleteProfileWhenInactiveFor
        self.authenticateWithBiometricData = settingsObject.authenticateWithBiometricData
    }
    
    
    
    public var deviceSupportsBiometricAuthentication: Bool { authenticationHelper.deviceSupportsBiometricAuthentication }
    public var biometricAuthenticationTypeString: String { authenticationHelper.biometricAuthenticationTypeString }
    public var deviceSupportsBiometricAuthenticationButItIsNotSetUp: Bool { authenticationHelper.deviceSupportsBiometricAuthenticationButItIsNotSetUp }
}
