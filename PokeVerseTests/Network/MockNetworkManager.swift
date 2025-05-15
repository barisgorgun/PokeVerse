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
    var mockFileName: String

    init(mockFileName: String) {
        self.mockFileName = mockFileName
    }

    func request<T>(service: any PokeVerse.NetworkServiceProtocol, type: T.Type) async -> Result<T, NetworkError> where T : Decodable {
        do {
            guard shouldSucceed else {
                return .failure(.serverError(statusCode: Constants.statusCode))
            }

            let data: T = try loadItemsFromJSON()
            return .success(data)

        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.unknownStatusCode)
        }
    }

    func requestImage(from url: URL) async -> Result<UIImage, NetworkError> {

        guard shouldSucceed else {
            return .failure(.serverError(statusCode: Constants.statusCode))
        }

        let image = UIImage(systemName: "photo")
        return .success(image!)
    }

    private func loadItemsFromJSON<T: Decodable>() throws -> T {
        guard let path = Bundle(for: type(of: self)).path(forResource: mockFileName, ofType: "json") else {
            throw NetworkError.fileNotFound
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
