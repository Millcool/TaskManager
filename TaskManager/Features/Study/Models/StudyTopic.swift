import Foundation

struct StudyTopic: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    let questions: [StudyQuestion]

    init(id: UUID = UUID(), title: String, summary: String, questions: [StudyQuestion]) {
        self.id = id
        self.title = title
        self.summary = summary
        self.questions = questions
    }
}
