//
//  Untitled.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 9.05.2025.
//

import UIKit

@testable import PokeVerse

final class MockNetworkManager: NetworkManagerProtocol {

    // MARK: - Constants

    enum Constants {
        static let statusCode = 500
    }

    // MARK: - Properties

    var shouldSucceed: Bool = true
    var mockFileSequence: [String] = []
    var currentRequestIndex = 0

    func request<T>(service: any APIRequest, type: T.Type) async -> Result<T, NetworkError> where T: Decodable {
        guard shouldSucceed else {
            return .failure(.serverError(statusCode: 500))
        }

        guard currentRequestIndex < mockFileSequence.count else {
            return .failure(.fileNotFound)
        }

        let fileName = mockFileSequence[currentRequestIndex]

        do {
            let data: T = try loadItemsFromJSON(from: fileName)
            currentRequestIndex += 1
            return .success(data)
        } catch {
            return .failure(.unknownStatusCode)
        }
    }

    private func loadItemsFromJSON<T: Decodable>(from fileName: String) throws -> T {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json") else {
            throw NetworkError.fileNotFound
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }

    func requestImage(from url: URL) async -> Result<UIImage, NetworkError> {
        .success(UIImage(systemName: "photo")!)
    }

    func loadExpectedData<T: Decodable>(from fileName: String) throws -> T {
        return try loadItemsFromJSON(from: fileName)
    }
}
