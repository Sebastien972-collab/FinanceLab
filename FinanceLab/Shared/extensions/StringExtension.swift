//
//  StringExtension.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 04/11/2025.
//

import Foundation


extension String {
    var isValidEmail: Bool {
        guard !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        let emailFormat =
        "(?:[A-Z0-9a-z._%+-]+)@(?:[A-Za-z0-9-]+)\\.(?:[A-Za-z]{2,64})"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return predicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        guard !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, count >= 6 else { return false }
        return true
    }
}
