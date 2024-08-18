//
//  ContentBlocksCache.swift
//  Diary
//
//  Created by Dobromir Litvinov on 17.08.24.
//

import Foundation

/// Caches content blocks to prevent excessive Read and Write operations to SwiftData, resulting in smoother experience
class ContentBlocksCache: ObservableObject {
    // MARK: - Logger
    private let logger = AppLogger(category: "ContentBlocksCache")
    
    // MARK: - @Published variables
    @Published private var shared: [UUID: (any ContentBlock)] = [:]
    
    // MARK: - Public variables
    public var keys: Dictionary<UUID, (any ContentBlock)>.Keys = [:].keys
    
    // MARK: - Init
    init() {
        logger.initBegin()
        
        logger.initEnd()
    }
    
    // MARK: - Public functions
    subscript(id: UUID) -> (any ContentBlock)? {
        get {
            return shared[id]
        }
        set(newValue) {
            shared[id] = newValue
            updateKeys()
        }
    }
    
    /// Removes the given key and its associated cached content block from the dictionary.
    /// - Parameter key: The key to remove along with its associated value.
    /// - Returns: The content block that was removed, or nil if the key was not present in the cache.
    @discardableResult
    func removeValue(forKey key: UUID) -> (any ContentBlock)? {
        let functionName = "removeValue(forKey key: UUID) -> (any ContentBlock)?"
        logger.functionBegin(functionName)
        
        guard let result = shared.removeValue(forKey: key) else {
            logger.error("Couldn't find the cached content block with the key '\(key)' and remove it")
            logger.functionEnd(functionName, successfull: false)
            return nil
        }
        
        updateKeys()
        
        logger.functionEnd(functionName)
        
        return result
    }
    
    // MARK: - Private functions
    /// Updates the keys variable to ensure it's always up-to-date
    private func updateKeys() {
        let functionName = "updateKeys()"
        logger.functionBegin(functionName)
        
        keys = shared.keys
        
        logger.functionEnd(functionName)
    }
}
