//
//  NewEntryPopover.swift
//  Diary
//
//  Created by Dobromir Litvinov on 25.10.2023.
//

import SwiftUI

enum DiaryEntryViewingMode: String, CaseIterable {
    case edit = "Edit"
    case view = "Preview"
}

struct NewEntryPopover: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var mode: DiaryEntryViewingMode = .edit
    @State var heading: String = ""
    @State var content: String = ""
    
    @State var showAreYouSureAlert: Bool = false
    
    var onSave: (_ diaryEntry: DiaryEntry) -> Void
    
    init(onSave: @escaping (_: DiaryEntry) -> Void) {
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker(selection: $mode) {
                    Text(DiaryEntryViewingMode.edit.rawValue).tag(DiaryEntryViewingMode.edit)
                    Text(DiaryEntryViewingMode.view.rawValue).tag(DiaryEntryViewingMode.view)
                } label: {
                    Text("Mode")
                }
                .pickerStyle(.segmented)
                
                VStack {
                    if mode == .view {
                        Text(heading)
                            .font(.largeTitle)
                        ForEach(parseMarkdownText(content), id: \.self) { line in
                            MarkdownText(text: line)
                        }
                    } else {
                        TextField("Heading", text: $heading, axis: .vertical)
                            .lineLimit(nil)
                            .font(.title)
                        
                        TextField("Content of your diary entry", text: $content, axis: .vertical)
                            .lineLimit(nil)
                            .font(.body)
                    }
                    
                }
                .animation(.easeInOut, value: mode)
                
                Spacer()
            }
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
                        if !heading.isEmpty || !content.isEmpty {
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
            .padding()
        }
        .interactiveDismissDisabled()
        .alert("Are you sure?" + "\n" + "You will loose the diary entry you wrote", isPresented: $showAreYouSureAlert) {
            Button("Continue writing the entry", role: .cancel) { showAreYouSureAlert = false }
            Button("Delete the entry I wrote", role: .destructive) {
                dismiss()
            }
        }
    }
    
    private func saveDiaryEntryAndExit() {
        onSave(DiaryEntry(heading: heading, content: content))
        dismiss()
    }
    
    func parseMarkdownText(_ text: String) -> [String] {
        return text.components(separatedBy: "\n")
    }
}

struct MarkdownText: View {
    private let title1Prefix: String = "# "
    private let title2Prefix: String = "## "
    private let title3Prefix: String = "### "
    
    let text: String
    
    var body: some View {
        if text.hasPrefix(title1Prefix) {
            return Text(text.dropFirst(title1Prefix.count))
                .font(.largeTitle)
        } else if text.hasPrefix(title2Prefix) {
            return Text(text.dropFirst(title1Prefix.count))
                .font(.title)
        } else if text.hasPrefix(title3Prefix) {
            return Text(text.dropFirst(title3Prefix.count))
                .font(.headline)
        } else {
            return Text(text)
        }
    }
}

#Preview {
    NewEntryPopover(onSave: { entryToSave in
        print(entryToSave.description)
    })
}
