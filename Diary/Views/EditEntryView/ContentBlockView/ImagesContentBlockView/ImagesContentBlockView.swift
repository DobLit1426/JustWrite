//
//  ImagesContentBlockView.swift
//  Diary
//
//  Created by Dobromir Litvinov on 18.08.24.
//

import SwiftUI

struct ImagesContentBlockView: View, Equatable {
    // MARK: - Logger
    private let logger = AppLogger(category: "ImagesContentBlockView")
    
    // MARK: - Constants
    let imagesData: [Data]
    let id: UUID
    
    // MARK: - Init
    init(_ imagesContentBlock: ImagesContentBlock) {
        logger.initBegin()
        
        self.imagesData = imagesContentBlock.content
        self.id = imagesContentBlock.id
        
        logger.initEnd()
    }
    
    // MARK: - Body
    var body: some View {
        if imagesData.count > 0 {
            VStack {
                switch imagesData.count {
                case 1:
                    singleImage(data: imagesData[0])
                case 2:
                    twoImages(image1: imagesData[0], image2: imagesData[1])
                case 3:
                    threeImages(image1: imagesData[0], image2: imagesData[1], image3: imagesData[2])
                case 4:
                    fourImages(image1: imagesData[0], image2: imagesData[1], image3: imagesData[2], image4: imagesData[3])
                default:
                    moreThanFourImages()
                }
            }
        }
    }
    
    // MARK: - Private functions
    private func singleImage(data: Data) -> some View {
        LazyImage(from: data, blockId: id, indexInBlock: 0)
            .aspectRatio(contentMode: .fit)
    }
    
    @ViewBuilder private func twoImages(image1: Data, image2: Data) -> some View {
        HStack {
            SquareFrame {
                LazyImage(from: image1, blockId: id, indexInBlock: 0)
            }
            SquareFrame {
                LazyImage(from: image2, blockId: id, indexInBlock: 1)
            }
        }
    }
    
    @ViewBuilder private func threeImages(image1: Data, image2: Data, image3: Data) -> some View {
        HStack {
            let rectangle = RoundedRectangle(cornerRadius: 15)
            
            rectangle
                .aspectRatio(0.5, contentMode: .fill)
                .overlay(
                    LazyImage(from: image1, blockId: id, indexInBlock: 0)
                        .scaledToFill()
                )
                .clipShape(rectangle)

            
            VStack {
                SquareFrame {
                    LazyImage(from: image2, blockId: id, indexInBlock: 1)
                }
                SquareFrame {
                    LazyImage(from: image3, blockId: id, indexInBlock: 2)
                }
            }
        }
    }
    
    @ViewBuilder private func fourImages(image1: Data, image2: Data, image3: Data, image4: Data) -> some View {
        HStack {
            VStack {
                SquareFrame {
                    LazyImage(from: image1, blockId: id, indexInBlock: 0)
                }
                SquareFrame {
                    LazyImage(from: image2, blockId: id, indexInBlock: 1)
                }
            }
            
            VStack {
                SquareFrame {
                    LazyImage(from: image3, blockId: id, indexInBlock: 2)
                }
                SquareFrame {
                    LazyImage(from: image4, blockId: id, indexInBlock: 3)
                }
            }
        }
    }
    
    private func moreThanFourImages() -> some View {
        guard imagesData.count > 4 else {
            logger.fatalError("Got fewer than 5 images (least expected count)")
            fatalError("Got fewer than 5 images (least expected count)")
        }
        
        return HStack {
            VStack {
                SquareFrame {
                    LazyImage(from: imagesData[0], blockId: id, indexInBlock: 0)
                }
                SquareFrame {
                    LazyImage(from: imagesData[1], blockId: id, indexInBlock: 1)
                }
            }
            
            VStack {
                SquareFrame {
                    LazyImage(from: imagesData[2], blockId: id, indexInBlock: 2)
                }
                
                SquareFrame {
                    ZStack {
                        LazyImage(from: imagesData[3], blockId: id, indexInBlock: 3)
                            .blur(radius: 10)
                        Image(systemName: "plus")
                            .padding()
                            .aspectRatio(1, contentMode: .fill)
                            .foregroundStyle(.white)
                            .onTapGesture {
                                // TODO: - Show other images
                            }
                    }
                }
            }
        }
    }
    
    // MARK: - Static functions
    static func == (lhs: ImagesContentBlockView, rhs: ImagesContentBlockView) -> Bool {
        (lhs.id == rhs.id) && (lhs.imagesData == rhs.imagesData)
    }
}
