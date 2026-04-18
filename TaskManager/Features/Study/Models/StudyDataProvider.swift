import Foundation

enum StudyDataProvider {
    static let groupCS = StudyContent_CS.makeGroup()
    static let groupML = StudyContent_ML.makeGroup()
    static let groupSystemAnalysis = StudyContent_SystemAnalysis.makeGroup()
    static let groupMath = StudyContent_Math.makeGroup()
    static let groupEnglish = StudyContent_English.makeGroup()
    static let groupPhilosophy = StudyContent_Philosophy.makeGroup()

    static var allGroups: [StudyGroup] {
        [groupCS, groupML, groupSystemAnalysis, groupMath, groupEnglish, groupPhilosophy]
    }

    static func groups(for program: PhdProgram) -> [StudyGroup] {
        var result: [StudyGroup] = []
        var seen = Set<UUID>()

        for exam in program.entranceExams {
            for group in mappedGroups(for: exam, program: program) where !seen.contains(group.id) {
                seen.insert(group.id)
                result.append(group)
            }
        }

        return result
    }

    private static func mappedGroups(for exam: EntranceExam, program: PhdProgram) -> [StudyGroup] {
        let name = exam.name.lowercased()
        let details = exam.details.lowercased()
        let combined = name + " " + details

        if contains(combined, anyOf: ["иностранный", "английск", "english", "toefl", "ielts"]) {
            return [groupEnglish]
        }

        if contains(combined, anyOf: ["философ", "история и философ"]) {
            return [groupPhilosophy]
        }

        if name == "математика" || contains(combined, anyOf: ["высшая математ", "прикладная математ", "дискретн"]) {
            return [groupMath]
        }

        if contains(combined, anyOf: [
            "ии", "искусственн", "машинн", "глубокое обуч", "nlp", "ml",
            "нейросет", "обработка дан", "data science"
        ]) {
            return [groupML]
        }

        if contains(combined, anyOf: ["системн", "управлен", "когнитивн модел", "операций"]) {
            return [groupSystemAnalysis]
        }

        if contains(combined, anyOf: [
            "информатик", "компьютер", "вычислительн", "программ", "алгоритм",
            "кибернетик", "информационн технолог", "информационн безопасн",
            "базы данных", "сети", "системн программир", "ит"
        ]) {
            return [groupCS]
        }

        if exam.type == .portfolio || exam.type == .interview {
            return []
        }

        return [groupCS]
    }

    private static func contains(_ text: String, anyOf substrings: [String]) -> Bool {
        for sub in substrings where text.contains(sub) {
            return true
        }
        return false
    }
}
