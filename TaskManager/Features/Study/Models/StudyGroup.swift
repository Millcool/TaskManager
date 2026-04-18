import Foundation

struct StudyGroup: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let iconSystemName: String
    let topics: [StudyTopic]

    init(id: UUID = UUID(), title: String, subtitle: String, iconSystemName: String, topics: [StudyTopic]) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.iconSystemName = iconSystemName
        self.topics = topics
    }
}
