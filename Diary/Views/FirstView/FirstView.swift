//
//  FirstView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 15.09.2023.
//

import SwiftUI
import SwiftData
import os

/// Used to control which app part is shown
struct FirstView: View {
    /// Logger instance
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "FirstView")
    
    // MARK: - @Environment variables
    /// Describes the current scene phase
    @Environment(\.scenePhase) var scenePhase
    /// Swift Data context
    @Environment(\.modelContext) private var swiftDataContext
    
    // MARK: - @Query variables
    /// Settings objects that are automatically fetched and updated by Swift Data
    @Query private var settings: [Settings]
    
    /// View model
    @ObservedObject private var viewModel: FirstViewModel
    
    // MARK: - State Variables
    /// Stores the enum value of the current view
    @State var currentView: CurrentView = .none
    
    /// Determines whether the app is unlocked or not
    @State var isUnlocked: Bool = false
    
    /// If true, the function on the first appear will be called. If false, not.
    /// - Important: When the function on first appear is done, this value is set to true.
    @State var determiniedInitialView: Bool = false
    
    // MARK: - Init
    /// Initialises the struct by creating viewModel
    init() {
        logger.info("Initialising FirstView...")
        viewModel = FirstViewModel()
        logger.info("Successfully intitalised FirstView")
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if determiniedInitialView {
                switch currentView {
                case .appSetup:
                    AppSetupView(currentView: $currentView)
                case .diary:
                    NavigationManager()
                default:
                    EmptyView()
                        .onAppear {
                            logger.critical("The specified currentView '\(currentView.rawValue)' isn't included in Switch in FirstView")
                        }
                }
                
                if !isUnlocked { AuthenticationView(isUnlocked: $isUnlocked) }
                
                if #available(iOS 17.0, *), !deviceHasNotch {
                    GeometryReader { geometry in
                        HStack {
                            Spacer()
                            ZStack {
                                Capsule()
                                    .frame(width: 110, height: 20)
                                    .foregroundStyle(.blue)
                                Text("JustWrite")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .clipShape(Capsule())
                                    .frame(width: 110, height: 20)
                            }
                            Spacer()
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .onAppear { onAppear() }
        .animation(.easeInOut, value: currentView)
        .animation(.easeInOut, value: isUnlocked)
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .background {
                if viewModel.shouldLockTheApp(settings) {
                    lockTheApp()
                }
            }
        }
    }
    
    // MARK: - Private functions
    /// Locks the app
    private func lockTheApp() {
        logger.info("Starting function to lock the app...")
        isUnlocked = false
        logger.info("Successfully locked the app")
    }
    
    /// Called on View appear. Checks whether the View appears for the first time and if yes, then calls onFirstAppear
    private func onAppear() {
        logger.info("FirstView appeared")
        logger.info("Starting doing functions on the appear of FirstView...")
        
        if !determiniedInitialView {
            onFirstAppear()
        }
        
        logger.info("Successfully finished doing functions on the appear of FirstView appear")
    }
    
    /// Function called on the first View appear. Checks setting, updates viewModel, determines and sets the initial View.
    private func onFirstAppear() {
        logger.info("Starting onFirstAppear function...")
        
        checkSettings()
        
        viewModel.update(with: settings)
        
        let determinedInitialView = viewModel.determineInitialView()
        logger.info("Determined initial view is \(determinedInitialView.rawValue)")
        
        if determinedInitialView == .appSetup {
            isUnlocked = true
            currentView = .appSetup
        } else if determinedInitialView == .diary {
            isUnlocked = true
            currentView = .diary
        } else if determinedInitialView == .authentication {
            isUnlocked = false
            currentView = .diary
        } else {
            logger.critical("Determined initial view ('\(determinedInitialView.rawValue)') isn't included in if-else, setting currentView to '.none' and unlocked to 'true'")
            isUnlocked = true
            currentView = .none
        }
        
        determiniedInitialView = true
        
        logger.info("Successfully finished onFirstAppear function")
    }
    
    /// Checks settings objects. If finds multiple, deletes all except the last.
    private func checkSettings() {
        logger.info("Starting function to check settings...")
        if settings.count > 1 {
            logger.critical("Found multiple settings instances. Deleting all them except the last one to continue app functionality...")
            for index in 0..<settings.count - 1 {
                swiftDataContext.delete(settings[index])
            }
            logger.critical("Deleted all settings instances except the last one. The last settings instance will be the saved.")
        } else {
            logger.info("Successfully checked settings. Number of settings: \(settings.count)")
        }
    }
    
    var deviceHasNotch: Bool {
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { return false }
            
            return window.safeAreaInsets.top > 20
        }
        
        if #available(iOS 11.0, *) {
            let top = UIApplication.shared.windows[0].safeAreaInsets.top
            return top > 20
        } else {
            // Fallback on earlier versions
            return false
        }
    }
}


#Preview {
    FirstView()
}

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            guard let window = windowScene?.windows.first else { return false }
            
            return window.safeAreaInsets.top > 20
        }
        
        if #available(iOS 11.0, *) {
            let top = UIApplication.shared.windows[0].safeAreaInsets.top
            return top > 20
        } else {
            // Fallback on earlier versions
            return false
        }
    }
}
