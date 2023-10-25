//
//  AddNewEntry.swift
//  Diary
//
//  Created by Dobromir Litvinov on 08.09.2023.
//

import SwiftUI
import os

struct AddNewEntryView: View {
    private let logger: Logger = Logger(subsystem: ".com.diaryApp", category: "AddNewEntryView")
    
    @Binding var currentTab: CurrentTab
    @Environment(\.modelContext) private var context
    
    private var viewModel: AddNewEntryViewModel
    
    @State var heading: String = ""
    @State var content: String = ""
    @State var date: Date = Date()
    
    init(currentTab: Binding<CurrentTab>) {
        self.viewModel = AddNewEntryViewModel()
        self._currentTab = currentTab
    }
    
    
    var formattedDate: String { viewModel.formatDate(date) }
    var allTextFieldsFilled: Bool { !heading.isEmpty && !content.isEmpty }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                DatePicker(AddNewEntryViewModel.LocalizedStrings.diaryDateDatepickerDescription, selection: $date, in: viewModel.datePickerDateRange)
                
                Divider()
                
                Text(formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                TextField(AddNewEntryViewModel.LocalizedStrings.diaryHeadingTextFieldPlaceholder, text: $heading, axis: .vertical)
                    .lineLimit(nil)
                    .font(.title)
                    .bold()
                
                TextField(AddNewEntryViewModel.LocalizedStrings.diaryContentTextFieldPlaceholder, text: $content, axis: .vertical)
                    .font(.body)
                    .lineLimit(nil)
                
                Spacer()
            }
            .padding()
            .navigationTitle(AddNewEntryViewModel.LocalizedStrings.navigationBarTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        saveEntry()
                    } label: {
                        Text(AddNewEntryViewModel.LocalizedStrings.saveButtonText)
                    }
                    .disabled(!allTextFieldsFilled)
                    .opacity(allTextFieldsFilled ? 1 : 0)
                }
            }
        }
    }
    
    private func saveEntry() {
        logger.info("Starting function to save the diary entry")
        
        let entryToSave = DiaryEntry(heading: heading, content: content, date: date)
        
        // Save it using SwiftData
        logger.info("Saving the diary entry with SwiftData...")
        context.insert(entryToSave)
        logger.info("Successfully saved the diary entry with SwiftData")
        
        // Clear the fields for next use
        heading = ""
        content = ""
        date = Date()
        
        
        // Switch to the HomeView
        currentTab = .homeView
        logger.info("Successfully saved the diary entry")
    }
}

#Preview {
    let currentTab = Binding<CurrentTab>(
        get: { .addNewEntryView },
        set: { _ in })
    
    return AddNewEntryView(currentTab: currentTab)
}
