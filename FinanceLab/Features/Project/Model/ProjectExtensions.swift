//
//  ProjectExtensions.swift
//  FinanceLab
//
//  Created by Sébastien Daguin on 30/09/2025.
//

import Foundation
import FinanceCore

extension Project {
    var progressPercentage: Double {
        guard goalAmount > 0 else { return 0 }
        let ratio = (amountSaved as NSDecimalNumber).doubleValue /
        (goalAmount as NSDecimalNumber).doubleValue
        return min(max(ratio * 100, 0), 100)
    }
    
    var numberOfMonthsToReachGoal: Int {
        Int(deadline.timeIntervalSinceNow / (60 * 60 * 24 * 30))
    }
    
    var deadlineFormatted: String {
        Project.formattedDate(deadline)
    }
    var monthlyAmount: Decimal {
        let months = DateCalculator.monthsBetween(startedDate, deadline)
            guard months > 0 else { return goalAmount } // Si moins d’un mois, le total = montant à payer
            return goalAmount / Decimal(months)
    }
    static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
    var formattedGoalAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        let number = NSDecimalNumber(decimal: goalAmount)
        let formatted = formatter.string(from: number) ?? "\(goalAmount)"
        
        return "\(formatted)\(currency.symbol)"
    }

}
extension Project {
    static var preview: Project {
        let project = Project(
            name: "Voyage Japon 🇯🇵",
            finalDate: Calendar.current.date(byAdding: .month, value: 12, to: .now)!,
            amount: 2400
        )
        try? project.addTransaction(200)
        try? project.addTransaction(150)
        project.updateIcon("airplane.departure")
        return project
    }
    static var previews: [Project] {
        [
            Project(name: "Maison 🏡", iconName: "house.fill", finalDate: Calendar.current.date(byAdding: .year, value: 20, to: .now)!, amount: 200_000),
            Project(name: "Nouvelle voiture 🚗", iconName:  "car.fill", finalDate: Calendar.current.date(byAdding: .year, value: 5, to: .now)!, amount: 20_000),
            Project.preview
        ]
    }
    
    func toProjectData() -> ProjectData {
        ProjectData(id: self.id, name: self.name, endDate: self.deadline, iconName: self.iconName ?? "", creationDate: self.creationDate, amountTotal: self.goalAmount, amountSaved: self.amountSaved)
    }
}


extension Decimal {
    func toDoucble() -> Double {
        NSDecimalNumber(decimal: self).doubleValue
    }
}
