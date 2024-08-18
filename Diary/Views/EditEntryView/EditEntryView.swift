//
//  EditEntryView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 27.10.2023.
//

import SwiftUI
import UIKit

fileprivate struct LocalizedStrings {
    static let diaryDateDatepickerDescription: String = String(localized: "New Diary Entry - datePicker placeholder", defaultValue: "Date", comment: "This text is used as a DatePicker placeholder where the diary date should be chosen")
    
    // TextField placeholders
    static let headingTextFieldPlaceholder: String = String(localized: "TextField diary entry heading placeholder", defaultValue: "Heading", comment: "This text is used as the placeholder for the TextField for the diary entry heading")
}

/// Used to edit entry using Binding.
/// - Important: This View provides interface to edit the provided diary entry, however it is **not** specified, where this interface can be used. This means, it can be used as well in a View to create new entry as in View to edit existing diary entries.
struct EditEntryView: View {
    // MARK: - Logger
    private let logger: AppLogger = AppLogger(subsystem: ".com.diaryApp", category: "EditEntryView")
    
    // MARK: - @Binding variables
    @Binding var diaryEntry: DiaryEntry
    
    // MARK: - @EnvironmentObject variables
    @EnvironmentObject var contentBlocksCache: ContentBlocksCache
    
    // MARK: - Private constants
    private let datePickerStartingDate: Date = Calendar.current.date(byAdding: .year, value: -100, to: Date())!
    private let contentBlockHubPlaceHolderId = "contentBlockHubSpaceTakerForBottomPaddingID"
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollValue in
                Group {
                    entryDatePicker
                    headingTextField
                    
                    contentBlocks
                        .onChange(of: diaryEntry.indexedEntities) { oldValue, newValue in
                            if newValue.count > oldValue.count, let _ = diaryEntry.indexedEntities.last?.id {
                                withAnimation(.easeInOut) {
                                    scrollValue.scrollTo(contentBlockHubPlaceHolderId)
                                }
                            }
                        }
                    
                    contentBlockHub
                        .disabled(true)
                        .opacity(0)
                        .id(contentBlockHubPlaceHolderId)
                }
                .padding()
            }
        }
        .overlay(contentBlockHubOverlay)
        .task(priority: .background) {
            // Automatically cache blocks
            diaryEntry.indexedEntities.forEach { indexedEntity in
                let id = indexedEntity.id
                
                if !contentBlocksCache.keys.contains(where: { $0 == id }) {
                    cacheContentBlock(for: indexedEntity)
                }
            }
        }
    }
    
    // MARK: - View variables
    private var contentBlocks: some View {
        LazyVStack {
            ForEach(diaryEntry.indexedEntities) { indexedEntity in
                let id = indexedEntity.id
                
                if let contentBlock = contentBlocksCache[id] {
                    Group {
                        if let imagesBlock = contentBlock as? ImagesContentBlock {
                            ImagesContentBlockView(imagesBlock)
                        } else if let textBlock = contentBlock as? TextContentBlock {
                            let textBinding = Binding {
                                return textBlock.content
                            } set: { newValue in
                                var newTextBlock = textBlock
                                newTextBlock.content = newValue
                                contentBlocksCache[id] = newTextBlock
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    if let block = contentBlocksCache[id], let updatedTextBlock = block as? TextContentBlock, updatedTextBlock.content == newValue {
                                        diaryEntry.updateTextBlock(id: id, newText: newValue)
                                    }
                                }
                            }
                            
                            TextContentBlockView(textSize: textBlock.textSize, text: textBinding)
                        } else if let dividerBlock = contentBlock as? DividerContentBlock {
                            DividerContentBlockView(dividerBlock)
                        } else {
                            Text(contentBlock.id.uuidString)
                        }
                        
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            diaryEntry.removeBlock(with: id)
                            contentBlocksCache.removeValue(forKey: id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .onAppear {
                        logger.info("Retrieved block with id '\(id)' from cache")
                    }
                } else {
                    Rectangle()
                        .hidden()
                        .task(priority: .userInitiated) {
                            cacheContentBlock(for: indexedEntity)
                        }
                }
            }
        }
    }
    
    private var contentBlockHubOverlay: some View {
        VStack {
            Spacer()
            contentBlockHub
        }
    }
    
    private var contentBlockHub: some View {
        ContentBlockAdderHub { textSize in
            let textContentBlock = TextContentBlock(textSize: textSize, content: "")
            diaryEntry.appendNewBlock(textContentBlock)
        } addImages: { imagesDataArray in
            logger.info("Got an imagesContentBlock!!!")
            let imagesBlock = ImagesContentBlock(content: imagesDataArray)
            diaryEntry.appendNewBlock(imagesBlock)
        } addDivider: { dividerType in
            let dividerBlock = DividerContentBlock(content: dividerType)
            diaryEntry.appendNewBlock(dividerBlock)
        }
    }
    
    private var entryDatePicker: some View {
        DatePicker(
            LocalizedStrings.diaryDateDatepickerDescription,
            selection: $diaryEntry.date,
            in: datePickerStartingDate...Date.now
        )
    }
    
    private var headingTextField: some View {
        TextField(
            LocalizedStrings.headingTextFieldPlaceholder,
            text: $diaryEntry.heading,
            axis: .vertical
        )
        .lineLimit(nil)
        .font(.largeTitle)
    }
    
    // MARK: - Private functions
    private func cacheContentBlock(for indexedEntity: ContentBlockLinkedIndexedEntity) {
        let functionName = "cacheContentBlock(for indexedEntity: ContentBlockLinkedIndexedEntity)"
        logger.functionBegin(functionName)
        
        if let contentBlock = diaryEntry.getBlock(for: indexedEntity) {
            let id = indexedEntity.id
            
            contentBlocksCache[id] = contentBlock
            
            logger.info("Cached block with id '\(id)'")
            logger.functionEnd(functionName)
        }
        
        logger.error("Couldn't get block for indexedEntity \(indexedEntity)")
        logger.functionEnd(functionName, successfull: false)
    }
}

#Preview {
    @State var entry: DiaryEntry = DebugDummyValues.diaryEntry(entryHeading: "Role of the AI in our modern world")
    
    return EditEntryView(diaryEntry: $entry)
}
