import Foundation
import FinanceCore

/// The profile is chosen from monthly saving capacity before allocating any money.
struct MonthlyBudget {
    let profile: FinancialProfile
    let amountSavedForSecurity: Decimal
    let savingProvide: Decimal
    let longTermSavings: Decimal
    let availableForSaving: Decimal
    let precautionarySavingsAmount: Decimal

    var reserved: Decimal {
        amountSavedForSecurity + savingProvide + longTermSavings + availableForSaving
    }

    init(revenue: Decimal, expenses: Decimal) {
        let capacity = max(0, revenue - expenses)
        profile = revenue == 0 && expenses == 0 ? .none : FinancialProfile.classify(with: capacity)
        let rates: (security: Decimal, provision: Decimal, longTerm: Decimal)
        switch profile {
        case .survivor: rates = (55, 10, 0)
        case .equilibrist: rates = (50, 10, 10)
        case .builder: rates = (45, 15, 10)
        case .strategist: rates = (40, 10, 15)
        case .none: rates = (0, 0, 0)
        }
        amountSavedForSecurity = Self.cents(capacity * rates.security / 100)
        let afterSecurity = capacity - amountSavedForSecurity
        savingProvide = Self.cents(afterSecurity * rates.provision / 100)
        let afterProvision = afterSecurity - savingProvide
        longTermSavings = Self.cents(afterProvision * rates.longTerm / 100)
        availableForSaving = Self.cents((afterProvision - longTermSavings) / 4)
        precautionarySavingsAmount = max(0, expenses) * 3
    }

    func spendable(balance: Decimal) -> Decimal {
        max(0, balance - reserved)
    }

    static func dailyAllowance(remaining: Decimal, on date: Date, calendar: Calendar) -> Decimal {
        guard let days = calendar.range(of: .day, in: .month, for: date) else { return 0 }
        let remainingDays = days.upperBound - calendar.component(.day, from: date)
        return cents(max(0, remaining) / Decimal(remainingDays), rounding: .down)
    }

    private static func cents(_ value: Decimal, rounding: Decimal.RoundingMode = .plain) -> Decimal {
        var input = value
        var result = Decimal.zero
        NSDecimalRound(&result, &input, 2, rounding)
        return result
    }
}
