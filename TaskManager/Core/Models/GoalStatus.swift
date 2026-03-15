import Foundation

enum GoalStatus: String, Codable, CaseIterable {
    case new = "new"
    case completed = "completed"
    case failed = "failed"

    var title: String {
        switch self {
        case .new: return "Новая"
        case .completed: return "Выполнена"
        case .failed: return "Не выполнена"
        }
    }
}
