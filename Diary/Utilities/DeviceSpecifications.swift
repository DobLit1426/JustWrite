//
//  DeviceSpecifications.swift
//  Diary
//
//  Created by Dobromir Litvinov on 19.09.2023.
//

import Foundation
import LocalAuthentication

#if canImport(UIKit)
import UIKit
#endif

/// Describes the specifications of the device the app is running on
final class DeviceSpecifications {
    /// The type of the device the app is running on
    static var deviceType: DeviceType {
        #if canImport(UIKit)
            switch UIDevice.current.userInterfaceIdiom {
            case .pad: return DeviceType.iPad
            case .phone: return DeviceType.iPhone
            case .mac: return DeviceType.mac
            case .tv: return DeviceType.tv
            case .vision: return DeviceType.vision
            default: return DeviceType.unknownDevice
            }
        #else
            return DeviceType.mac
        #endif
    }
    
    /// Is the app running on iPad
    static var isIPad: Bool { DeviceSpecifications.deviceType == .iPad }
    
    /// Is the app running on iPhone
    static var isIPhone: Bool { DeviceSpecifications.deviceType == .iPhone }
    
    /// Is the app running on MacOS
    static var isMac: Bool { DeviceSpecifications.deviceType == .mac }
    
    /// Is the app running on Apple TV
    static var isTV: Bool { DeviceSpecifications.deviceType == .tv }
    
    /// Is the app running on an VisionPro
    static var isVision: Bool { DeviceSpecifications.deviceType == .vision }
    
    /// Does the device supports FaceID authentication
    static var supportsFaceID: Bool {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if context.biometryType == .faceID {
                return true
            }
        }
        
        return false
    }
    
    /// Does the device supports TouchID authentication
    static var supportsTouchID: Bool {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if context.biometryType == .touchID {
                return true
            }
        }
        
        return false
    }
    
    /// Does the device supports OpticID authentication
    static var supportsOpticID: Bool {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if context.biometryType == .opticID {
                return true
            }
        }
        
        return false
    }
}
