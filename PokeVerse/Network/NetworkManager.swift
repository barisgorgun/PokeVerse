//
//  NetworkManager.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import UIKit

protocol NetworkManagerProtocol {
    func request<T: Decodable>(service: APIRequest, type: T.Type) async -> Result<T, NetworkError>
    func requestImage(from url: URL) async -> Result<UIImage, NetworkError>
}

final class NetworkManager: NetworkManagerProtocol {

    func request<T: Decodable>(
        service: APIRequest,
        type: T.Type
    ) async -> Result<T, NetworkError> {
        do {
            print(service.urlRequest)
            let (data, response) = try await URLSession.shared.data(for: service.urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.unknownStatusCode)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(.serverError(statusCode: httpResponse.statusCode))
            }

            return try .success(decode(data: data, type: T.self))

        } catch let urlError as URLError {
            return .failure(NetworkError.from(urlError))
        } catch {
            return .failure(.custom(message: error.localizedDescription))
        }
    }

    func requestImage(from url: URL) async -> Result<UIImage, NetworkError> {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return .failure(.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1))
            }

            guard let image = UIImage(data: data) else {
                return .failure(.custom(message: "Veri görsele dönüştürülemedi."))
            }

            return .success(image)

        } catch let urlError as URLError {
            return .failure(NetworkError.from(urlError))
        } catch {
            return .failure(.custom(message: error.localizedDescription))
        }
    }

    private func decode<T: Decodable>(data: Data?, type: T.Type) throws -> T {
        guard let data, !data.isEmpty else {
            throw NetworkError.contentEmptyData
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.contentDecoding(error: error)
        }
    }
}
