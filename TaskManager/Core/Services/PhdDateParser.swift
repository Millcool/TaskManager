import Foundation

enum PhdDateParser {
    private static let monthMap: [String: Int] = [
        "января": 1, "январь": 1,
        "февраля": 2, "февраль": 2,
        "марта": 3, "март": 3,
        "апреля": 4, "апрель": 4,
        "мая": 5, "май": 5,
        "июня": 6, "июнь": 6,
        "июля": 7, "июль": 7,
        "августа": 8, "август": 8,
        "сентября": 9, "сентябрь": 9,
        "октября": 10, "октябрь": 10,
        "ноября": 11, "ноябрь": 11,
        "декабря": 12, "декабрь": 12
    ]

    static func date(from russianString: String, reference: Date = Date(), calendar: Calendar = .current) -> Date? {
        let trimmed = russianString.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let parts = trimmed.split(separator: " ").map(String.init)
        guard parts.count >= 2,
              let day = Int(parts[0]),
              let month = monthMap[parts[1]] else { return nil }

        let year: Int
        if parts.count >= 3, let explicitYear = Int(parts[2]) {
            year = explicitYear
        } else {
            let refYear = calendar.component(.year, from: reference)
            var candidate = DateComponents(year: refYear, month: month, day: day)
            guard let candidateDate = calendar.date(from: candidate) else { return nil }
            if reference.timeIntervalSince(candidateDate) > 180 * 24 * 60 * 60 {
                candidate.year = refYear + 1
            }
            return calendar.date(from: candidate)
        }

        return calendar.date(from: DateComponents(year: year, month: month, day: day))
    }
}
