//
//  DecimalExtension.swift
//  FinanceLab
//
//  Created by Sébastien DAGUIN on 03/11/2025.
//

import Foundation

extension Decimal {
    func roundedFormatted(_ decimals: Int = 2) -> String {
        var value = self
        var result: Decimal = 0
        NSDecimalRound(&result, &value, decimals, .bankers)
        return NSDecimalNumber(decimal: result).stringValue
    }
}
