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

enum DeviceType {
    case iPad
    case iPhone
    case vision
    case mac
    case tv
    case unknownDevice
}

final class DeviceSpecifications {
    static var deviceType: DeviceType {
        #if canImport(UIKit)
            switch UIDevice.current.userInterfaceIdiom {
            case .pad: return .iPad
            case .phone: return .iPhone
            case .mac: return .mac
            case .tv: return .tv
            case .vision: return .vision
            default: return .unknownDevice
            }
        #else
            return .mac
        #endif
    }
    
    static var isIPad: Bool { DeviceSpecifications.deviceType == .pad }
    
    static var isIPhone: Bool { DeviceSpecifications.deviceType == .iPhone }
    
    static var isMac: Bool { DeviceSpecifications.deviceType == .mac }
    
    static var isTV: Bool { DeviceSpecifications.deviceType == .tv }
    
    static var isVision: Bool { DeviceSpecifications.deviceType == .vision }
    
    static var supportsFaceID: Bool {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if context.biometryType == .faceID {
                return true
            }
        }
        
        return false
    }
    
    static var supportsTouchID: Bool {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if context.biometryType == .touchID {
                return true
            }
        }
        
        return false
    }
    
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
