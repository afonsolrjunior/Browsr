//
//  CacheService.swift
//  Browsr
//
//  Created by Afonso Rodrigues (Contractor) on 12/02/2023.
//

import Foundation

protocol CacheService {
    func save(imageData: ImageData, key: String)
    func retrieve(key: String) -> ImageData?
}

final class ImageCacheService: CacheService {
    
    let cache = NSCache<NSString, ImageData>()
    
    func save(imageData: ImageData, key: String) {
        cache.setObject(imageData, forKey: NSString(string: key))
    }
    
    func retrieve(key: String) -> ImageData? {
        cache.object(forKey: NSString(string: key))
    }
    
}
