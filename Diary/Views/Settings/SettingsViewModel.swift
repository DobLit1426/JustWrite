//
//  SettingsViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 27.09.2023.
//

import Foundation
import SwiftUI
import LocalAuthentication
import SwiftData

class SettingsViewModel: ObservableObject {
    /// Logger instance
    private let logger: AppLogger = AppLogger(category: "SettingsViewModel")
    
    private let settingsObjectDefaultValue: Settings = Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff)
    
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
            setSettings(basedOn: settingsObject)
        } else {
            logger.info("determineSettingsObject is false, the settings' count won't be checked and the setting's object will be set to a default value.")
            let settingsObject = settingsObjectDefaultValue
            setSettings(basedOn: settingsObject)
        }
        
        logger.info("Successfully initialised SettingsViewModel.")
    }
    
    private func checkCountOfSettingsObject(settings: [Settings]) {
        logger.info("Starting function to check settings' count.")
        
        switch settings.count {
        case 0:
            logger.critical("No settings objects found", sendReport: .no)
        case 1:
            logger.info("One settings object found")
        default:
            logger.critical("Multiple settings objects found", sendReport: .no)
        }
        
        logger.info("Successfully checked the settings' count.")
    }
    
    private func determineTheSettingsObject(settings: [Settings]) -> Settings {
        logger.info("Starting function to determine the settings object.")
        
        
        let settingsObjectDefaultValue: Settings = Settings(authenticateWithBiometricData: false, deleteProfileWhenInactiveFor: .turnedOff)
        var settingsObject: Settings = settingsObjectDefaultValue
        
        switch settings.count {
        case 0:
            logger.critical("No settings objects found, returning default value.", sendReport: .no)
        case 1:
            logger.info("One settings object found, returning the found settings object.")
            settingsObject = settings[0]
        default:
            logger.critical("Multiple settings objects found, returning default value.", sendReport: .no)
        }
        
        return settingsObject
    }
    
    
    @Published var authenticateWithBiometricData: Bool = false
    @Published var deleteEverythingAfterBeingInactiveFor: DeleteEntriesAfterBeingInactiveFor = .turnedOff
    
    func setSettingsObject(basedOn settings: [Settings]) {
        let settingsObject = determineTheSettingsObject(settings: settings)
        setSettings(basedOn: settingsObject)
    }
    
    private func setSettings(basedOn settingsObject: Settings) {
        self.deleteEverythingAfterBeingInactiveFor = settingsObject.deleteProfileWhenInactiveFor
        self.authenticateWithBiometricData = settingsObject.authenticateWithBiometricData
    }
    
    
    
    public var deviceSupportsBiometricAuthentication: Bool { authenticationHelper.deviceSupportsBiometricAuthentication }
    public var biometricAuthenticationTypeString: String { authenticationHelper.biometricAuthenticationTypeString }
    public var deviceSupportsBiometricAuthenticationButItIsNotSetUp: Bool { authenticationHelper.deviceSupportsBiometricAuthenticationButItIsNotSetUp }
}
