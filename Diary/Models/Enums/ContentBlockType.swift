//
//  ContentBlockType.swift
//  Diary
//
//  Created by Dobromir Litvinov on 01.08.24.
//

import Foundation

public enum ContentBlockType: Codable {
    case text(size: TextSize)
    case image
    case divider
    
    enum CodingKeys: CodingKey {
        case type
        case size
    }
    
    enum TypeIdentifier: String, Codable {
        case text
        case image
        case divider
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .text(let size):
            try container.encode(TypeIdentifier.text, forKey: .type)
            try container.encode(size, forKey: .size)
        case .image:
            try container.encode(TypeIdentifier.image, forKey: .type)
        case .divider:
            try container.encode(TypeIdentifier.divider, forKey: .type)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(TypeIdentifier.self, forKey: .type)
        switch type {
        case .text:
            let size = try container.decode(TextSize.self, forKey: .size)
            self = .text(size: size)
        case .image:
            self = .image
        case .divider:
            self = .divider
        }
    }
}
