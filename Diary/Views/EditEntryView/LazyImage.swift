//
//  LazyImage.swift
//  Diary
//
//  Created by Dobromir Litvinov on 15.08.24.
//

import Foundation
import SwiftUI

struct LazyImage: View, Equatable {
    // MARK: - Logger
    private let logger = AppLogger(category: "LazyImage")
    
    // MARK: - @EnvironmentObject
    @EnvironmentObject var imagesCache: ImageCache
    
    // MARK: - Private constants
    private let imageData: Data
    private let cacheKey: String
    
    // MARK: - @StateObject variables
    @State private var image: Image? = nil
    
    // MARK: - Init
    init(from data: Data, blockId: UUID, indexInBlock: Int) {
        logger.initBegin()
        
        self.imageData = data
        self.cacheKey = "\(blockId)[\(indexInBlock)]"
        
        logger.initEnd()
    }
    
    // MARK: - Body
    var body: some View {
        if let image = image {
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 15))
        } else {
            Rectangle()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .task(priority: .utility) {
                    await loadImage()
                }
        }
    }
    
    // MARK: - Private functions
    private func loadImage() async {
        let functionName = "loadImage()"
        logger.functionBegin(functionName)

        if let cachedImage = await imagesCache.getImage(for: cacheKey) {
            self.image = await Image(uiImage: cachedImage)
            logger.functionEnd(functionName)
            return
        }
        
        guard let uiimage = await UIImage(data: imageData) else {
            logger.error("Couldn't create uiimage from data")
            logger.functionEnd(functionName, successfull: false)
            return
        }
        
        await imagesCache.setImage(uiimage, for: cacheKey)
        
        self.image = await Image(uiImage: uiimage)
        
        logger.functionEnd(functionName)
    }
    
    // MARK: - Static public functions
    static func == (lhs: LazyImage, rhs: LazyImage) -> Bool {
        (lhs.image == rhs.image) && (lhs.imageData == rhs.imageData)
    }
}

#Preview {
    LazyImage(from: Data(), blockId: UUID(), indexInBlock: 4)
}
