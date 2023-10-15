//
//  AppSetupViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 26.09.2023.
//

import Foundation
import LocalAuthentication
import SwiftData

class Feature: Identifiable {
    let heading: String
    let description: String
    let iconSystemName: String
    
    let showStartingFromIndex: Int
    let showBeforeIndex: Int
    
    init(heading: String, description: String, iconSystemName: String, showStartingFromIndex: Int, showBeforeIndex: Int) {
        self.heading = heading
        self.description = description
        self.iconSystemName = iconSystemName
        self.showStartingFromIndex = showStartingFromIndex
        self.showBeforeIndex = showBeforeIndex
    }
}


class AppSetupViewModel: ObservableObject {
    @Published var appSetupProgress: Int = 1
    var totalNumberOfPages: Int
    
    // Computed properties
    var theFirstPageIsShown: Bool { appSetupProgress == 1 }
    var theLastPageIsShown: Bool { appSetupProgress == totalNumberOfPages }
    
    var continueButtonText: String {
        if theFirstPageIsShown {
            return String(localized: "Tap to continue button text", defaultValue: "Tap to continue", comment: "This is text is presented on button used to begin the app tour/functions guide")
        } else if theLastPageIsShown {
            return String(localized: "Finish setup button text", defaultValue: "Finish setup", comment: "This is text is presented on button used to finish the app setup view")
        } else {
            return String(localized: "Continue button text", defaultValue: "Continue", comment: "This is text is presented on button used to continue the app tour/functions guide")
        }
    }
    
    var skipGuideButtonDisabled: Bool { (appSetupProgress >= 8 || theLastPageIsShown) }
    
    private var localAuthenticationContext = LAContext()
    
    private var deviceSupportsBiometricAuthenticationValue: Bool = false
    var deviceSupportsBiometricAuthentication: Bool {
        return deviceSupportsBiometricAuthenticationValue
    }
    
    private var deviceSupportsFaceId: Bool { DeviceSpecifications.supportsFaceID }
    private var deviceSupportsTouchId: Bool { DeviceSpecifications.supportsTouchID }
    private var deviceSupportsOpticId: Bool { DeviceSpecifications.supportsOpticID }
    
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
    
    private static let beautifulEntriesFeature: Feature = Feature(heading: String(localized: "Beautiful Diary Entries"), description: String(localized: "Write down your daily thoughts, goals, or special moments in an elegant and user-friendly platform."), iconSystemName: "book", showStartingFromIndex: 4, showBeforeIndex: 8)
    private static let privacyFeature: Feature = Feature(heading: String(localized: "Privacy At Your Fingertips"), description: String(localized: "We offer privacy options like password and biometric authentication for your personal thoughts' security."), iconSystemName: "lock.shield", showStartingFromIndex: 5, showBeforeIndex: 8)
    private static let noMarketingDataCollectionFeature: Feature = Feature(heading: String(localized: "No Data Collection, No Ads"), description: String(localized: "Your trust is important to us. JustWrite does not collect or use your data for marketing purposes. Enjoy JustWrite with no ads."), iconSystemName: "checkmark.seal", showStartingFromIndex: 6, showBeforeIndex: 8)
    private static let priceFeature: Feature = Feature(heading: String(localized: "Completely Free"), description: String(localized: "We believe that everyone should have access to a free, safe, and beautiful diary-keeping app."), iconSystemName: "figure.2", showStartingFromIndex: 7, showBeforeIndex: 8)
    
    // Array with features
    static let features: [Feature] = [beautifulEntriesFeature, privacyFeature, noMarketingDataCollectionFeature, priceFeature]
    
    
    init(numberOfPagesIfDeviceSupportsBiometricAuthentication totalNumberOfPagesIfBiometricAuth: Int, numberOfPagesIfDeviceDoesntSupportBiometricAuthentication totalNumberOfPagesIfNoBiometricAuth: Int) {
        self.totalNumberOfPages = 0
        self.totalNumberOfPages = 0
        
        
        var error: NSError?
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.deviceSupportsBiometricAuthenticationValue = true
        }
        
        if deviceSupportsBiometricAuthentication {
            self.totalNumberOfPages = totalNumberOfPagesIfBiometricAuth
        } else {
            self.totalNumberOfPages = totalNumberOfPagesIfNoBiometricAuth
        }
    }
    
    func nextPage() {
        if !theLastPageIsShown {
            appSetupProgress += 1
        }
    }
    
    func skip() {
        appSetupProgress = 8
    }
    
    func previousPage() {
        if !theFirstPageIsShown {
            appSetupProgress -= 1
        }
    }
    
    func createSettingsObject(swiftDataContext: ModelContext, authenticateWithBiometricData: Bool, deleteProfileWhenInactiveFor: DeleteUserProfileAfterBeingInactiveFor) {
        let settingsObject = Settings(authenticateWithBiometricData: authenticateWithBiometricData, deleteProfileWhenInactiveFor: deleteProfileWhenInactiveFor)
        
        swiftDataContext.insert(settingsObject)
    }
}
