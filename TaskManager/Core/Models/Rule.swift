import Foundation
import SwiftData

@Model
final class Rule {
    var id: UUID = UUID()
    var title: String = ""
    var content: String = ""
    var kindRaw: String = RuleKind.rule.rawValue
    var colorHex: String = "#3B82F6"
    var sortOrder: Int = 0
    var isPinned: Bool = false
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    var kind: RuleKind {
        get { RuleKind(rawValue: kindRaw) ?? .rule }
        set { kindRaw = newValue.rawValue }
    }

    init(
        title: String,
        content: String = "",
        kind: RuleKind = .rule,
        colorHex: String? = nil,
        sortOrder: Int = 0,
        isPinned: Bool = false
    ) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.kindRaw = kind.rawValue
        self.colorHex = colorHex ?? kind.defaultColorHex
        self.sortOrder = sortOrder
        self.isPinned = isPinned
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
