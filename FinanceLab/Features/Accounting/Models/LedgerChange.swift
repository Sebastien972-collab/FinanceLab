import Foundation

nonisolated enum LedgerChange {
    case create, edit, delete

    /// A nil adjustment confirms a replay without writing to the ledger again.
    func adjustment(previous: Decimal?, proposed: Decimal, linkedProject: String?,
                    requestedProject: String?) throws -> Decimal? {
        switch (self, previous) {
        case (.create, let previous?):
            guard proposed == previous, requestedProject == linkedProject else {
                throw LoginError.custom("Cette opération existe déjà avec des valeurs différentes.")
            }
            return nil
        case (.edit, nil):
            throw LoginError.custom("Cette transaction a été supprimée.")
        case (.delete, nil):
            return nil
        default:
            return proposed - (previous ?? 0)
        }
    }

    static func savings(after adjustment: Decimal, previous: Decimal, entry: Decimal) throws -> Decimal {
        let total = previous - adjustment
        guard entry <= 0, total >= 0 else {
            throw LoginError.custom("Ce montant est incompatible avec la cagnotte.")
        }
        return total
    }
}
