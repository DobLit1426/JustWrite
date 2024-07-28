//
//  AppSetupView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 16.09.2023.
//

import SwiftUI
import LocalAuthentication
import SwiftData

/// Describes a single part of the setup that is shown after and before a certain index
fileprivate struct SetupPage {
    let view: AnyView
    let showAfterIndex: Int
    let showBeforeIndex: Int
    
    init(view: AnyView, showAfterIndex: Int, showBeforeIndex: Int) {
        self.view = view
        self.showAfterIndex = showAfterIndex
        self.showBeforeIndex = showBeforeIndex
    }
    
    init(view: AnyView, showAtIndex: Int) {
        self.view = view
        self.showAfterIndex = showAtIndex
        self.showBeforeIndex = showAtIndex + 1
    }
}

fileprivate struct LocalizedStrings {
    static let deleteEntriesAfterPickerLabel: String = String(localized: "Select after which time we should delete your entries if you don't use the app", defaultValue: "Select after which time we should delete your entries if you don't use the app", comment: "This text is shown as the Picker label during the diary setup, when user should choose after which time the diary entries should be deleted, if he's inactive")
}

struct AppSetupView: View {
    // MARK: - Logger
    /// Logger instance
    private let logger: AppLogger = AppLogger(category: "AppSetupView")
    
    // MARK: - @State variables
    /// Determines whether the user wants to use biometric authentication to log in the app
    @State var authenticateWithBiometricData: Bool = false
    
    /// Determines whether the user wants all entries to be automatically deleted after a certain period of time
    @State var deleteEntriesWhenInactiveFor: DeleteEntriesAfterBeingInactiveFor = .turnedOff
    
    // MARK: - ViewModel
    /// ViewModel
    @ObservedObject private var viewModel: AppSetupViewModel
    
    // MARK: - Computed variables
    /// Shows whether the first setup page is shown
    var theFirstPageIsShown: Bool { viewModel.theFirstPageIsShown }
    
    /// Shows whether the last setup page is shown
    var theLastPageIsShown: Bool { viewModel.theLastPageIsShown }
    
    /// Shows the app setup progress
    var appSetupProgress: Int { viewModel.appSetupProgress }
    
    /// Shows the total number of setup pages
    var totalNumberOfPages: Int { viewModel.totalNumberOfPages }
    
    /// Setup pages
    fileprivate var setupPages: [SetupPage] {
        var pages: [SetupPage] = [
            SetupPage(view: AnyView(page1), showAfterIndex: 1, showBeforeIndex: 3),
            SetupPage(view: AnyView(page2), showAfterIndex: 2, showBeforeIndex: 3),
            SetupPage(view: AnyView(page3), showAfterIndex: 3, showBeforeIndex: 8),
            SetupPage(view: AnyView(appFeatures), showAfterIndex: 4, showBeforeIndex: 8),
            SetupPage(view: AnyView(page8), showAtIndex: 8) ]
        
        if viewModel.deviceSupportsBiometricAuthentication {
            authenticateWithBiometricData = true
            pages.append(SetupPage(view: AnyView(page9), showAtIndex: 9))
        }
        pages.append(contentsOf: [
            SetupPage(view: AnyView(page10), showAtIndex: viewModel.deviceSupportsBiometricAuthentication ? 10 : 9)
        ])
        
        return pages
    }
    
    // MARK: - @Environment variables
    /// SwiftData context
    @Environment(\.modelContext) private var swiftDataContext
    
    // MARK: - @Binding variables
    /// Current view
    @Binding var currentView: CurrentView
    
