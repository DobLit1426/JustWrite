//
//  PrivacyAndSecuritySection.swift
//  Diary
//
//  Created by Dobromir Litvinov on 07.11.2023.
//

import SwiftUI

fileprivate struct LocalizedStrings {
    static let deleteAllEntriesIfInactiveForPickerLabel: String = String(localized: "Delete all entries if inactive for picker label", defaultValue: "Delete all entries if inactive for", comment: "Used as label text on Picker that determines the time after which all entries will be deleted if user is inactive")
    static let privacyAndSecuritySection: String = String(localized: "'Privacy And Security' section label", defaultValue: "Privacy And Security", comment: "Used as label for the 'Privacy And Security' section in Settings")
}

struct PrivacyAndSecuritySection: View {
    let deviceSupportsBiometricAuthentication: Bool
    let biometricAuthenticationTypeString: String
    let deviceSupportsBiometricAuthenticationButItIsNotSetUp: Bool
    
    @Binding var authenticateWithBiometricData: Bool
    @Binding var showBiometricAuthenticationUnavailableExplanationAlert: Bool
    @Binding var deleteEverythingAfterBeingInactiveFor: DeleteEntriesAfterBeingInactiveFor
    
    var body: some View {
        Section(LocalizedStrings.privacyAndSecuritySection) {
            if deviceSupportsBiometricAuthentication {
                Toggle("Require \(biometricAuthenticationTypeString)", isOn: $authenticateWithBiometricData)
            } else if deviceSupportsBiometricAuthenticationButItIsNotSetUp {
                Button("Require \(biometricAuthenticationTypeString)") {
                    showBiometricAuthenticationUnavailableExplanationAlert = true
                }
            }
            Picker(LocalizedStrings.deleteAllEntriesIfInactiveForPickerLabel, selection: $deleteEverythingAfterBeingInactiveFor) {
                ForEach(DeleteEntriesAfterBeingInactiveFor.allCases, id: \.id) { setting in
                    Text(setting.localized).tag(setting)
                }
            }
        }
    }
}
//
//#Preview {
//    PrivacyAndSecuritySection()
//}
