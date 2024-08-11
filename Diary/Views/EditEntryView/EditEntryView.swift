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
//struct EditEntryView: View {
//    // MARK: - Logger
//    /// Logger instance
//    private let logger: AppLogger = AppLogger(subsystem: ".com.diaryApp", category: "EditEntryView")
//    
//    // MARK: - Constants
////    private let textBlockFonts: [Font] = [.title, .title2, .body]
//    
//    // MARK: - @Binding variables
//    /// The diary entry to edit
//    @Binding var diaryEntry: DiaryEntry
//    
//    @State var textBlockIdToBinding: [UUID: Binding<String>] = [:]
//    
//    // MARK: - @State variables
//    /// S&D in which mode is the view
//    @State var mode: DiaryEntryViewingMode
//    
//    // MARK: - @FocusState variables
//    /// S&D whether the content text field is focused
////    @FocusState var contentTextFieldFocused: Bool
//    
//    // MARK: - Computed variables
//    /// Returns the earliest date that can be chosen as the date of the diaryEntry
//    private var datePickerStartingDate: Date {
//        let currentDate = Date()
//        let calendar = Calendar.current
//        var dateComponents = DateComponents()
//        dateComponents.year = -100
//        let date100YearsAgo = calendar.date(byAdding: dateComponents, to: currentDate)!
//        return date100YearsAgo
//    }
//    
//    // MARK: - Body
//    var body: some View {
//        VStack {
//            ScrollView {
//                entryDatePicker
//                
//                headingTextField
//                
//                Divider()
//                
//                contentBlocks
//                
//                contentBlockHub // Used as a bottom padding to make all content blocks visible all the time
//                    .opacity(0)
//                    .disabled(true)
//            }
//        }
//        .overlay {
//            contentBlockHubOverlay
//        }
//    }
//    
//    // MARK: - View variables
//    @ViewBuilder var entryDatePicker: some View {
//        DatePicker(LocalizedStrings.diaryDateDatepickerDescription, selection: $diaryEntry.date, in: datePickerStartingDate...Date.now)
//    }
//    
//    @ViewBuilder var headingTextField: some View {
//        TextField(LocalizedStrings.headingTextFieldPlaceholder, text: $diaryEntry.heading, axis: .vertical)
//            .lineLimit(nil)
//            .font(.largeTitle)
//    }
//    
//    @ViewBuilder var contentBlocks: some View {
//        VStack {
//            ForEach(diaryEntry.formattedContent.indices, id: \.self) { index in
//                let block: any ContentBlock = diaryEntry.formattedContent[index]
//                
//                Group {
//                    if let textBlock = block as? TextContentBlock {
//                        produceTextBlock(textBlock)
//                    } else if let imagesBlock = block as? ImagesContentBlock {
//                        produceImagesBlock(imagesBlock)
//                    } else if let dividerBlock = block as? DividerContentBlock {
//                        produceDividerBlock(dividerBlock)
//                    } else {
//                        produceUnidentifiedBlock(block: block)
//                    }
//                }
//                .contextMenu(menuItems: {
//                    Button {
//                        // TODO: Delete the block
//                        diaryEntry.content.remove(at: index)
//                    } label: {
//                        Label("Delete", systemImage: "trash")
//                            .foregroundStyle(.red)
//                    }
//                })
//            }
//        }
//    }
//    
//    @ViewBuilder var contentBlockHubOverlay: some View {
//        VStack {
//            Spacer()
//            
//            contentBlockHub
//        }
//    }
//    
//    @ViewBuilder var contentBlockHub: some View {
//        ContentBlockAdderHub { textSize in
//            let textContentBlock = TextContentBlock(textSize: textSize, content: "This is a sample content")
//            diaryEntry.content.append(.textBlock(textContentBlock))
//        } addImages: { imagesDataArray in
//            logger.info("Got an imagesContentBlock!!!")
//            let imagesBlock = ImagesContentBlock(content: imagesDataArray)
//            diaryEntry.content.append(.imageBlock(imagesBlock))
//        } addDivider: { dividerType in
//            let dividerBlock = DividerContentBlock(content: dividerType)
//            diaryEntry.content.append(.dividerBlock(dividerBlock))
//        }
//    }
//    
//    // MARK: - Private functions
//    private func textFont(for textSize: TextSize) -> Font {
//        let fontSize: Font
//        
//        switch textSize {
//        case .h1:
//            fontSize = .title
//        case .h2:
//            fontSize = .title2
//        case .h3:
//            fontSize = .title3
//        }
//        
//        return fontSize
//    }
//    
//    // MARK: - View building private functions
//    @ViewBuilder private func produceDividerBlock(_ dividerContentBlock: DividerContentBlock) -> some View {
//        Divider()
//            .frame(height: dividerContentBlock.content == DividerType.thick ? 3 : 1)
//            .overlay {
//                Color.black
//            }
//    }
//    
//    @ViewBuilder private func produceImagesBlock(_ imagesContentBlock: ImagesContentBlock) -> some View {
//        let imagesData: [Data] = imagesContentBlock.content
//        
//        ForEach(imagesData.indices, id: \.self) { index in
//            let data: Data = imagesData[index]
//            
//            if let image = Image(data: data) {
//                image
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(RoundedRectangle(cornerRadius: 15))
//            }
//        }
//    }
//    
//    private func produceTextBlock(_ textContentBlock: TextContentBlock) -> some View {
//        let font: Font = textFont(for: textContentBlock.textSize)
//        let binding: Binding<String> = textBinding(for: textContentBlock)
//        
////        Text(textContentBlock.content)
////            .font(font)
////            .lineLimit(nil)
////            .padding()
//        
//        return TextField(LocalizedStrings.contentTextFieldPlaceholder, text: binding, axis: .vertical)
//            .lineLimit(nil)
//            .font(font)
//    }
//    
//    @ViewBuilder func produceUnidentifiedBlock(block: any ContentBlock) -> some View {
//        EmptyView()
//            .onAppear {
//                logger.critical("Couldn't identify and find the view for the following content block: \(block)")
//            }
//    }
//    
//    // MARK: - Private functions
//    private func textBinding(for textContentBlock: TextContentBlock) -> Binding<String> {
//        let blockId: UUID = textContentBlock.id
//        let blockTextSize: TextSize = textContentBlock.textSize
//        
//        let textBinding: Binding<String>
//        
////        if let binding = textBlockIdToBinding[blockId] {
////            textBinding = binding
////        } else {
//        textBinding = Binding(get: {
//            let upToDateContentBlockWrapper: ContentBlockWrapper? = diaryEntry.content.first(where: { contentBlockWrapper in
//                if case .textBlock(let textContentBlock) = contentBlockWrapper {
//                    return textContentBlock.id == blockId
//                }
//                
//                return false
//            })
//            
//            guard let wrapper = upToDateContentBlockWrapper, case .textBlock(let upToDateBlock) = wrapper else {
//                return "VALUE NOT FOUND"
//            }
//            
//            return upToDateBlock.content
//        }, set: { newValue in
//            let indexOfThisBlock: Int? = diaryEntry.content.firstIndex(where: { contentBlockWrapper in
//                if case .textBlock(let textContentBlock) = contentBlockWrapper {
//                    return textContentBlock.id == blockId
//                }
//                
//                return false
//            })
//            
//            if let index = indexOfThisBlock {
//                let newTextContentBlock: TextContentBlock = TextContentBlock(textSize: blockTextSize, content: newValue, id: blockId)
//                let newWrapper: ContentBlockWrapper = ContentBlockWrapper.textBlock(newTextContentBlock)
//                
//                diaryEntry.content[index] = newWrapper
//            }
//        })
//            
////            textBlockIdToBinding[blockId] = textBinding
////        }
//        
//        return textBinding
//    }
//}
//
//fileprivate extension Image {
//    /// Initializes a SwiftUI `Image` from data.
//    init?(data: Data) {
//        if let uiImage = UIImage(data: data) {
//            self.init(uiImage: uiImage)
//        } else {
//            return nil
//        }
//    }
//}

