import Foundation
import SwiftData
import SwiftUI

@Observable
final class RulesViewModel {
    var rules: [Rule] = []
    var selectedKind: RuleKind? = nil
    var searchQuery: String = ""

    private var modelContext: ModelContext?

    var filteredRules: [Rule] {
        var result = rules
        if let kind = selectedKind {
            result = result.filter { $0.kind == kind }
        }
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !query.isEmpty {
            result = result.filter {
                $0.title.lowercased().contains(query) ||
                $0.content.lowercased().contains(query)
            }
        }
        return result
    }

    var groupedByKind: [(kind: RuleKind, rules: [Rule])] {
        let groups = Dictionary(grouping: filteredRules, by: { $0.kind })
        return RuleKind.allCases.compactMap { kind in
            guard let list = groups[kind], !list.isEmpty else { return nil }
            return (kind: kind, rules: list)
        }
    }

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetch()
    }

    func fetch() {
        guard let modelContext else { return }
        let descriptor = FetchDescriptor<Rule>(
            sortBy: [
                SortDescriptor(\.sortOrder),
                SortDescriptor(\.createdAt)
            ]
        )
        let all = (try? modelContext.fetch(descriptor)) ?? []
        rules = all.sorted { lhs, rhs in
            if lhs.isPinned != rhs.isPinned { return lhs.isPinned && !rhs.isPinned }
            if lhs.sortOrder != rhs.sortOrder { return lhs.sortOrder < rhs.sortOrder }
            return lhs.createdAt < rhs.createdAt
        }
    }

    func add(title: String, content: String, kind: RuleKind, colorHex: String?, isPinned: Bool) {
        guard let modelContext else { return }
        let nextSortOrder = (rules.filter { $0.kind == kind }.map(\.sortOrder).max() ?? -1) + 1
        let rule = Rule(
            title: title,
            content: content,
            kind: kind,
            colorHex: colorHex,
            sortOrder: nextSortOrder,
            isPinned: isPinned
        )
        modelContext.insert(rule)
        try? modelContext.save()
        fetch()
    }

    func update(
        _ rule: Rule,
        title: String,
        content: String,
        kind: RuleKind,
        colorHex: String,
        isPinned: Bool
    ) {
        rule.title = title
        rule.content = content
        rule.kind = kind
        rule.colorHex = colorHex
        rule.isPinned = isPinned
        rule.updatedAt = Date()
        try? modelContext?.save()
        fetch()
    }

    func delete(_ rule: Rule) {
        modelContext?.delete(rule)
        try? modelContext?.save()
        fetch()
    }

    func togglePinned(_ rule: Rule) {
        rule.isPinned.toggle()
        rule.updatedAt = Date()
        try? modelContext?.save()
        fetch()
    }

    func moveUp(_ rule: Rule) {
        let group = rules.filter { $0.kind == rule.kind }
        guard let index = group.firstIndex(where: { $0.id == rule.id }), index > 0 else { return }
        let other = group[index - 1]
        let tempOrder = rule.sortOrder
        rule.sortOrder = other.sortOrder
        other.sortOrder = tempOrder
        if rule.sortOrder == other.sortOrder {
            rule.sortOrder = index - 1
            other.sortOrder = index
        }
        rule.updatedAt = Date()
        other.updatedAt = Date()
        try? modelContext?.save()
        fetch()
    }

    func moveDown(_ rule: Rule) {
        let group = rules.filter { $0.kind == rule.kind }
        guard let index = group.firstIndex(where: { $0.id == rule.id }), index < group.count - 1 else { return }
        let other = group[index + 1]
        let tempOrder = rule.sortOrder
        rule.sortOrder = other.sortOrder
        other.sortOrder = tempOrder
        if rule.sortOrder == other.sortOrder {
            rule.sortOrder = index + 1
            other.sortOrder = index
        }
        rule.updatedAt = Date()
        other.updatedAt = Date()
        try? modelContext?.save()
        fetch()
    }
}
