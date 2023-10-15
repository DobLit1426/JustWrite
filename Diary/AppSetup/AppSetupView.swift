//
//  AppSetupView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 16.09.2023.
//

import SwiftUI
import LocalAuthentication
import SwiftData

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

struct AppSetupView: View {
    @State var authenticateWithBiometricData: Bool = false
    @State var deleteProfileWhenInactiveFor: DeleteUserProfileAfterBeingInactiveFor = .turnedOff
    

    @ObservedObject private var viewModel: AppSetupViewModel
    var theFirstPageIsShown: Bool { viewModel.theFirstPageIsShown }
    var theLastPageIsShown: Bool { viewModel.theLastPageIsShown }
    var appSetupProgress: Int { viewModel.appSetupProgress }
    var totalNumberOfPages: Int { viewModel.totalNumberOfPages }
    
    @Environment(\.modelContext) private var swiftDataContext
    
    
    // @Binding variable
    @Binding var currentView: CurrentView
    
    
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
    
    // Pages
    private var page1: some View {
        Text("Welcome to JustWrite", comment: "The welcome text that will greet the user when the user will open the app for the first time")
            .font(DeviceSpecifications.isIPad ? .system(size: 40) : .title)
    }
    
    private var page2: some View {
        VStack {
            Divider()
            Text("We're excited to have you join us for a new way to keep your personal thoughts and memories safe.")
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
                            Text(feature.description)
                                .font(.body)
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
            Text("To continue you will need to setup your diary")
                .font(.title)
            
            Divider()
            
            Text("You will just need to answer a few questions.")
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
            Text("After which time should we delete your profile if you don't use the app?").font(.title)
            Divider()
            Spacer()
            Image(systemName: "person.crop.circle.badge.clock.fill")
                .symbolRenderingMode(.palette)
                .font(.system(size: 100))
            Spacer()
            Picker("Select after which time we should delete your profile if you don't use the app", selection: $deleteProfileWhenInactiveFor) {
                ForEach(DeleteUserProfileAfterBeingInactiveFor.allCases, id: \.rawValue) { setting in
                    Text(setting.rawValue).tag(setting.rawValue)
                }
            }
            .pickerStyle(.wheel)
            Spacer()
        }
        .padding()
    }
    
    // View variables
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
                    Text(String(localized: "Back"))
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
                Text(String(localized: "Skip"))
            }
            
        }
        .opacity(viewModel.skipGuideButtonDisabled ? 0 : 1)
        .disabled(viewModel.skipGuideButtonDisabled)
        .animation(.easeInOut, value: viewModel.skipGuideButtonDisabled)
    }
    
    // Functions
    private func previousPage() { viewModel.previousPage() }
    private func nextPage() { viewModel.nextPage() }
    private func skip() { viewModel.skip() }
    
    init(currentView: Binding<CurrentView>) {
        self._currentView = currentView
        self.authenticateWithBiometricData = false
        self.viewModel = AppSetupViewModel(numberOfPagesIfDeviceSupportsBiometricAuthentication: 10, numberOfPagesIfDeviceDoesntSupportBiometricAuthentication: 9)
        if viewModel.deviceSupportsBiometricAuthentication {
            authenticateWithBiometricData = true
        }
    }
    
    private func createSettings() {
        viewModel.createSettingsObject(swiftDataContext: swiftDataContext, authenticateWithBiometricData: authenticateWithBiometricData, deleteProfileWhenInactiveFor: deleteProfileWhenInactiveFor)
    }
}

#Preview {
    @State var currentView: CurrentView = .appSetup
    return AppSetupView(currentView: $currentView)
}
