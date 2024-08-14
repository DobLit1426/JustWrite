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
    static let contentTextFieldPlaceholder: String = String(localized: "TextField diary entry content placeholder", defaultValue: "Content of your diary entry", comment: "This text is used as the placeholder for the TextField for the diary entry content")
    
    // Mode picker
    //    static let modePickerLabel: String = String(localized: "Edit-View Mode Picker Label", defaultValue: "Mode", comment: "Used as the label for the Edit-View Mode Picker")
    //    static let modePickerEdit: String = String(localized: "Edit-View Mode Picker Edit option", defaultValue: "Edit", comment: "Used as the edit option text for the Edit-View Mode Picker")
    //    static let modePickerView: String = String(localized: "Edit-View Mode Picker View option", defaultValue: "View", comment: "Used as the view option text for the Edit-View Mode Picker")
}

/// Used to edit entry using Binding.
/// - Important: This View provides interface to edit the provided diary entry, however it is **not** specified, where this interface can be used. This means, it can be used as well in a View to create new entry as in View to edit existing diary entries.
struct EditEntryView: View {
    // MARK: - Logger
    private let logger: AppLogger = AppLogger(subsystem: ".com.diaryApp", category: "EditEntryView")
    
    // MARK: - @Binding variables
    @Binding var diaryEntry: DiaryEntry
    
    // MARK: - @StateObject variables
    @ObservedObject private var imagesCache = ImageCache()
    
//    @State private var textBlockIdToBinding: [UUID: Binding<String>] = [:]
    
    // MARK: - @State variables
    //    @State private var mode: DiaryEntryViewingMode
    
    // MARK: - Computed variables
    private var datePickerStartingDate: Date {
        Calendar.current.date(byAdding: .year, value: -100, to: Date())!
    }
    
    // MARK: - Init
    init(diaryEntry: Binding<DiaryEntry>) {
        self._diaryEntry = diaryEntry
        
        diaryEntry.wrappedValue.content.forEach { block in
            if let imagesBlock = block as? ImagesContentBlock {
                cacheImagesBlock(imagesBlock)
            }
        }
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            ScrollView {
                entryDatePicker
                
                headingTextField
                
                Divider()
                
                contentBlocks
                
                Spacer()
                contentBlockHub
                    .opacity(0)
                    .disabled(true)
            }
        }
        .overlay(contentBlockHubOverlay)
    }
    
    // MARK: - View variables
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
    
    private var contentBlocks: some View {
        VStack {
            ForEach(diaryEntry.indexedEntities, id: \.id) { indexedEntity in
                EmptyView()
                    .onAppear {
                        if imagesCache.getImages(for: indexedEntity.id) == nil, let block = diaryEntry.getBlock(with: indexedEntity.id), let imagesBlock = block as? ImagesContentBlock {
                            logger.critical("CACHED id \(imagesBlock.id)")
                        }
                    }
                
                if let uiimages = imagesCache.getImages(for: indexedEntity.id) {
                    ForEach(uiimages.indices, id: \.self) { index in
                        Image(uiImage: uiimages[index])
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .onAppear {
                                logger.critical("CACHE WORKS!")
                            }
                    }
                } else if let contentBlock = diaryEntry.getBlock(for: indexedEntity) {
                    produceViewForBlock(contentBlock)
                } else {
                    EmptyView()
                        .onAppear {
                            logger.critical("Couldn't find the content block with the id \(indexedEntity.id)")
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
            let textContentBlock = TextContentBlock(textSize: textSize, content: "This is a sample content")
            diaryEntry.appendNewBlock(textContentBlock)
        } addImages: { imagesDataArray in
            logger.info("Got an imagesContentBlock!!!")
            let imagesBlock = ImagesContentBlock(content: imagesDataArray)
            diaryEntry.appendNewBlock(imagesBlock)
            
            cacheImagesBlock(imagesBlock)
        } addDivider: { dividerType in
            let dividerBlock = DividerContentBlock(content: dividerType)
            diaryEntry.appendNewBlock(dividerBlock)
        }
    }
    
    // MARK: - Private View Functions
    private func textFont(for textSize: TextSize) -> Font {
        switch textSize {
        case .h1: return .title
        case .h2: return .title2
        case .h3: return .title3
        }
    }
    
    @ViewBuilder private func produceViewForBlock(_ contentBlock: any ContentBlock) -> some View {
        Group {
            if let textBlock = contentBlock as? TextContentBlock {
                produceTextBlock(textBlock)
            } else if let imagesBlock = contentBlock as? ImagesContentBlock {
                
                
                produceImagesBlock(imagesBlock)
            } else if let dividerBlock = contentBlock as? DividerContentBlock {
                produceDividerBlock(dividerBlock)
            } else {
                produceUnidentifiedBlock(block: contentBlock)
            }
        }
//        .contextMenu {
//            Button(role: .destructive) {
//                diaryEntry.removeBlock(with: contentBlock.id)
//            } label: {
//                Label("Delete", systemImage: "trash")
//            }
//        }
    }
    
    @ViewBuilder
    private func produceDividerBlock(_ dividerContentBlock: DividerContentBlock) -> some View {
        Divider()
            .frame(height: dividerContentBlock.content == DividerType.thick ? 3 : 1)
            .overlay(Color.black)
    }
    
    @ViewBuilder
    private func produceImagesBlock(_ imagesContentBlock: ImagesContentBlock) -> some View {
        LazyVStack {
            ForEach(imagesContentBlock.content, id: \.self) { data in
                if let image = Image(data: data) {
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
        }
    }
    
    private func produceTextBlock(_ textContentBlock: TextContentBlock) -> some View {
        let textBinding = textBinding(for: textContentBlock)
        
        return TextField(
            LocalizedStrings.contentTextFieldPlaceholder,
            text: textBinding,
            axis: .vertical
        )
        .lineLimit(nil)
        .font(textFont(for: textContentBlock.textSize))
    }
    
    @ViewBuilder
    private func produceUnidentifiedBlock(block: any ContentBlock) -> some View {
        EmptyView()
            .onAppear {
                logger.critical("Couldn't identify and find the view for the following content block: \(block)")
            }
    }
    
    // MARK: - Private functions
    private func cacheImagesBlock(_ imagesBlock: ImagesContentBlock) {
        let uiimages: [UIImage] = imagesBlock.content.compactMap { UIImage(data: $0) }
        imagesCache.setImages(uiimages, for: imagesBlock.id)
        
        logger.critical("CACHED imagesBlock with id \(imagesBlock.id)")
    }
    
    private func textBinding(for textContentBlock: TextContentBlock) -> Binding<String> {
        let blockId = textContentBlock.id
        let binding: Binding<String> = Binding(get: {
            if let block = diaryEntry.getBlock(with: blockId), let textBlock = block as? TextContentBlock {
                return textBlock.content
            }
            
            return "VALUE NOT FOUND"
        }) { newValue in
//            let newBlock: TextContentBlock = TextContentBlock(textSize: textContentBlock.textSize, content: newValue, id: blockId)
//            diaryEntry.updateBlock(with: newBlock)
            
            diaryEntry.updateTextBlock(id: blockId, newText: newValue)
        }
        return binding
    }
}

fileprivate extension Image {
    init?(data: Data) {
        guard let uiImage = UIImage(data: data) else { return nil }
        self.init(uiImage: uiImage)
    }
}

#Preview {
    @State var entry: DiaryEntry = DebugDummyValues.diaryEntry(entryHeading: "Role of the AI in our modern world", includeMarkdownText: true)
    
    return EditEntryView(diaryEntry: $entry)
}
