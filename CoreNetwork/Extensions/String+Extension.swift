//
//  String+Extension.swift
//  CoreNetwork
//
//  Created by Gorgun, Baris on 11.11.2025.
//

import Foundation

extension String {

    func localized() -> String {
        String(localized: LocalizationValue(self))
    }
}