    // MARK: - Init
    init(currentView: Binding<CurrentView>) {
        self._currentView = currentView
        self.authenticateWithBiometricData = false
        self.viewModel = AppSetupViewModel(numberOfPagesIfDeviceSupportsBiometricAuthentication: 10, numberOfPagesIfDeviceDoesntSupportBiometricAuthentication: 9)
        if viewModel.deviceSupportsBiometricAuthentication {
            authenticateWithBiometricData = true
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ForEach(setupPages, id: \.showAfterIndex) { page in
                    VStack {
                        if appSetupProgress >= page.showAfterIndex && appSetupProgress < page.showBeforeIndex {
                            page.view
                        }
                    }
                    .animation(.easeInOut(duration: 0.25), value: appSetupProgress)
                }
                
                Spacer()
                
                HStack {
                    backButton
                    continueButton
                }
                
                progressBar
            }
            .toolbar {
                ToolbarItem { skipGuideButton }
            }
        }
        .padding()
    }
    
    // MARK: - View variables - Setup pages
    private var page1: some View {
        Text("Welcome to JustWrite", comment: "The welcome text that will greet the user when the user will open the app for the first time")
            .font(DeviceSpecifications.isIPad ? .system(size: 40) : .title)
    }
    
    private var page2: some View {
        VStack {
            Divider()
            Text("We're excited to have you join us for a new way to keep your personal thoughts and memories safe.", comment: "Used as an introduction in the app when opened for the first time")
                .font(.body)
        }
    }
    private var page3: some View {
        Text("Key features of JustWrite", comment: "The title after which the key features of the app will be presented")
            .font(.title)
    }
    
    private var appFeatures: some View {
        ForEach(AppSetupViewModel.features) { feature in
            VStack {
                if appSetupProgress >= feature.showStartingFromIndex && appSetupProgress < feature.showBeforeIndex {
                    Divider()
                    HStack {
                        Image(systemName: feature.iconSystemName)
                        Spacer()
                        VStack {
                            Text(feature.heading)
                                .font(.headline)
                            if appSetupProgress == feature.showStartingFromIndex {
                                Text(feature.description)
                                    .font(.body)
                            }
                        }
                        Spacer()
                        Image(systemName: feature.iconSystemName)
                    }
                }
            }
            .animation(.easeInOut, value: appSetupProgress)
        }
    }
    
    private var page8: some View {
        VStack {
            Text("To continue you will need to setup your diary", comment: "Title that informs user (after the key features of the diary are shown) that he has to setup his diary")
                .font(.title)
            
            Divider()
            
            Text("You will just need to answer a few questions.", comment: "Body text after 'to continue you need to setup your diary' that says that the setup process won't be long")
                .font(.body)
        }
    }
    
    private var page9: some View {
        VStack {
            Text("Do you want to unlock the JustWrite app with \(viewModel.biometricAuthenticationTypeString)?", comment: "Text asking whether the user wants to unlock the diary with biometric data")
                .font(.title)
            Divider()
            Spacer()
            Image(systemName: viewModel.biometricAuthenticationSystemImageName)
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 100))
            Spacer()
            Toggle(isOn: $authenticateWithBiometricData) {
                Label("Unlock with \(viewModel.biometricAuthenticationTypeString)", systemImage: viewModel.biometricAuthenticationSystemImageName)
            }
            Spacer()
        }
        .padding()
    }
    
    private var page10: some View {
        VStack {
            Text("After which time should we delete your entries if you don't use the app?", comment: "Title text asking user after which time his entries if he's inactive").font(.title)
            Divider()
            Spacer()
            Image(systemName: "person.crop.circle.badge.clock.fill")
                .symbolRenderingMode(.palette)
                .font(.system(size: 100))
            Spacer()
            Picker(LocalizedStrings.deleteEntriesAfterPickerLabel, selection: $deleteEntriesWhenInactiveFor) {
                ForEach(DeleteEntriesAfterBeingInactiveFor.allCases, id: \.id) { setting in
                    Text(setting.localized).tag(setting.id)
                }
            }
            .pickerStyle(.wheel)
            Spacer()
        }
        .padding()
    }
    
    // MARK: - View variables
    private var progressBar: some View {
        VStack {
            if appSetupProgress > 1 {
                ProgressView(value: Float(appSetupProgress), total: Float(totalNumberOfPages))
                    .animation(.easeInOut(duration: 0.5), value: appSetupProgress)
                    .padding()
            }
        }
        .animation(.easeInOut, value: appSetupProgress)
    }
    
    private var backButton: some View {
        VStack {
            if appSetupProgress > 1 {
                Button {
                    previousPage()
                } label: {
                    Text("Back", comment: "Text on app setup view of the button that goes one slide back")
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .animation(.easeInOut, value: appSetupProgress)
    }
    
    private var continueButton: some View {
        Button(action: {
            if theLastPageIsShown {
                createSettings()
                currentView = .diary
            }
            nextPage()
        }, label: {
            VStack {
                Text(viewModel.continueButtonText)
            }
            
        })
        .buttonStyle(PrimaryButtonStyle())
        .animation(.easeInOut, value: appSetupProgress)
    }
    
    private var skipGuideButton: some View {
        VStack {
            Button {
                skip()
            } label: {
                Text("Skip", comment: "Button text on app setup view that skips all slides till the diary setup")
            }
            
        }
        .opacity(viewModel.skipGuideButtonDisabled ? 0 : 1)
        .disabled(viewModel.skipGuideButtonDisabled)
        .animation(.easeInOut, value: viewModel.skipGuideButtonDisabled)
    }
    
    // MARK: - Private functions
    /// Opens the next setup page, if possible
    private func previousPage() { viewModel.previousPage() }
    
    /// Goes to the previous setup page, if possible
    private func nextPage() { viewModel.nextPage() }
    
    /// Skips to the part, where the user should setup their diary
    private func skip() { viewModel.skip() }
    
    /// Creates the settings object
    private func createSettings() {
        viewModel.createSettingsObject(swiftDataContext: swiftDataContext, authenticateWithBiometricData: authenticateWithBiometricData, deleteProfileWhenInactiveFor: deleteEntriesWhenInactiveFor)
    }
}

#Preview {
    @State var currentView: CurrentView = .appSetup
    return AppSetupView(currentView: $currentView)
}
