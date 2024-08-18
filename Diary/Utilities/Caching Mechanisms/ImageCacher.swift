//
//  ImageCacher.swift
//  Diary
//
//  Created by Dobromir Litvinov on 13.08.24.
//

import Foundation
import UIKit

public class ImageCache: ObservableObject {
    // MARK: - Logger
    private var logger: AppLogger = AppLogger(category: "ImageCacher")
    
    // MARK: - Private constants
    private var imageContainer = NSCache<NSString, UIImage>()
    
    // MARK: - Init
    init(totalCostLimit: Int = 0, countLimit: Int = 0) {
        logger.initBegin()
        
        imageContainer.totalCostLimit = totalCostLimit
        imageContainer.countLimit = countLimit
        
        logger.initEnd()
    }
    
    // MARK: - Public functions
    /// Caches the provided image for the provided key
    /// - Parameters:
    ///   - image: The image that should be cached
    ///   - key: The unique key for that image
    public func setImage(_ image: UIImage, for key: String) {
        let imageSizeInBytes = image.jpegData(compressionQuality: 1)?.count ?? 0
        
        imageContainer.setObject(image, forKey: key as NSString, cost: imageSizeInBytes)
        
        objectWillChange.send()
    }
    
    /// Retrieves the already cached image from cache
    /// - Parameter key: The key associated with the cached image
    /// - Returns: If exists, the cached image, otherwise  nil
    public func getImage(for key: String) -> UIImage? {
        return imageContainer.object(forKey: key as NSString)
    }
    
    
    /// Removes the cached image for the given key
    /// - Parameter key: The key associated with the cached image
    public func removeImage(for key: String) {
        imageContainer.removeObject(forKey: key as NSString)
        
        objectWillChange.send()
    }
}
