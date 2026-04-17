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
    let infoURL: String?
    let programPdfURL: String?

    init(
        id: UUID,
        name: String,
        type: ExamType,
        details: String,
        maxScore: Int?,
        infoURL: String? = nil,
        programPdfURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.details = details
        self.maxScore = maxScore
        self.infoURL = infoURL
        self.programPdfURL = programPdfURL
    }
}
