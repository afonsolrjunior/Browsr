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
            return Just(defaultImage).eraseToAnyPublisher()
        }
        
        return imageDataService.getImageData(for: urlString)
            .replaceError(with: Data())
            .map {[weak self] imageData in
            self?.cacheService.save(imageData: .init(data: imageData), key: urlString)
            return UIImage(data: imageData) ?? UIImage()
        }.eraseToAnyPublisher()
        
    }
    

    
}
