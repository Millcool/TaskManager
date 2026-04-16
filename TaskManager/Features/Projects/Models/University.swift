import Foundation

struct University: Identifiable, Hashable {
    let id: UUID
    let name: String
    let shortName: String
    let city: String
    let logoSystemImage: String
    let websiteURL: String?
}
