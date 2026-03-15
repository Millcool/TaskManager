import Foundation

enum GoalPeriod: String, Codable, CaseIterable {
    case day = "day"
    case week = "week"
    case month = "month"
    case year = "year"

    var title: String {
        switch self {
        case .day: return "День"
        case .week: return "Неделя"
        case .month: return "Месяц"
        case .year: return "Год"
        }
    }

    var shortTitle: String {
        switch self {
        case .day: return "Д"
        case .week: return "Н"
        case .month: return "М"
        case .year: return "Г"
        }
    }
}
