//
//  UserProfileView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 10.09.2023.
//

import SwiftUI
import SwiftData

fileprivate struct LocalizedStrings {
    static let deleteAllEntriesIfInactiveForPickerLabel: String = String(localized: "Delete all entries if inactive for picker label", defaultValue: "Delete all entries if inactive for", comment: "Used as label text on Picker that determines the time after which all entries will be deleted if user is inactive")
    static let privacyAndSecuritySection: String = String(localized: "'Privacy And Security' section label", defaultValue: "Privacy And Security", comment: "Used as label for the 'Privacy And Security' section in Settings")
    
    static let dangerZoneSection: String = String(localized: "'Danger Zone' section label", defaultValue: "Danger Zone", comment: "Used as label for the 'Danger Zone' section in Settings")
    static let deleteAllDiaryEntries: String = String(localized: "'Delete all diary entries' button text", defaultValue: "Delete all diary entries", comment: "Used as label for the button in Settings that deletes all diary entries")
    static let deleteAllData: String = String(localized: "'Delete all data' button text", defaultValue: "Delete all data", comment: "Used as label for the button in Settings that deletes all user data")
    
    static let navigationTitle: String = String(localized: "Settings navigation title", defaultValue: "Settings", comment: "Used as navigation title in Settings")
    static let no: String = String(localized: "Cancel option")
}

/// Displays app settings and allows changing them
struct SettingsView: View {
    private let logger: AppLogger = AppLogger(category: "SettingsView")
    
    //MARK: - @Environment variables
    @Environment(\.modelContext) private var swiftDataContext
    @Environment(\.scenePhase) private var scenePhase
    
    //MARK: - @Query variables
    @Query var settings: [Settings]
    @Query var entries: [DiaryEntry]
    
    //MARK: - @State variables
    @State var showBiometricAuthenticationUnavailableExplanationAlert: Bool = false
    @State var showDeleteAllDiaryEntriesAlert: Bool = false
    @State var showDeleteEverythingAlert: Bool = false
    @State var sendAnonymousErrorReports: Bool = false
    
    //MARK: - @Binding variables
    @Binding var currentTab: CurrentTab
    
    //MARK: - ViewModel
    @ObservedObject var viewModel: SettingsViewModel = SettingsViewModel(determineSettingsObject: false)
    
    //MARK: - Body
    var body: some View {
        if currentTab == .settings {
            NavigationStack {
                Form {
                    Section(LocalizedStrings.privacyAndSecuritySection) {
                        if viewModel.deviceSupportsBiometricAuthentication {
                            Toggle("Require \(viewModel.biometricAuthenticationTypeString)", isOn: $viewModel.authenticateWithBiometricData)
                        } else if viewModel.deviceSupportsBiometricAuthenticationButItIsNotSetUp {
                            Button("Require \(viewModel.biometricAuthenticationTypeString)") {
                                showBiometricAuthenticationUnavailableExplanationAlert = true
                            }
                        }
                        Picker(LocalizedStrings.deleteAllEntriesIfInactiveForPickerLabel, selection: $viewModel.deleteEverythingAfterBeingInactiveFor) {
                            ForEach(DeleteEntriesAfterBeingInactiveFor.allCases, id: \.id) { setting in
                                Text(setting.localized).tag(setting)
                            }
                        }
                    }
                    
                    Section("Anonymous error reports") {
                        Toggle("Send anonymous reports", isOn: $sendAnonymousErrorReports)
                        NavigationLink("What is this setting about?", destination: WhatAreAnonymousReports())
                        #if DEBUG
                        Button("Send .yes test error report") {
                            logger.critical("Test .yes error report", sendReport: .yes)
                        }
                        Button("Send .automatic test error report") {
                            logger.critical("Test .yes error report", sendReport: .automatic)
                        }
                        #endif
                    }

                    Section("Manual error report") {
                        NavigationLink("Submit an error report", destination: ReportErrorView())
                    }
                    
                    Section {
                        DestructiveButton(LocalizedStrings.deleteAllDiaryEntries) { deleteAllDiaryEntriesButtonPressed() }
                        DestructiveButton(LocalizedStrings.deleteAllData) { deleteEverythingButtonPressed() }
                    } header: {
                        Text(LocalizedStrings.dangerZoneSection)
                            .foregroundStyle(.red)
                    }
                    
                }
                .formStyle(.grouped)
                .navigationTitle(LocalizedStrings.navigationTitle)
                .onDisappear { onDisappear() }
                .onAppear { onAppear() }
                .animation(.easeInOut, value: viewModel.authenticateWithBiometricData)
            }
            .alert("To unlock the JustWrite App with \(viewModel.biometricAuthenticationTypeString) you need to setup \(viewModel.biometricAuthenticationTypeString) in Settings of your device.", isPresented: $showBiometricAuthenticationUnavailableExplanationAlert) {
                Button("OK", role: .cancel) {}
            }
            .confirmationDialog("Are you sure?", isPresented: $showDeleteAllDiaryEntriesAlert, actions: {
                Button("Yes, delete all my diary entries", role: .destructive) { deleteAllDiaryEntries() }
                Button("Cancel", role: .cancel) {}
            }, message: {
                Text("If you proceed, all your diary entries will be deleted. This action is irreversable.")
            })
            .confirmationDialog("Are you sure?", isPresented: $showDeleteEverythingAlert, actions: {
                Button(LocalizedStrings.deleteAllData, role: .destructive) { deleteEverything() }
                Button("Cancel", role: .cancel) {}
            }, message: {
                Text("If you proceed, all your diary entries and your settings will be deleted. All your data will be lost. This action is irreversable.")
            })
            .onChange(of: scenePhase) { onChangeOfSceenPhase(newValue: $1) }
            .onChange(of: viewModel.authenticateWithBiometricData) { saveSettings() }
            .onChange(of: viewModel.deleteEverythingAfterBeingInactiveFor) { saveSettings() }
            .onChange(of: sendAnonymousErrorReports) { _, newValue in
                UserDefaultsInteractor.setSendAnonymousReportsValue(newValue)
            }
        } else {
            Text("")
        }
    }
    