struct EditEntryView: View {
    // MARK: - Logger
    private let logger: AppLogger = AppLogger(subsystem: ".com.diaryApp", category: "EditEntryView")
    
    // MARK: - @Binding variables
    @Binding var diaryEntry: DiaryEntry
    
    @State private var textBlockIdToBinding: [UUID: Binding<String>] = [:]
    
    // MARK: - @State variables
//    @State private var mode: DiaryEntryViewingMode
    
    // MARK: - Computed variables
    private var datePickerStartingDate: Date {
        Calendar.current.date(byAdding: .year, value: -100, to: Date())!
    }
    
    // MARK: - Init
    
    
    // MARK: - Body
    var body: some View {
        VStack {
            ScrollView {
                entryDatePicker
                
                headingTextField
                
                Divider()
                
                contentBlocks
                
                Spacer()
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
            ForEach(diaryEntry.formattedContent.indices, id: \.self) { index in
                let block = diaryEntry.formattedContent[index]
                
                Group {
                    if let textBlock = block as? TextContentBlock {
                        produceTextBlock(textBlock)
                    } else if let imagesBlock = block as? ImagesContentBlock {
                        produceImagesBlock(imagesBlock)
                    } else if let dividerBlock = block as? DividerContentBlock {
                        produceDividerBlock(dividerBlock)
                    } else {
                        produceUnidentifiedBlock(block: block)
                    }
                }
                .contextMenu {
                    Button(role: .destructive) {
                        diaryEntry.content.remove(at: index)
                    } label: {
                        Label("Delete", systemImage: "trash")
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
            diaryEntry.content.append(.textBlock(textContentBlock))
        } addImages: { imagesDataArray in
            logger.info("Got an imagesContentBlock!!!")
            let imagesBlock = ImagesContentBlock(content: imagesDataArray)
            diaryEntry.content.append(.imageBlock(imagesBlock))
        } addDivider: { dividerType in
            let dividerBlock = DividerContentBlock(content: dividerType)
            diaryEntry.content.append(.dividerBlock(dividerBlock))
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
        let binding = textBinding(for: textContentBlock)
        return TextField(
            LocalizedStrings.contentTextFieldPlaceholder,
            text: binding,
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
    private func textBinding(for textContentBlock: TextContentBlock) -> Binding<String> {
        let blockId = textContentBlock.id
        let blockTextSize = textContentBlock.textSize
        
        if let binding = textBlockIdToBinding[blockId] {
            return binding
        } else {
            let binding = Binding<String>(
                get: {
                    let upToDateContentBlockWrapper = diaryEntry.content.first {
                        if case .textBlock(let block) = $0 {
                            return block.id == blockId
                        }
                        return false
                    }
                    
                    guard let wrapper = upToDateContentBlockWrapper, case .textBlock(let upToDateBlock) = wrapper else {
                        return "VALUE NOT FOUND"
                    }
                    
                    return upToDateBlock.content
                },
                set: { newValue in
                    if let index = diaryEntry.content.firstIndex(where: {
                        if case .textBlock(let block) = $0 {
                            return block.id == blockId
                        }
                        return false
                    }) {
                        diaryEntry.content[index] = .textBlock(
                            TextContentBlock(
                                textSize: blockTextSize,
                                content: newValue,
                                id: blockId
                            )
                        )
                    }
                }
            )
            
            textBlockIdToBinding[blockId] = binding
            return binding
        }
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
