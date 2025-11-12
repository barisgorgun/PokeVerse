//
//  NetworkUtilities.swift
//  CoreNetwork
//
//  Created by Gorgun, Baris on 11.11.2025.
//

import Foundation

public enum NetworkError: LocalizedError, Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }

    case unknownStatusCode
    case contentEmptyData
    case contentDecoding(error: Error)
    case invalidURL
    case serverError(statusCode: Int)
    case custom(message: String)
    case fileNotFound

    public var errorDescription: String? {
        switch self {
        case .unknownStatusCode:
            "error_unknownStatusCode_description".localized()
        case .contentEmptyData:
            "error_contentEmptyData_description".localized()
        case .contentDecoding:
            "error_contentDecoding_description".localized()
        case .invalidURL:
            "error_invalidURL_description".localized()
        case .serverError:
            "error_serverError_description".localized()
        case .custom(let message):
             message
        case .fileNotFound:
            "error_fileNotFound_description".localized()
        }
    }
}

public extension NetworkError {
    var userMessage: String {
        switch self {
        case .unknownStatusCode:
            "error_unknownStatusCode_message".localized()
        case .contentEmptyData:
            "error_contentEmptyData_message".localized()
        case .contentDecoding:
            "error_contentDecoding_message".localized()
        case .invalidURL:
            "error_unexpected_message".localized()
        case .serverError:
            "error_serverError_message".localized()
        case .custom(let message):
            message
        case .fileNotFound:
            "error_fileNotFound_message".localized()
        }
    }
}

public extension NetworkError {

    static func from(_ error: URLError) -> NetworkError {
        switch error.code {
        case .unsupportedURL, .badURL:
             .invalidURL
        default:
             .custom(message: error.localizedDescription)
        }
    }
}
