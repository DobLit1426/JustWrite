//
//  AddNewEntryViewModel.swift
//  Diary
//
//  Created by Dobromir Litvinov on 06.10.2023.
//

import Foundation
import CryptoKit
import os

class AddNewEntryViewModel: ObservableObject {
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "AddNewEntryViewModel")
    
    init() {
        logger.info("Successfully initialised AddDiaryEntryViewModel")
    }
    
    class LocalizedStrings {
        static let diaryHeadingTextFieldPlaceholder: String = String(localized: "Heading of the diary entry", defaultValue: "Heading of the diary entry", comment: "This text is used as a TextField placeholder where the diary entry should be written")
        static let diaryContentTextFieldPlaceholder: String = String(localized: "Your diary entry", defaultValue: "Your diary entry", comment: "This text is used as a TextField placeholder where the diary content should be written")
        static let diaryDateDatepickerDescription: String = String(localized: "Diary entry date", defaultValue: "Diary entry date", comment: "This text is used as a DatePicker placeholder where the diary date should be chosen")
        static let navigationBarTitle: String = String(localized: "New Diary Entry", defaultValue: "New Diary Entry", comment: "This text is used as the navigation bar title in the AddNewEntryView")
        static let saveButtonText: String = String(localized: "Save", defaultValue: "Save", comment: "This is text for the button that saves created entries")
    }
    
    private var datePickerStartingDate: Date {
        let currentDate = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = -150
        if let startingDate = calendar.date(byAdding: dateComponents, to: currentDate) {
            return startingDate
        } else {
            logger.critical("Couldn't create startingDate, returning Date.now")
            return Date.now
        }
    }
    
    var datePickerDateRange: ClosedRange<Date> { datePickerStartingDate...Date.now }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        if let formattedString = formatter.string(for: date) {
            return formattedString
        } else {
            logger.critical("Couldn't format the date, returning date.description")
            return date.description
        }
    }
}
