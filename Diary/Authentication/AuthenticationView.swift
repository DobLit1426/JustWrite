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
    let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "AuthenticationView")
    
    @Binding var isUnlocked: Bool
    var viewModel: AuthenticationViewModel
    
    @Environment(\.modelContext) private var swiftDataContext
    @Query private var settings: [Settings]
    
    private let localAuthenticationContext: LAContext = LAContext()
    
    private let lockedText: String = String(localized: "Locked text", defaultValue: "The app is locked", comment: "This text will be presented if the app is locked.")
    
    init(isUnlocked: Binding<Bool>) {
        logger.info("Initialising AuthenticationView...")
        self._isUnlocked = isUnlocked
        self.viewModel = AuthenticationViewModel(localAuthenticationContext: localAuthenticationContext)
        logger.info("Successfully initialised AuthenticationView")
    }
    
    var body: some View {
        VStack {
            Image(systemName: isUnlocked ? "lock.open" : "lock")
                .contentTransition(.symbolEffect(.replace.downUp.wholeSymbol, options: .nonRepeating))
                .padding(.bottom, 5)
            Text(lockedText)
                .padding()
            Spacer()
            
            Button {
                logger.info("Unlock button pressed")
                authenticate()
            } label: {
                Text(AuthenticationHelper(localAuthenticationContext: localAuthenticationContext).unlockWithBiometryButtonText)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .onAppear {
            logger.info("AuthenticationView appeared.")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                logger.info("Authentication function on View appear ended")
                authenticate()
            }
        }
        .padding()
    }
    
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
    
    private func authenticationSuccess() {
        logger.warning("Successfully authenticated.")
        isUnlocked = true
    }
    
    private func authenticationFailed() {
        logger.warning("Authentication failed.")
    }
}

#Preview {
    @State var isUnlocked: Bool = false
    return AuthenticationView(isUnlocked: $isUnlocked)
}


//struct AuthenticationView: View {
//    private let context = LAContext()
//    @Environment(\.modelContext) private var swiftDataContext
//    @Query private var settings: [Settings]
//    
//    private let lockedText: String = String(localized: "Locked text", defaultValue: "The app is locked", comment: "This text will be presented if the app is locked.")
//    
//    var viewModel: AuthenticationViewModel
//    
//    private var lockedScreenAnimation: Animation? { isUnlocked ? Animation.easeInOut(duration: 0.5) : nil }
//    
//    @Binding var currentView: CurrentView
//    
//    private var isUnlocked: Bool {
//        return currentView == .diary
//    }
//    
//    init(currentView: Binding<CurrentView>) {
//        _currentView = currentView
//        viewModel = AuthenticationViewModel(settings: [])
//    }
//    
//    var body: some View {
//        lockedScreen
//            .opacity(isUnlocked ? 0 : 1)
//            .animation(lockedScreenAnimation, value: isUnlocked)
//            .transition(.opacity)
//            .disabled(isUnlocked)
//        
//    }
//    
//    var lockedScreen: some View {
//        VStack {
//            Image(systemName: isUnlocked ? "lock.open" : "lock")
//                .contentTransition(.symbolEffect(.replace.downUp.wholeSymbol, options: .nonRepeating))
//                .padding(.bottom, 5)
//            Text(lockedText)
//                .padding()
//            Spacer()
//            
//            Button {
//                authenticate()
//            } label: {
//                Text(viewModel.unlockButtonText)
//            }
//            .buttonStyle(PrimaryButtonStyle())
//        }
//        .onAppear {
//            withAnimation {
//                authenticate()
//            }
//        }
//    }
//    
//    private func authenticate() {
//        if settings[0].authenticateWithBiometricData && viewModel.deviceSupportsBiometricAuthentication {
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: viewModel.biometricDataUsageReason) { success, authenticationError in
//                if success {
//                    unlock()
//                } else {
//                    print("Couldn't unlock the app using biometric authentication. Error: \(authenticationError?.localizedDescription ?? "None")")
//                }
//            }
//        } else {
//            print("No biometric authentication available, FaceID/TouchID/OpticID doesn't work.")
//            unlock()
//        }
//    }
//    
//    private func unlock() {
//        currentView = .diary
//    }
//}
//
//#Preview {
//    @State var currentView: CurrentView = .authenticationView
//    return AuthenticationView(currentView: $currentView)
//}
