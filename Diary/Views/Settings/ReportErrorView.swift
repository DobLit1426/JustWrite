//
//  ReportError.swift
//  Diary
//
//  Created by Dobromir Litvinov on 04.11.2023.
//

import SwiftUI

fileprivate enum ErrorCause: String, CaseIterable {
    case other = "Other"
    case openingApp = "Opening app"
    case authenticating = "Authenticating"
    case addingDiaryEntry = "Adding a diary entry"
    case deletingDiaryEntry = "Deleting a diary entry"
    case sharingDiaryEntry = "Sharing a diary entry"
    case takingScreenshot = "Taking a screenshot"
    case landscapeMode = "Viewing app in landscape mode"
    case changingSetting = "Changing something in settings"
}

fileprivate enum ErrorType: String, CaseIterable {
    case other = "Other"
    case appCrashed = "App crashed"
    case frozen = "App stopped responding"
    case couldntProcceed = "The operation I wanted to do wasn't completed"
    case allDiaryEntriesDisappeared = "All my diary entries disappeared"
    case incorrectDisplaying = "Elements of the app were displayed incorrectly"
    case appActedLikeFirstOpened = "The app acted like it was opened for the first time"
    case didntRememberSettings = "App didn't remember the settings I changed"
}

struct ReportErrorView: View {
    // MARK: - Logger
    /// Logger instance
    private let logger: AppLogger = AppLogger(category: "ReportError")
    
    // MARK: - @Environment variables
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - @State variables
    @State var whatCausedErrorWritten: String = ""
    @State private var whatCausedError: ErrorCause = .other
    
    @State var errorTypeWritten: String = ""
    @State private var errorType: ErrorType = .other
    
    @State var showWriteErrorCauseAlert: Bool = false
    
    @State var highlightBordersOfRequiredFields: Bool = false
    
    @State var showThankYouAlert: Bool = false
    
    // MARK: - Computed properties
    
    var errorCauseBorderColor: Color? {
        highlightBordersOfRequiredFields && (whatCausedError == .other) && whatCausedErrorWritten.isEmpty ? Color.red : nil
    }
    var errorCauseBorderWidth: CGFloat {
        highlightBordersOfRequiredFields && (whatCausedError == .other) && whatCausedErrorWritten.isEmpty ? 2 : 0
    }
    
    var errorTypeBorderColor: Color? {
        highlightBordersOfRequiredFields && (errorType == .other) && errorTypeWritten.isEmpty ? Color.red : nil
    }
    var errorTypeBorderWidth: CGFloat {
        highlightBordersOfRequiredFields && (errorType == .other) && errorTypeWritten.isEmpty ? 2 : 0
    }
    
    // MARK: - Init
    init() { }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                //            VStack {
                Section("Error cause") {
                    Picker(selection: $whatCausedError) {
                        ForEach(ErrorCause.allCases, id: \.rawValue) { cause in
                            Text(cause.rawValue).tag(cause)
                        }
                    } label: {
                        Text("Which action did lead to error(s)?")
                    }
                    
                    TextField("Which actions resulted error?\(whatCausedError != .other ? " (optional)" : "")", text: $whatCausedErrorWritten, axis: .vertical)
                        .frame(maxHeight: .infinity)
                        .border(errorCauseBorderColor ?? Color.black, width: errorCauseBorderWidth)
                }
                
                Section("Error type") {
                    Picker(selection: $errorType) {
                        ForEach(ErrorType.allCases, id: \.rawValue) { type in
                            Text(type.rawValue).tag(type)
                        }
                    } label: {
                        Text("What error did you encounter?")
                    }
                    
                    TextField("Which error(s) occured?\(errorType != .other ? " (optional)" : "")", text: $errorTypeWritten, axis: .vertical)
                        .border(errorTypeBorderColor ?? Color.black, width: errorTypeBorderWidth)
                    
                }
                
                Button {
                    onSendButtonPress()
                } label: {
                    HStack {
                        Text("Send report")
                        Spacer()
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title)
                    }
                }
            }
            .animation(.easeInOut, value: whatCausedError)
            .animation(.easeInOut, value: errorType)
            .alert("Please fill all red fields", isPresented: $showWriteErrorCauseAlert, actions: {
                Button(role: .cancel, action: {}) {
                    Text("OK")
                }
            })
            .alert("Thank you!", isPresented: $showThankYouAlert, actions: {
                Button("You are welcome!", role: .cancel, action: {})
            })
            .pickerStyle(.navigationLink)
            .navigationTitle("Report error")
        }
    }
    
    // MARK: - Private functions
    private func onSendButtonPress() {
        if whatCausedError == .other && whatCausedErrorWritten.isEmpty {
            showWriteErrorCauseAlert = true
            highlightBordersOfRequiredFields = true
        } else {
            showThankYouAlert = true
            sendReport()
        }
    }
    
    private func sendReport() {
        let title = "Manual error report"
        var type: LogType = .critical
        var description = "Chosen action that led to error: '\(whatCausedError.rawValue)'. "
        
        if !whatCausedErrorWritten.isEmpty {
            description += "Manual description of action(s) that led to error: '\(whatCausedErrorWritten)'. "
        }
        
        description += "Chosen error type: '\(errorType.rawValue)'. "
        
        if !errorTypeWritten.isEmpty {
            description += "Manual description of the error(s): '\(errorTypeWritten)'. "
        }
        
        
        switch errorType {
        case .appCrashed:
            type = .fatalError
        case .frozen:
            type = .fatalError
        default:
            type = .critical
        }
        
        logger.reportableLog(logType: type, title: title, message: description, sendReport: .yes)
        dismiss()
    }
}

#Preview {
    ReportErrorView()
}
