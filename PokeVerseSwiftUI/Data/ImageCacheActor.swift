//
//  ImageCacheActor.swift
//  PokeVerseSwiftUI
//
//  Created by Gorgun, Baris on 12.11.2025.
//

import UIKit

protocol ImageCacheActorProtocol: AnyObject {
    func getImage(for url: URL) async -> UIImage?
    func setImage(_ image: UIImage, for url: URL) async
    func clearCache() async
}

actor ImageCacheActor: ImageCacheActorProtocol {
    nonisolated(unsafe) static let shared = ImageCacheActor()

    private var cache: [URL: UIImage] = [ : ]

    func getImage(for url: URL) -> UIImage? {
        cache[url]
    }

    func setImage(_ image: UIImage, for url: URL) {
        cache[url] = image
    }

    func clearCache() {
        cache.removeAll()
    }
}
