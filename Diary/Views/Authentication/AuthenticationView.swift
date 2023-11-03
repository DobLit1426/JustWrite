//
//  AuthenticationView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 10.09.2023.
//

import SwiftUI
import SwiftData
import LocalAuthentication
import os

fileprivate struct LocalizedStrings {
    static var appLockedTitle = String(localized: "App locked", defaultValue: "App locked", comment: "This text will be shown as a title on the locked screen")
    
    static func biometricDataUsageReason(biometryType: LABiometryType) -> String {
        let reasonForPasscodeUsage: String = String(localized: "Reason for device password usage", comment: "This string will be shown in the system alert, which will promt the user to unlock the device with device passcode")
        let reasonForTouchIdUsage: String = String(localized: "Reason for TouchID usage", comment: "This string will be shown in the system alert, which will promt the user to unlock the device with TouchID")
        let reasonForFaceIdUsage: String = String(localized: "Reason for FaceID usage", comment: "This string will be shown in the system alert, which will promt the user to unlock the device with FaceID")
        let reasonForOpticIdUsage: String = String(localized: "Reason for OpticID usage", comment: "This string will be shown in the system alert, which will promt the user to unlock the device with OpticID")
        
        switch biometryType {
        case .none:
            return reasonForPasscodeUsage
        case .touchID:
            return reasonForTouchIdUsage
        case .faceID:
            return reasonForFaceIdUsage
        case .opticID:
            return reasonForOpticIdUsage
        default:
            return reasonForPasscodeUsage
        }
    }
    
    static func biometricDataAsString(biometryType: LABiometryType) -> String {
        switch biometryType {
        case .none:
            return "None"
        case .touchID:
            return "TouchID"
        case .faceID:
            return "FaceID"
        case .opticID:
            return "OpticID"
        default:
            return "None"
        }
    }
}

struct AuthenticationView: View {
    // MARK: - Logger
    /// Logger instance
    let logger: AppLogger = AppLogger(subsystem: ".com.diaryApp", category: "AuthenticationView")
    
    // MARK: - @Environment variables
    @Environment(\.modelContext) private var swiftDataContext
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: - @Query variables
    /// Settings objects fetched and automatically updated by SwiftData
    @Query private var settings: [Settings]
    
    // MARK: - @Binding variables
    /// Variable that controls whether the app is unlocked
    @Binding var isUnlocked: Bool
    
    // MARK: - ViewModel
    /// View model of this View
    @ObservedObject var viewModel: AuthenticationViewModel
    
    // MARK: - LAContext
    private let localAuthenticationContext: LAContext = LAContext()
    
    // MARK: - Init
    /// Init
    /// - Parameter isUnlocked: Will be set to true when the authentication is successfull
    /// - Important: isUnlocked must be set to false, otherwise it will be hard to tell when the authentication is done and was successfull
    init(isUnlocked: Binding<Bool>) {
        logger.info("Initialising AuthenticationView...")
        
        self._isUnlocked = isUnlocked
        self.viewModel = AuthenticationViewModel(localAuthenticationContext: localAuthenticationContext)
        
        logger.info("Successfully initialised AuthenticationView")
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea(edges: .all)
                .foregroundStyle(colorScheme == .dark ? Color.black : Color.white)
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    VStack {
                        HStack {
                            Spacer()
                            LockSymbol()
                            Spacer()
                        }
                        Text(LocalizedStrings.appLockedTitle)
                            .font(.title)
                            .padding()
                        Text("Open app with \(LocalizedStrings.biometricDataAsString(biometryType: localAuthenticationContext.biometryType))", comment: "This text will be shown under the title on the locked screen")
                            .font(.title2)
                    }
                    .frame(height: geometry.size.height * 1/3)
                    Spacer()
                    
                    Button {
                        unlockButtonPressed()
                    } label: {
                        Text(AuthenticationHelper(localAuthenticationContext: localAuthenticationContext).unlockWithBiometryButtonText)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .onAppear { onAppear() }
                .padding()
            }
        }
    }
    
    // MARK: - Functions
    /// Starts authentication and takes actions based on whether it was success or failure
    func authenticate() {
        logger.info("Starting authentication function")
        
        guard viewModel.deviceSupportsAuthentication else {
            logger.critical("Device doesn't support authentication, but the authenticate() function is called. Unlocking diary because no authentication methods are avalailable.")
            
            authenticationSuccess()
            return
        }
        
        localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: LocalizedStrings.biometricDataUsageReason(biometryType: localAuthenticationContext.biometryType)) { success, authenticationError in
            if success {
                logger.warning("Successfully authenticated", sendReport: .no)
                authenticationSuccess()
            } else {
                var sendReport: SendReportOption = .automatic
                if let authenticationError {
                    let errorCode = (authenticationError as NSError).code
                    // If error code is -1004("Authentication not in foreground") or -4("Authentication cancelled by system"), don't send the report because this errors are known and normal
                    if errorCode == -1004 || errorCode == -4 {
                        sendReport = .no
                    }
                }
                logger.error("Authentication failed. Authentication error: '\(String(describing: authenticationError))'", sendReport: sendReport)
                authenticationFailed()
            }
        }
    }
    
    /// Called when authentication is successfull
    func authenticationSuccess() {
        logger.warning("Successfully authenticated.", sendReport: .no)
        isUnlocked = true
    }
    
    /// Called when authentication fails
    func authenticationFailed() {
        logger.warning("Authentication failed.", sendReport: .no)
    }
    
    /// Called on the appear of the View
    func onAppear() {
        let delay: Double = 0.5
        logger.info("AuthenticationView appeared. Authenticating after \(delay) sec")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            logger.info("\(delay) sec is over, calling authenticating function...")
            authenticate()
            
            logger.info("Authenticating function on appear ended")
        }
    }
    
    /// Called on the press of the unlock button
    func unlockButtonPressed() {
        logger.info("Unlock button pressed, calling authenticating function...")
        authenticate()
        logger.info("Authenticating function on unlock button press ended")
    }
}

#Preview {
    return AuthenticationView(isUnlocked: .constant(false))
}
