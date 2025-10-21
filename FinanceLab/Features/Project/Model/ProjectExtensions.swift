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
    
    static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
}
extension Project {
    static var preview: Project {
        let project = Project(
            name: "Voyage Japon 🇯🇵",
            currentImage: "airplane.departure",
            finalDate: Calendar.current.date(byAdding: .month, value: 12, to: .now)!,
            amount: 2400
        )
        try? project.addTransaction(200)
        try? project.addTransaction(150)
        return project
    }
    static var previews: [Project] {
        [
            Project(
                name: "Maison 🏡",
                currentImage: "house.fill",
                finalDate: Calendar.current.date(byAdding: .year, value: 20, to: .now)!,
                amount: 200_000
            ),
            Project(
                name: "Nouvelle voiture 🚗",
                currentImage: "car.fill",
                finalDate: Calendar.current.date(byAdding: .year, value: 5, to: .now)!,
                amount: 20_000
            ),
            Project.preview
        ]
    }
    
    func toProjectData() -> ProjectData {
        ProjectData(
            id: self.id,
            userID: UserManager.shared.currentUser.id,
            name: self.name,
            goalAmount: (NSDecimalNumber(decimal: self.goalAmount)).doubleValue,
            amountSaved: (NSDecimalNumber(decimal: self.amountSaved)).doubleValue,
            finalDate: self.deadline,
            currentImage: self.currentImage ?? CategoryIcon.selectionFill.rawValue
        )
    }
}
