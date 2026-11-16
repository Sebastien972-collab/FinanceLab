//
//  AnswersService.swift
//  FinanceLab
//
//  Created by Dembo on 30/10/2025.
//  Refactored by Codex on 20/03/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AnswersService {
    static let shared = AnswersService()
    private init() {}
    
    private var db: Firestore { Firestore.firestore() }

    private var currentUserId: String {
        get throws {
            guard let uid = Auth.auth().currentUser?.uid else {
                throw LoginError.custom("Connecte-toi pour enregistrer ton profil financier.")
            }
            return uid
        }
    }

    private func answersCollection(for userId: String) -> CollectionReference {
        db.collection(DatabaseKey.users.rawValue)
            .document(userId)
            .collection("answers")
    }

    func fetchAllUserAnswers(for profile: Customer? = nil) async throws -> [Answer] {
        let uid = try currentUserId
        let snapshot = try await answersCollection(for: uid).getDocuments()

        let allQuestions = Dictionary(uniqueKeysWithValues: Question.questionDatabase.map { ($0.id, $0) })

        return snapshot.documents.compactMap { document in
            guard
                let data = try? document.data(as: AnswersData.self),
                let question = allQuestions[data.idQuestion]
            else {
                return nil
            }

            return data.toAnswer(user: profile ?? CustomerManager.shared.currentUser, question: question)
        }
        .sorted { lhs, rhs in
            questionIndex(for: lhs.question) < questionIndex(for: rhs.question)
        }
    }

    func upsertAnswer(_ answer: Answer) async throws -> [Answer] {
        let uid = try currentUserId
        let answerData = answer.toAnswerData()

        try await answersCollection(for: uid)
            .document(answer.question.id.uuidString)
            .setData(Firestore.Encoder().encode(answerData))

        let answers = try await fetchAllUserAnswers()
        try await syncFinancialSummary(with: answers)
        return answers
    }
    
    func replaceAllAnswers(_ answers: [Answer]) async throws -> [Answer] {
        let uid = try currentUserId
        let collection = answersCollection(for: uid)
        let batch = db.batch()

        for answer in answers {
            try batch.setData(
                from: answer.toAnswerData(),
                forDocument: collection.document(answer.question.id.uuidString)
            )
        }

        try await batch.commit()
        let persistedAnswers = try await fetchAllUserAnswers()
        try await syncFinancialSummary(with: persistedAnswers)
        return persistedAnswers
    }

    func deleteAnswer(id: UUID) async throws -> [Answer] {
        let uid = try currentUserId
        try await answersCollection(for: uid).document(id.uuidString).delete()
        let remainingAnswers = try await fetchAllUserAnswers()
        try await syncFinancialSummary(with: remainingAnswers)
        return remainingAnswers
    }

    private func syncFinancialSummary(with answers: [Answer]) async throws {
        let summary = FinancialProfileSummary.from(answers: answers)
        try await CustomerManager.shared.updateFinancialProfileSummary(summary)
        CustomerManager.shared.currentUser.answers = answers
    }
    
    private func questionIndex(for question: Question) -> Int {
        Question.questionDatabase.firstIndex(where: { $0.id == question.id }) ?? .max
    }
}
