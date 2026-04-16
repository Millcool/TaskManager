import Foundation

@Observable
final class PhdApplicationStore {
    static let shared = PhdApplicationStore()

    private let defaultsKey = "phd_application_status_by_id"
    private var statuses: [String: String]

    private init() {
        let raw = UserDefaults.standard.dictionary(forKey: defaultsKey) as? [String: String]
        self.statuses = raw ?? [:]
    }

    func status(for programId: UUID) -> PhdApplicationStatus {
        guard let raw = statuses[programId.uuidString],
              let value = PhdApplicationStatus(rawValue: raw) else {
            return .notApplied
        }
        return value
    }

    func setStatus(_ status: PhdApplicationStatus, for programId: UUID) {
        if status == .notApplied {
            statuses.removeValue(forKey: programId.uuidString)
        } else {
            statuses[programId.uuidString] = status.rawValue
        }
        persist()
    }

    func toggle(_ programId: UUID) {
        let next: PhdApplicationStatus = status(for: programId) == .applied ? .notApplied : .applied
        setStatus(next, for: programId)
    }

    private func persist() {
        UserDefaults.standard.set(statuses, forKey: defaultsKey)
    }
}