    //MARK: - Private functions
    /// Called on press of delete all diary entries button
    private func deleteAllDiaryEntriesButtonPressed() {
        logger.info("Delete all diary entries button was pressed")
        showDeleteAllDiaryEntriesAlert = true
    }
    
    /// Called on press of delete
    private func deleteEverythingButtonPressed() {
        logger.info("Delete eveything button pressed")
        showDeleteEverythingAlert = true
    }
    
    /// Deletes all diary entries
    private func deleteAllDiaryEntries() {
        for _ in 1...5 {
            for entry in entries {
                swiftDataContext.delete(entry)
            }
        }
    }
    
    /// Deletes eveything
    private func deleteEverything() {
        for _ in 1...5 {
            for entry in entries {
                swiftDataContext.delete(entry)
            }
        }
        
        for _ in 1...5 {
            for setting in settings {
                swiftDataContext.delete(setting)
            }
        }
    }
    
    /// Called on View disappear. Deletes all the existing settings objects and creates the new one with the edited settings.
    private func onDisappear() {
        logger.info("Starting function on View disappear")
        
        saveSettings()
        
        logger.info("Finished function on View disappear")
    }
    
    /// Called on View appear
    private func onAppear() {
        logger.info("Starting function on View appear")
        viewModel.setSettingsObject(basedOn: settings)
        
        self.sendAnonymousErrorReports = UserDefaultsInteractor.getSendAnonymousReportsValue()
        
        logger.info("Setted settings object \(viewModel.settingsObject.description)")
        
        logger.info("Finished function on View appear")
    }
    
    private func saveSettings() {
        if settings.count == 1 {
            settings[0].authenticateWithBiometricData = viewModel.authenticateWithBiometricData
            settings[0].deleteProfileWhenInactiveFor = viewModel.deleteEverythingAfterBeingInactiveFor
        } else {
            let settingsObjectToSave = viewModel.settingsObject
            for settingsObject in settings {
                swiftDataContext.delete(settingsObject)
            }
            swiftDataContext.insert(settingsObjectToSave)
        }
        
        UserDefaultsInteractor.setSendAnonymousReportsValue(sendAnonymousErrorReports)
        
        
        logger.info("Saved Settings \(viewModel.settingsObject.description), sendAnonymousReports: \(sendAnonymousErrorReports)")
    }
    
    private func onChangeOfSceenPhase(newValue: ScenePhase) {
        if newValue != .active {
            onDisappear()
        }
    }
}

#Preview {
    SettingsView(currentTab: .constant(.settings))
}
