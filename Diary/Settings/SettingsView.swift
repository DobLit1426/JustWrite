//
//  UserProfileView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 10.09.2023.
//

import SwiftUI
import SwiftData
import os

/// Displays app settings and allows changing them
struct SettingsView: View {
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "SettingsView")
    
    //MARK: - @Environment variables
    @Environment(\.modelContext) private var swiftDataContext
    @Environment(\.scenePhase) private var scenePhase
    
    //MARK: - @Query variables
    @Query var settings: [Settings]
    @Query var entries: [EncryptedDiaryEntry]
    
    //MARK: - @State variables
    @State var showBiometricAuthenticationUnavailableExplanationAlert: Bool = false
    @State var showDeleteAllDiaryEntriesAlert: Bool = false
    @State var showDeleteEverythingAlert: Bool = false
    
    //MARK: - @Binding variables
    @Binding var currentTab: CurrentTab
    
    //MARK: - ViewModel
    @ObservedObject var viewModel: SettingsViewModel = SettingsViewModel(determineSettingsObject: false)
    
    //MARK: - Body
    var body: some View {
        if currentTab == .settings {
            NavigationStack {
                Form {
                    Section {
                        if viewModel.deviceSupportsBiometricAuthentication {
                            Toggle("Unlock with \(viewModel.biometricAuthenticationTypeString)", isOn: $viewModel.authenticateWithBiometricData)
                        } else if viewModel.deviceSupportsBiometricAuthenticationButItIsNotSetUp {
                            Button("Unlock with \(viewModel.biometricAuthenticationTypeString)") {
                                showBiometricAuthenticationUnavailableExplanationAlert = true
                            }
                        }
                        Picker("Delete all entries if inactive for", selection: $viewModel.deleteEverythingAfterBeingInactiveFor) {
                            ForEach(DeleteUserProfileAfterBeingInactiveFor.allCases, id: \.id) { setting in
                                Text(setting.rawValue).tag(setting)
                            }
                        }
                        
                    } header: {
                        Text("Privacy And Security")
                    }
                    
                    Section {
                        DestructiveButton("Delete all diary entries") { deleteAllDiaryEntriesButtonPressed() }
                        DestructiveButton("Delete all data") { deleteEverythingButtonPressed() }
                    } header: {
                        Text("Danger Zone")
                            .foregroundStyle(.red)
                    }
                }
                .formStyle(.grouped)
                .navigationTitle("Settings")
                .onDisappear { onDisappear() }
                .onAppear { onAppear() }
                .animation(.easeInOut, value: viewModel.authenticateWithBiometricData)
            }
            .alert("To unlock the JustWrite App with \(viewModel.biometricAuthenticationTypeString) you need to setup \(viewModel.biometricAuthenticationTypeString) in Settings of your device.", isPresented: $showBiometricAuthenticationUnavailableExplanationAlert) {
                Button("OK", role: .cancel) {}
            }
            .alert("If you proceed, all your diary entries will be deleted. This action is irreversable.\nProceed?", isPresented: $showDeleteAllDiaryEntriesAlert) {
                Button("No", role: .cancel) {}
                Button("Yes, delete all my diary entries", role: .destructive) { deleteAllDiaryEntries() }
            }
            .alert("If you proceed, all your diary entries and your settings will be deleted. All your data will be lost. This action is irreversable.\nProceed?", isPresented: $showDeleteEverythingAlert) {
                Button("No", role: .cancel) {}
                Button("Yes, delete all my data", role: .destructive) { deleteEverything() }
            }
            .onChange(of: scenePhase) { _, newValue in
                if newValue != .active {
                    onDisappear()
                }
            }
            .onChange(of: viewModel.authenticateWithBiometricData) { _, _ in
                saveSettings()
            }
            .onChange(of: viewModel.deleteEverythingAfterBeingInactiveFor) { oldValue, newValue in
                saveSettings()
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
        
        logger.critical("Saved Settings \(viewModel.settingsObject.description)")
    }
}

//#Preview {
//    SettingsView()
//}
