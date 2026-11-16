import Foundation
import Testing
@testable import FinanceLab

@MainActor
struct FinancialProfileSummaryTests {

    @Test
    func questionDatabase_UsesStableIdentifiers() {
        let firstLoad = Question.questionDatabase.map(\.id)
        let secondLoad = Question.questionDatabase.map(\.id)

        #expect(firstLoad == secondLoad)
        #expect(Set(firstLoad).count == firstLoad.count)
    }

    @Test
    func summary_SeparatesIncomeAndExpensesUsingQuestionMetadata() {
        let user = Customer.guest
        let salaryQuestion = Question.questionDatabase.first { $0.label == "Revenus stables" }!
        let chargesQuestion = Question.questionDatabase.first { $0.label == "Charges fixes" }!
        let savingsQuestion = Question.questionDatabase.first { $0.label == "Épargne engagée" }!

        let answers = [
            Answer(content: "2100", user: user, question: salaryQuestion),
            Answer(content: "850", user: user, question: chargesQuestion),
            Answer(content: "150", user: user, question: savingsQuestion)
        ]

        let summary = FinancialProfileSummary.from(answers: answers)

        #expect(summary.monthlyRevenue == 2100)
        #expect(summary.monthlyExpenses == 1000)
    }
}
