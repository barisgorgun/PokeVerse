//
//  PokeListInteractor.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import UIKit

final class PokeListInteractor: PokeListInteractorProtocol {

    weak var delegate: PokeListInteractorDelegate?
    private let pokeService: PokemonListServiceProtocol
    private var nextURL: String?

    init(pokeService: PokemonListServiceProtocol) {
        self.pokeService = pokeService
    }

    func fetchData() async  {
        delegate?.handleOutput(.setLoading(true))
        let result = await pokeService.fetchPokemonList()

        delegate?.handleOutput(.setLoading(false))

        switch result {
        case .success(let response):
           let pokeList = response.results
            nextURL = response.next
            DispatchQueue.main.async {
                self.delegate?.handleOutput(.showPokeList(pokeList))
            }
        case .failure(let error):
            delegate?.handleOutput(.showAlert(error))
        }
    }

    func fetchMoreData() async {
        guard let nextURL = nextURL else { return }
        await fetchData(from: nextURL)
    }

    private func fetchData(from url: String) async {
        delegate?.handleOutput(.setLoading(true))
        
        let result = await pokeService.fetchMoreData(from: url)

        delegate?.handleOutput(.setLoading(false))
        
        switch result {
        case .success(let response):
            let pokeList = response.results
            nextURL = response.next
            DispatchQueue.main.async {
                self.delegate?.handleOutput(.showPokeList(pokeList))
            }
        case .failure(let failure):
            delegate?.handleOutput(.showAlert(failure))
        }
    }

    private func fetchImages(for speciesList: [Species]) async {
        await withTaskGroup(of: (String, UIImage?).self) { group in
            for species in speciesList {

                guard let url = species.imageURL else {
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

            /*for await (name, image) in group {
                if let image {
                    ImageCacheManager.shared.setImage(image, for: name)

                    DispatchQueue.main.async {
                        self.delegate?.handleOutput(.showImage(name: name, image: image))
                    }
                }
            }*/
        }
    }
}
