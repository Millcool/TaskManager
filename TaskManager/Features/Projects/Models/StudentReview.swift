import Foundation

struct StudentReview: Identifiable {
    let id: UUID
    let authorName: String
    let year: Int
    let rating: Int
    let text: String
    let pros: [String]
    let cons: [String]
}
