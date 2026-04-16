import Foundation

enum ExamType: String, CaseIterable {
    case written = "Письменный"
    case oral = "Устный"
    case test = "Тест"
    case interview = "Собеседование"
    case portfolio = "Портфолио"
}

struct EntranceExam: Identifiable, Hashable {
    let id: UUID
    let name: String
    let type: ExamType
    let details: String
    let maxScore: Int?
}
