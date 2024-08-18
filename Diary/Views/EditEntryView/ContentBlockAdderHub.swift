//
//  ContentBlockAdderHub.swift
//  Diary
//
//  Created by Dobromir Litvinov on 04.08.24.
//

import SwiftUI
import PhotosUI
import UIKit

struct ContentBlockAdderHub: View {
    // MARK: - Private constants
    private let numberOfButtonsInHstack: CGFloat = 3
    
    // MARK: - Function variables
    var addText: (TextSize) -> Void
    var addImages: ([Data]) -> Void
    var addDivider: (DividerType) -> Void
    
    // MARK: - @State variables
    @State private var selectedImageItems: [PhotosPickerItem] = []
    @State private var selectedImagesData: [Int: Data] = [:]
    @State var geometryReaderHeight: CGFloat = .infinity
    
    // MARK: - Computed variables
    private var expectedNumberOfImages: Int { selectedImageItems.count }
    
    // MARK: - Init
    init(addText: @escaping (TextSize) -> Void, addImages: @escaping ([Data]) -> Void, addDivider: @escaping (DividerType) -> Void) {
        self.addText = addText
        self.addImages = addImages
        self.addDivider = addDivider
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // geometry.size.width = spacing * (n of blocks + 1) + symbol font size * n of blocks
                let symbolFontSize: CGFloat = geometry.size.width * 0.1
                let hstackSpacing: CGFloat = (geometry.size.width - symbolFontSize * numberOfButtonsInHstack) / (numberOfButtonsInHstack + 1)
                
                Capsule()
                    .foregroundStyle(.blue)
                
                produceButtonsHStack(hstackSpacing: hstackSpacing, symbolFontSize: symbolFontSize)
            }
        }
        .aspectRatio(5/1, contentMode: .fit)
        .frame(maxWidth: 300)
        .onChange(of: selectedImageItems) {
            for (index, selectedItem) in selectedImageItems.enumerated() {
                Task {
                    if let data = try? await selectedItem.loadTransferable(type: Data.self) {
                        selectedImagesData[index] = data
                    } else {
                        print("Failed to load image data for selectedItem '\(selectedItem)'")
                    }
                }
            }
        }
        .onChange(of: selectedImagesData) {
            guard selectedImagesData.count == expectedNumberOfImages else { return }
            
            let sortedKeys = selectedImagesData.keys.sorted()
            
            let sortedImagesData: [Data] = sortedKeys.map({ key in
                return selectedImagesData[key]!
            })
            
            unselectChosenAndLoadedImages()
            
            addImages(sortedImagesData)
            
        }
    }
    
    // MARK: - View variables
    @ViewBuilder private func produceButtonsHStack(hstackSpacing: CGFloat, symbolFontSize: CGFloat) -> some View {
        HStack(spacing: hstackSpacing) {
            addTextButton
            addImageButton
            addDividerButton
        }
        .font(.system(size: symbolFontSize))
        .foregroundStyle(.white)
    }
    
    @ViewBuilder private var addTextButton: some View {
        Menu {
            Button("H3") { addText(.h3) }
            Button("H2") { addText(.h2) }
            Button("H1") { addText(.h1) }
            
        } label: {
            Image(systemName: "textformat")
        } primaryAction: {
            addText(.h3)
        }
        
    }
    
    @ViewBuilder private var addImageButton: some View {
        PhotosPicker(selection: $selectedImageItems, matching: .images) {
            Image(systemName: "photo")
        }
    }
    
    @ViewBuilder private var addDividerButton: some View {
        Menu {
            Button("Thick") { addDivider(.thick) }
            Button("Thin") { addDivider(.thin) }
        } label: {
            Image(systemName: "rectangle.split.1x2")
        } primaryAction: {
            addDivider(.thin)
        }
    }
    
    // MARK: - Private functions
    private func unselectChosenAndLoadedImages() {
        selectedImageItems = []
        selectedImagesData = [:]
    }
}

fileprivate struct ContentBlockAdderHubPreviews: View {    
    var body: some View {
        VStack {
            Spacer()
            ContentBlockAdderHub(addText: {
                print("Add text with size '\($0)' pressed")
            }, addImages: {
                print("Add image with data of \($0) pressed")
            }, addDivider: {
                print("Add divider with type '\($0)' pressed")
            })
        }
    }
}

#Preview {
    ContentBlockAdderHubPreviews()
}
