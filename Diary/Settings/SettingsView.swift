//
//  UserProfileView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 10.09.2023.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var swiftDataContext
    @Query var settings: [Settings]
    @Query var entries: [EncryptedDiaryEntry]
        
    @State var showBiometricAuthenticationUnavailableExplanationAlert: Bool = false
    @State var destroyEverythingButtonActivated: Bool = false
    
    var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if viewModel.deviceSupportsBiometricAuthentication {
                        Toggle("Unlock with \(viewModel.biometricAuthenticationTypeString)", isOn: viewModel.authenticateWithBiometricData)
                    } else if viewModel.deviceSupportsBiometricAuthenticationButItIsNotSetUp {
                        Button("Unlock with \(viewModel.biometricAuthenticationTypeString)") {
                            showBiometricAuthenticationUnavailableExplanationAlert = true
                        }
                    }
                    Picker("Delete all entries if inactive for", selection: viewModel.deleteEverythingAfterBeingInactiveFor) {
                        ForEach(DeleteUserProfileAfterBeingInactiveFor.allCases, id: \.rawValue) { setting in
                            Text(setting.rawValue).tag(setting.rawValue)
                        }
                    }
                
                } header: {
                    Text("Privacy And Security")
                }
                
                Section {
                    Toggle(isOn: $destroyEverythingButtonActivated, label: {
                        Text("Activate 'Destroy everything' button")
                            .foregroundStyle(.red)
                    })
                    
                    Button {
                        deleteEverything()
                    } label: {
                        Text("DESTROY EVERYTHING")
                            .font(.headline)
                        Text("This will delete all your diary entries and settings like they never existed. There's no way to reverse that action! Proceed on own fear!")
                            .font(.subheadline)
                    }
                    .foregroundStyle(destroyEverythingButtonActivated ? .red : .gray.opacity(0.5))
                    .disabled(!destroyEverythingButtonActivated)

                } header: {
                    Text("Danger Zone")
                        .foregroundStyle(.red)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Settings")
            .onDisappear {
                for object in settings {
                    swiftDataContext.delete(object)
                }
                
                swiftDataContext.insert(viewModel.settingsObject)
                
                destroyEverythingButtonActivated = false
            }
            .onAppear {
                viewModel.setSettingsObject(basedOn: settings)
            }
            .animation(.easeInOut, value: viewModel.authenticateWithBiometricData.wrappedValue)
        }
        .alert("To unlock the JustWrite App with \(viewModel.biometricAuthenticationTypeString) you need to setup \(viewModel.biometricAuthenticationTypeString) in Settings of your device.", isPresented: $showBiometricAuthenticationUnavailableExplanationAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    init() {
        self.viewModel = SettingsViewModel(determineSettingsObject: false)
    }
    
    private func deleteEverything() {
        for _ in 1...5 {
            for entry in entries {
                swiftDataContext.delete(entry)
            }
            
            for settingsObject in settings {
                swiftDataContext.delete(settingsObject)
            }
        }
    }
}

#Preview {
    SettingsView()
}
