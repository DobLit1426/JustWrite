//
//  AuthenticationViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 26.09.2023.
//

import Foundation
import LocalAuthentication
import os

/// ViewModel of AuthenticationView
class AuthenticationViewModel: ObservableObject {
    /// Logger instance
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "AuthenticationViewModel")
    
    // MARK: - LAContext
    /// Local authentication context
    private let context: LAContext
    
    // MARK: - @Published variables
    @Published var deviceSupportsAuthentication: Bool
    
    // MARK: - Computed properties
    var deviceSupportsFaceId: Bool { context.biometryType == .faceID }
    var deviceSupportsTouchId: Bool { context.biometryType == .touchID }
    var deviceSupportsOpticId: Bool { context.biometryType == .opticID }
    
    // MARK: - Localized Text
    /// This string will be shown in the system alert, which will promt the user to unlock the device with the avalailable biometric authentication mechanism
    var biometricDataUsageReason: String {
        if deviceSupportsFaceId {
            return String(localized: "Reason for FaceID usage", comment: "This string will be shown in the system alert, which will promt the user to unlock the device with FaceID")
        } else if deviceSupportsTouchId {
            return String(localized: "Reason for TouchID usage", comment: "This string will be shown in the system alert, which will promt the user to unlock the device with TouchID")
        } else if deviceSupportsOpticId {
            return String(localized: "Reason for OpticID usage", comment: "This string will be shown in the system alert, which will promt the user to unlock the device with OpticID")
        } else {
            return String(localized: "Reason for device password usage", comment: "This string will be shown in the system alert, which will promt the user to unlock the device with device passcode")
        }
    }
    
    var biometricAuthenticationTypeString: String {
        if deviceSupportsFaceId {
            return "FaceID"
        } else if deviceSupportsOpticId {
            return "OpticID"
        } else if deviceSupportsTouchId {
            return "TouchID"
        } else {
            return "None"
        }
    }
    
    /// This text will be presented if the app is locked
    let lockedText: String = String(localized: "Locked text", defaultValue: "The app is locked", comment: "This text will be presented if the app is locked.")
    
    // MARK: - Init
    /// Initialises the viewModel by checking whether the device can evaluate authentication policy
    init(localAuthenticationContext: LAContext) {
        logger.info("Starting initialising AuthenticationViewModel...")
        
        self.context = localAuthenticationContext
        
        var error: NSError?
        deviceSupportsAuthentication = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        logger.info("Successfully initialised AuthenticationViewModel")
    }
}
