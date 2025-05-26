//
//  CoreDataError.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 24.05.2025.
//

import Foundation

enum CoreDataError: Error {
    case saveError(Error)
    case fetchError(Error)
    case duplicateEntry
    case invalidData
    case itemNotFound
    case contextNotAvailable
    case unknownError(Error)

    var localizedDescription: String {
        switch self {
        case .saveError(let error):
            return "Kayıt işlemi hatası: \(error.localizedDescription)"
        case .fetchError(let error):
            return "Veri getirme hatası: \(error.localizedDescription)"
        case .duplicateEntry:
            return "Bu öğe zaten kayıtlı"
        case .invalidData:
            return "Geçersiz veri formatı"
        case .itemNotFound:
            return "Favori bulunamadı"
        case .contextNotAvailable:
            return "Veritabanı bağlantısı yok"
        case .unknownError(let error):
            return "Bilinmeyen bir hata oluştu \(error.localizedDescription)"
        }
    }
}
