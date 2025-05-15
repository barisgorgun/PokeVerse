//
//  NetworkUtilities.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 2.05.2025.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum NetworkError: LocalizedError {
    case unknownStatusCode
    case contentEmptyData
    case contentDecoding(error: Error)
    case invalidURL
    case serverError(statusCode: Int)
    case custom(message: String)
    case fileNotFound

    var errorDescription: String? {
        switch self {
        case .unknownStatusCode:
             "Sunucudan beklenmeyen bir yanıt alındı."
        case .contentEmptyData:
             "Sunucudan geçerli bir veri alınamadı."
        case .contentDecoding:
             "Veri çözümlenirken bir hata oluştu."
        case .invalidURL:
             "Geçersiz istek URL’si."
        case .serverError(let code):
             "Sunucu hatası oluştu. Hata kodu: \(code)"
        case .custom(let message):
             message
        case .fileNotFound:
            "Dosya bulunamadı."
        }
    }
}

extension NetworkError {

    static func from(_ error: URLError) -> NetworkError {
        switch error.code {
        case .unsupportedURL, .badURL:
             .invalidURL
        default:
             .custom(message: error.localizedDescription)
        }
    }
}
