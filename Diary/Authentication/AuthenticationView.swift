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

struct AuthenticationView: View {
    /// Logger instance
    let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "AuthenticationView")
    
    // MARK: - @Environment variables
    @Environment(\.modelContext) private var swiftDataContext
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - @Query variables
    /// Settings objects fetched and automatically updated by SwiftData
    @Query private var settings: [Settings]
    
    // MARK: - @Binding variables
    /// Variable that controls whether the app is unlocked
    @Binding var isUnlocked: Bool
    
    // MARK: - ViewModel
    /// View model of this View
    @ObservedObject var viewModel: AuthenticationViewModel
    
    // MARK: - Computed properties
    /// Background color of this View
    var backgroundStyle: Color { colorScheme == .light ? .white : .black }
    
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
                .foregroundStyle(backgroundStyle)
            
            VStack {
                Image(systemName: isUnlocked ? "lock.open" : "lock")
                    .contentTransition(.symbolEffect(.replace.downUp.wholeSymbol, options: .nonRepeating))
                    .padding(.bottom, 5)
                Text(viewModel.lockedText)
                    .padding()
                Spacer()
                
                Button {
                    unlockButtonPressed()
                } label: {
                    Text(AuthenticationHelper(localAuthenticationContext: localAuthenticationContext).unlockWithBiometryButtonText)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .onAppear {
                onAppear()
            }
            .padding()
        }
    }
    
    // MARK: - Functions
    /// Starts authentication and takes actions based on whether it was success or failure
    func authenticate() {
        logger.info("Starting authentication function")
        
        guard viewModel.deviceSupportsAuthentication else {
            logger.critical("Device doesn't support authentication, but the authenticate() function is called.")
            logger.critical("Unlocking diary because no authentication methods are avalailable.")
            
            authenticationSuccess()
            return
        }
        
        localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: viewModel.biometricDataUsageReason) { success, authenticationError in
            if success {
                logger.info("Successfully authenticated")
                authenticationSuccess()
            } else {
                logger.warning("Authentication failed. Authentication error: \(authenticationError)")
                authenticationFailed()
            }
        }
    }
    
    /// Called when authentication is successfull
    func authenticationSuccess() {
        logger.warning("Successfully authenticated.")
        isUnlocked = true
    }
    
    /// Called when authentication fails
    func authenticationFailed() {
        logger.warning("Authentication failed.")
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
    return AuthenticationView(isUnlocked: .constant(true))
}
