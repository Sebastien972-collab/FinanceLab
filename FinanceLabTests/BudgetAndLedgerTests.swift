import Foundation
import FinanceCore
import Testing
@testable import FinanceLab

@MainActor
struct BudgetAndLedgerTests {
    @Test func distributionUsesIncomeAfterExpensesBeforeChoosingRates() {
        let plan = MonthlyBudget(revenue: 4000, expenses: 1000)
        #expect(plan.profile == .strategist)
        #expect(plan.amountSavedForSecurity == 1200)
        #expect(plan.savingProvide == 180)
        #expect(plan.longTermSavings == 243)
        #expect(plan.availableForSaving == Decimal(string: "344.25")!)
        #expect(plan.reserved == MonthlyBudget(revenue: 4000, expenses: 1000).reserved)
        #expect(MonthlyBudget(revenue: 251, expenses: 1).profile == .equilibrist)
        #expect(MonthlyBudget(revenue: 252, expenses: 1).profile == .builder)
        #expect(MonthlyBudget(revenue: 100, expenses: 200).reserved == 0)
    }

    @Test func allowanceIncludesTodayAndUsesCalendarMonthLength() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(secondsFromGMT: 0))
        let date = try #require(calendar.date(from: DateComponents(year: 2028, month: 2, day: 28)))
        #expect(MonthlyBudget.dailyAllowance(remaining: 301, on: date, calendar: calendar) == 150.5)
        let lastDay = try #require(calendar.date(byAdding: .day, value: 1, to: date))
        #expect(MonthlyBudget.dailyAllowance(remaining: 301, on: lastDay, calendar: calendar) == 301)
        #expect(MonthlyBudget.dailyAllowance(remaining: -20, on: lastDay, calendar: calendar) == 0)
    }

    @Test func replayAndConflictingIdentifiers() throws {
        let first = try LedgerChange.create.adjustment(previous: nil, proposed: -50, linkedProject: nil, requestedProject: "A")
        #expect(first == -50)
        let replay = try LedgerChange.create.adjustment(previous: -50, proposed: -50, linkedProject: "A", requestedProject: "A")
        #expect(replay == nil)
        #expect(throws: LoginError.self) {
            try LedgerChange.create.adjustment(previous: -50, proposed: -50, linkedProject: "A", requestedProject: "B")
        }
        #expect(throws: LoginError.self) {
            try LedgerChange.edit.adjustment(previous: nil, proposed: -50, linkedProject: nil, requestedProject: nil)
        }
        let replayDelete = try LedgerChange.delete.adjustment(previous: nil, proposed: 0, linkedProject: nil, requestedProject: nil)
        #expect(replayDelete == nil)
    }

    @Test func contributionsAreAppliedToTheLatestSavedAmount() throws {
        let first = try LedgerChange.savings(after: -20, previous: 100, entry: -20)
        let second = try LedgerChange.savings(after: -20, previous: first, entry: -20)
        #expect(second == 140)
        let adjustment = try LedgerChange.delete.adjustment(previous: -20, proposed: 0, linkedProject: "A", requestedProject: nil)
        let reversal = try #require(adjustment)
        #expect(try LedgerChange.savings(after: reversal, previous: second, entry: 0) == 120)
    }
}
