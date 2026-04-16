import SwiftUI

enum PhdApplicationStatus: String, CaseIterable {
    case notApplied
    case applied

    var isApplied: Bool { self == .applied }
}

enum PhdApplicationUrgency {
    case none
    case upcoming
    case soon
    case urgent
    case closed

    var highlightColor: Color? {
        switch self {
        case .none: return nil
        case .upcoming: return Color(hex: "#3B82F6")
        case .soon: return Color(hex: "#F59E0B")
        case .urgent: return Color(hex: "#EF4444")
        case .closed: return AppColors.neutral
        }
    }

    var backgroundOpacity: Double {
        switch self {
        case .none, .closed: return 0.0
        case .upcoming: return 0.10
        case .soon: return 0.18
        case .urgent: return 0.28
        }
    }

    var label: String {
        switch self {
        case .none: return ""
        case .upcoming: return "Скоро приём"
        case .soon: return "Приём идёт"
        case .urgent: return "Срок истекает"
        case .closed: return "Приём закрыт"
        }
    }
}

enum PhdApplicationIndicator {
    static func urgency(for program: PhdProgram, now: Date = Date()) -> PhdApplicationUrgency {
        guard let start = PhdDateParser.date(from: program.applicationStartDate, reference: now),
              let end = PhdDateParser.date(from: program.applicationEndDate, reference: now) else {
            return .none
        }
        let endOfDeadline = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: end) ?? end

        if now > endOfDeadline { return .closed }
        if now >= start {
            let daysLeft = Calendar.current.dateComponents([.day], from: now, to: endOfDeadline).day ?? 0
            return daysLeft <= 3 ? .urgent : .soon
        }
        let daysUntil = Calendar.current.dateComponents([.day], from: now, to: start).day ?? Int.max
        return daysUntil <= 30 ? .upcoming : .none
    }
}
