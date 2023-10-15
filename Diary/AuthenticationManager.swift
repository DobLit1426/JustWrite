//
//  AuthenticationManager.swift
//  Diary
//
//  Created by Dobromir Litvinov on 16.09.2023.
//

import Foundation
import LocalAuthentication
import os

fileprivate enum AuthenticationType {
    case biometricDataOnly
    case biometricDataOrDevicePasscode
}

class AuthenticationManager {
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "AuthenticationHelper")
    
    init(settings: [Settings]) {
        logger.info("Initialising AuthenticationManager...")
        var error: NSError?
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        logger.info("AuthenticationManager successfully initialised")
    }
    
    private var context = LAContext()
    
    var deviceSupportsFaceId: Bool { context.biometryType == .faceID }
    var deviceSupportsTouchId: Bool { context.biometryType == .touchID }
    var deviceSupportsOpticId: Bool { context.biometryType == .opticID }
    
    var deviceSupportsBiometricAuthentication: Bool {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            logger.info("Device supports biometric authentication")
            return true
        } else {
            logger.info("Device doesn't support biometric authentication")
            return false
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
    
    var biometricAuthenticationSystemImageName: String {
        if deviceSupportsFaceId {
            return "faceid"
        } else if deviceSupportsOpticId {
            return "opticid"
        } else if deviceSupportsTouchId {
            return "touchid"
        } else {
            return "None"
        }
    }
        
    var biometricDataUsageReason: String {
        if deviceSupportsFaceId {
            return String(localized: "Reason for FaceID usage", comment: "This string will be shown in the system alert, which will promt the user to unlock the device with FaceID")
        } else if deviceSupportsTouchId {
            return String(localized: "Reason for TouchID usage", comment: "This string will be shown in the system alert, which will promt the user to unlock the device with TouchID")
        } else if deviceSupportsOpticId {
            return String(localized: "Reason for OpticID usage", comment: "This string will be shown in the system alert, which will promt the user to unlock the device with OpticID")
        } else {
            logger.critical("Device doesn't support FaceID/TouchID/OpticID, but the biometricDataUsageReason property is accessed. Returning 'None'")
            return "None"
        }
    }
    
    var unlockButtonText: String {
        let deviceSupportsFaceId = context.biometryType == .faceID
        let deviceSupportsTouchId = context.biometryType == .touchID
        let deviceSupportsOpticId = context.biometryType == .opticID
        
        if deviceSupportsFaceId {
            return String(localized: "Unlock with FaceID button text", defaultValue: "Unlock with FaceID", comment: "This text will be presented on the button that is used to unlock the app using FaceID")
        } else if deviceSupportsTouchId {
            return String(localized: "Unlock with TouchID button text", defaultValue: "Unlock with TouchID", comment: "This text will be presented on the button that is used to unlock the app using TouchID")
        } else if deviceSupportsOpticId {
            return String(localized: "Unlock with OpticID button text", defaultValue: "Unlock with OpticID", comment: "This text will be presented on the button that is used to unlock the app using OpticID")
        } else {
            logger.critical("Device doesn't support FaceID/TouchID/OpticID, but the unlockButtonText property is accessed. Returning 'None'")
            return "None"
        }
    }
    
    var deviceSupportsBiometricAuthenticationButItIsNotSetUp: Bool {
        biometricAuthenticationTypeString != "None"
    }
}
