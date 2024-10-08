//
//  NewEntryPopover.swift
//  Diary
//
//  Created by Dobromir Litvinov on 25.10.2023.
//

import SwiftUI

enum DiaryEntryViewingMode: CaseIterable {
    case edit
    case view
}

struct NewEntryPopover: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var diaryEntry: DiaryEntry = DiaryEntry()
    
    @State var showAreYouSureAlert: Bool = false
    
    var onSave: (_ diaryEntry: DiaryEntry) -> Void
    
    init(onSave: @escaping (_: DiaryEntry) -> Void) {
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            EditEntryView(diaryEntry: $diaryEntry)
                .navigationTitle("New diary entry")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            saveDiaryEntryAndExit()
                        } label: {
                            Text("Save")
                        }
                        .padding()
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            if !diaryEntry.heading.isEmpty || !diaryEntry.content.isEmpty {
                                showAreYouSureAlert = true
                            } else {
                                dismiss()
                            }
                        } label: {
                            Text("Cancel")
                        }
                        .padding()
                    }
                }
            
            Spacer()
        }
        .interactiveDismissDisabled()
        .confirmationDialog("Are you sure?", isPresented: $showAreYouSureAlert) {
            Button("Delete the entry I wrote", role: .destructive) { dismiss() }
            Button("Continue writing the entry", role: .cancel) { showAreYouSureAlert = false }
        } message: {
            Text("You will loose the diary entry you wrote")
        }
    }
    
    private func saveDiaryEntryAndExit() {
        onSave(diaryEntry)
        dismiss()
    }
    
    func parseMarkdownText(_ text: String) -> [String] {
        return text.components(separatedBy: "\n")
    }
}

#Preview {
    NewEntryPopover(onSave: { entryToSave in
        print(entryToSave)
    })
}
