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
