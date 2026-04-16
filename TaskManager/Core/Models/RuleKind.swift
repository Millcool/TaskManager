import Foundation

enum RuleKind: String, CaseIterable, Codable {
    case rule = "rule"
    case strategy = "strategy"
    case principle = "principle"

    var title: String {
        switch self {
        case .rule: return "Правило"
        case .strategy: return "Стратегия"
        case .principle: return "Принцип"
        }
    }

    var pluralTitle: String {
        switch self {
        case .rule: return "Правила"
        case .strategy: return "Стратегии"
        case .principle: return "Принципы"
        }
    }

    var icon: String {
        switch self {
        case .rule: return "list.bullet.rectangle.fill"
        case .strategy: return "map.fill"
        case .principle: return "star.fill"
        }
    }

    var defaultColorHex: String {
        switch self {
        case .rule: return "#3B82F6"
        case .strategy: return "#10B981"
        case .principle: return "#F59E0B"
        }
    }
}
