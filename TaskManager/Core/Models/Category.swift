import Foundation
import SwiftData

@Model
final class Category {
    var id: UUID = UUID()
    var name: String = ""
    var colorHex: String = "#8B5CF6"

    @Relationship(deleteRule: .nullify, inverse: \Goal.category)
    var goals: [Goal]?

    init(name: String, colorHex: String = "#8B5CF6") {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
    }
}
