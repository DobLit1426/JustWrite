//
//  ImageCache.swift
//  Diary
//
//  Created by Dobromir Litvinov on 13.08.24.
//

import Foundation
import UIKit

public class ImageCache: ObservableObject {
    // MARK: - Logger
    private var logger: AppLogger = AppLogger(category: "ImageCacher")
    
    // MARK: - Public constants
    @Published private var shared = NSCache<NSString, NSArray>()
    
    // MARK: - Init
    init() {
        logger.initBegin()
        logger.initEnd()
    }
    
    // MARK: - Public functions
    public func getImages(for key: UUID) -> [UIImage]? {
        let functionName = "getImages(for key: String)"
        logger.functionBegin(functionName)
        
        if let images = shared.object(forKey: key.uuidString as NSString) as? [UIImage] {
            logger.functionEnd(functionName)
            return images
        }
        
        logger.warning("Couldn't find the cached image for the key '\(key)'")
        
        logger.functionEnd(functionName, successfull: false)
        return nil
    }
    
    public func setImages(_ images: [UIImage], for key: UUID) {
        let functionName = "setImage(_ images: [UIImage], for key: UUID)"
        logger.functionBegin(functionName)
        
        let array = NSArray(array: images)
        shared.setObject(array, forKey: key.uuidString as NSString)
        
        logger.functionEnd(functionName)
    }
    
    private func removeImages(for key: UUID) {
        let functionName = "removeImage(for key: UUID)"
        logger.functionBegin(functionName)
        
        shared.removeObject(forKey: key.uuidString as NSString)
        
        logger.functionEnd(functionName)
    }
}
