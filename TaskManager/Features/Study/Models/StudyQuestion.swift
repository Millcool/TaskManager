import Foundation

struct StudyQuestion: Identifiable, Hashable {
    let id: UUID
    let question: String
    let answer: String
    let examples: String?

    init(id: UUID = UUID(), question: String, answer: String, examples: String? = nil) {
        self.id = id
        self.question = question
        self.answer = answer
        self.examples = examples
    }
}
