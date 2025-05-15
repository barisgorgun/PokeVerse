//
//  ImageCacheManager.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 8.05.2025.
//

import UIKit

final class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }

    func getImage(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}
