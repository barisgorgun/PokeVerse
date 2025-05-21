//
//  PokeListInteractor.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import UIKit

final class PokeListInteractor: PokeListInteractorProtocol {

    private let pokeService: PokemonListServiceProtocol
    private var nextURL: String?

    init(pokeService: PokemonListServiceProtocol) {
        self.pokeService = pokeService
    }

    func fetchData() async -> Result<[Species], Error> {
        let result = await pokeService.fetchPokemonList()

        switch result {
        case .success(let response):
            nextURL = response.next
            return .success(response.results)

        case .failure(let error):
            return .failure(error)
        }
    }

    func fetchMoreData() async -> Result<[Species], Error> {
        guard let nextURL else {
            return .failure(NetworkError.contentEmptyData)
        }

        let result = await pokeService.fetchMoreData(from: nextURL)

        switch result {
        case .success(let response):
            self.nextURL = response.next
            return .success(response.results)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func fetchImages(for speciesList: [Species]) async {
        await withTaskGroup(of: (String, UIImage?).self) { group in
            for species in speciesList {

                /*  guard let url = species.imageURL else {
                    continue
                }

                group.addTask {
                    let result = await self.pokeService.fetchImages(from: url)
                    switch result {
                    case .success(let image):
                        return (species.name, image)
                    case .failure:
                        return (species.name, nil)
                    }
                }
            }

          for await (name, image) in group {
                if let image {
                    ImageCacheManager.shared.setImage(image, for: name)

                    DispatchQueue.main.async {
                        self.delegate?.handleOutput(.showImage(name: name, image: image))
                    }
                }*/
            }
        }
    }
}
