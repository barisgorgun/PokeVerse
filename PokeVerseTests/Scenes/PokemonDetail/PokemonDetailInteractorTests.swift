//
//  PokemonDetailInteractorTests.swift
//  PokeVerseTests
//
//  Created by Gorgun, Baris on 18.05.2025.
//

import XCTest

@testable import PokeVerse

final class PokemonDetailInteractorTests: XCTestCase {
    private var interactor: PokemonDetailInteractorProtocol!
    private var mockNetworkManager: MockNetworkManager!
    private var pokemonUrl: String!
    private var service: PokemonDetailServiceProtocol!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        mockNetworkManager.currentRequestIndex = 0
        service = PokemonDetailService(networkManager: mockNetworkManager)
        pokemonUrl = "https://pokeapi.co/api/v2/pokemon/4/"
        interactor = PokemonDetailInteractor(pokemonDetailService: service, pokemonUrl: pokemonUrl)
    }

    override func tearDown() {
        mockNetworkManager = nil
        service = nil
        interactor = nil
        pokemonUrl = nil
        super.tearDown()
    }

    func test_fetchData_success_shouldReturnPokemon() async throws {
        // Given
        mockNetworkManager.shouldSucceed = true
        mockNetworkManager.currentRequestIndex = 0
        mockNetworkManager.mockFileSequence = ["pokemonSpecies", "evolutionChain", "pokemon"]

        // When
        let result = await interactor.fetchData()

        // Then
        switch result {
        case .success(let pokemon):
            XCTAssertEqual(pokemon.speciesDetail.name.lowercased(), "charmander")
        case .failure:
            XCTFail("Başarı beklenirken hata alındı")
        }
    }

    func test_fetchData_whenSpeciesFails_shouldReturnFailure() async {
        // Given
        mockNetworkManager.shouldSucceed = false

        // When
        let result = await interactor.fetchData()

        // Then
        switch result {
        case .success:
            XCTFail("Başarısız beklenirken başarı geldi")
        case .failure(let error):
            XCTAssertEqual(error, .contentEmptyData)
        }
    }

    func test_fetchData_whenEvolutionServiceFails_shouldReturnContentEmptyData() async {
        // Given
        mockNetworkManager.shouldSucceed = true
        mockNetworkManager.mockFileSequence = ["pokemonSpecies"]

        // When
        let result = await interactor.fetchData()

        // Then
        switch result {
        case .success:
            XCTFail("Başarısız beklenirken başarı geldi")
        case .failure(let error):
            XCTAssertEqual(error, .contentEmptyData)
        }
    }

    func test_fetchData_whenEvolutionsFails_shouldReturnFailure() async {
        // Given
        mockNetworkManager.shouldSucceed = true
       mockNetworkManager.mockFileSequence = ["pokemonSpecies"]

        let previous = mockNetworkManager.shouldSucceed
        mockNetworkManager.shouldSucceed = false

        // When
        let result = await interactor.fetchData()

        // Then
        switch result {
        case .success:
            XCTFail("Başarısız beklenirken başarı geldi")
        case .failure(let error):
            XCTAssertEqual(error, .contentEmptyData)
        }

        // Restore
        mockNetworkManager.shouldSucceed = previous
    }

    func test_fetchData_returnsSuccess() async throws {
        // Given
        mockNetworkManager.shouldSucceed = true
        mockNetworkManager.mockFileSequence = ["pokemonSpecies", "evolutionChain", "pokemon"]

        // When
        let result = await interactor.fetchData()

        // Then
        switch result {
        case .success(let pokemon):
            XCTAssertEqual(pokemon.speciesDetail.id, 4)
            XCTAssertFalse(pokemon.evolutionDetails.chain.evolvesTo.isEmpty)
            XCTAssertEqual(pokemon.pokemonDetails.name, "charmander")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
}
