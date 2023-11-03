//
//  AppLogger.swift
//  Diary
//
//  Created by Dobromir Litvinov on 30.10.2023.
//

import Foundation
import os

enum SendReportOption {
    case yes
    case no
    case automatic
}

/// Logger that must be used to log logs, warnings, errors etc.
class AppLogger {
    static let userDefaultsSendAnonymousReportsKey: String = "Settings-SendAnonymousReports"
    static let userDefaultsSendAnonymousReportsDefaultValue: Bool = false
    private let userDefaultsSendAnonymousReportsKey = AppLogger.userDefaultsSendAnonymousReportsKey
    
    let subsystem: String
    let category: String
    
    private let systemLogger: Logger
    
    init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.systemLogger = Logger(subsystem: subsystem, category: category)
    }
    
    init(category: String) {
        self.subsystem = ".com.justWrite"
        self.category = category
        self.systemLogger = Logger(subsystem: subsystem, category: category)
    }
    
    func error(_ message: String, title: String = "", sendReport: SendReportOption = .automatic) {
        systemLogger.error("\(message)")
        
        if sendReport == .yes || (sendReport == .automatic && UserDefaultsInteractor.getSendAnonymousReportsValue()) {
            CrashReporter.sendLog(type: .error, title: title, description: "\(message)", subsystem: self.subsystem, category: self.category)
        }
    }
    
    func info(_ message: String) {
        systemLogger.info("\(message)")
    }
    
    func critical(_ message: String, title: String = "", sendReport: SendReportOption = .automatic) {
        systemLogger.critical("\(message)")
        
        if sendReport == .yes || (sendReport == .automatic && UserDefaultsInteractor.getSendAnonymousReportsValue()) {
            CrashReporter.sendLog(type: .critical, title: title, description: "\(message)", subsystem: self.subsystem, category: self.category)
        }
    }
    
    func warning(_ message: String, title: String = "", sendReport: SendReportOption = .no) {
        systemLogger.warning("\(message)")
        
        if sendReport == .yes || (sendReport == .automatic && UserDefaultsInteractor.getSendAnonymousReportsValue()) {
            CrashReporter.sendLog(type: .warning, title: title, description: "\(message)", subsystem: self.subsystem, category: self.category)
        }
    }
}
