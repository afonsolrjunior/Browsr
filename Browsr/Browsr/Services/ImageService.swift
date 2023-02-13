//
//  ImageService.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import UIKit
import Combine
import Browsr_Lib

protocol ImageService {
    func getImage(for urlString: String) -> AnyPublisher<UIImage, Never>
}

final class UIImageService: ImageService {
    
    private let cacheService: CacheService
    private let imageDataService: ImageDataService
    
    init(
        cacheService: CacheService,
        imageDataService: ImageDataService
    ) {
        self.cacheService = cacheService
        self.imageDataService = imageDataService
    }
    
    func getImage(for urlString: String) -> AnyPublisher<UIImage, Never> {
        let cachedImageData = cacheService.retrieve(key: urlString)
        guard cachedImageData == nil else {
            let defaultData = cachedImageData?.data ?? Data()
            let defaultImage = UIImage(data: defaultData) ?? UIImage()
            let resized = self.resize(defaultImage)
            return Just(resized).eraseToAnyPublisher()
        }
        
        return imageDataService.getImageData(for: urlString)
            .replaceError(with: Data())
            .map {[weak self] imageData in
                guard let self else {
                    return UIImage()
                }
                self.cacheService.save(imageData: .init(data: imageData), key: urlString)
                let image = UIImage(data: imageData) ?? UIImage()
                
                return self.resize(image)
            }.eraseToAnyPublisher()
        
    }
    
    private func resize(_ image: UIImage) -> UIImage {
        let size = CGSize(width: 40, height: 40)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    

    
}
