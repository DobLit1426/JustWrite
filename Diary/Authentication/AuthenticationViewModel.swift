//
//  AuthenticationViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 26.09.2023.
//

import Foundation
import LocalAuthentication
import os

struct AuthenticationViewModel {
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "AuthenticationViewModel")
    private let context: LAContext
    
    var deviceSupportsAuthentication: Bool
    
    init(localAuthenticationContext: LAContext) {
        logger.info("Starting initialising AuthenticationViewModel...")
        
        self.context = localAuthenticationContext
        
        var error: NSError?
        context.localizedCancelTitle = "Don't unlock the app"
        deviceSupportsAuthentication = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        logger.info("Successfully initialised AuthenticationViewModel")
    }
    
    var deviceSupportsFaceId: Bool { context.biometryType == .faceID }
    var deviceSupportsTouchId: Bool { context.biometryType == .touchID }
    var deviceSupportsOpticId: Bool { context.biometryType == .opticID }
    
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
    
    let lockedText: String = String(localized: "Locked text", defaultValue: "The app is locked", comment: "This text will be presented if the app is locked.")
}
