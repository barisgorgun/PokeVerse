//
//  String+Extension.swift
//  Core
//
//  Created by Gorgun, Baris on 11.11.2025.
//

import Foundation

import Foundation

extension String {

    func localized() -> String {
        String(localized: LocalizationValue(self))
    }
}
