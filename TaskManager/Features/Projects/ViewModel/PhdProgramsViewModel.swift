import Foundation

enum PhdViewMode: String, CaseIterable, Identifiable {
    case grouped
    case table

    var id: String { rawValue }

    var title: String {
        switch self {
        case .grouped: return "По вузам"
        case .table: return "Таблицей"
        }
    }

    var systemImage: String {
        switch self {
        case .grouped: return "square.stack.3d.up.fill"
        case .table: return "tablecells.fill"
        }
    }
}

@Observable
final class PhdProgramsViewModel {
    var searchText: String = ""
    var selectedCity: String? = nil
    var expandedUniversityIds: Set<UUID> = []
    var viewMode: PhdViewMode = .grouped

    let universities = PhdProgramsDataProvider.universities
    let allPrograms = PhdProgramsDataProvider.programs

    var cities: [String] {
        Array(Set(universities.map(\.city))).sorted()
    }

    var filteredUniversities: [University] {
        universities.filter { university in
            let matchesCity = selectedCity == nil || university.city == selectedCity
            let matchesSearch: Bool
            if searchText.isEmpty {
                matchesSearch = true
            } else {
                let query = searchText.lowercased()
                let nameMatch = university.name.lowercased().contains(query)
                    || university.shortName.lowercased().contains(query)
                let cityMatch = university.city.lowercased().contains(query)
                let programMatch = programs(for: university).contains {
                    $0.name.lowercased().contains(query)
                        || $0.code.lowercased().contains(query)
                        || $0.fieldOfStudy.lowercased().contains(query)
                }
                matchesSearch = nameMatch || cityMatch || programMatch
            }
            return matchesCity && matchesSearch
        }
    }

    func programs(for university: University) -> [PhdProgram] {
        PhdProgramsDataProvider.programs(for: university)
    }

    var filteredPrograms: [PhdProgram] {
        let universityIds = Set(filteredUniversities.map(\.id))
        let query = searchText.lowercased()
        return allPrograms.filter { program in
            guard universityIds.contains(program.universityId) else { return false }
            if query.isEmpty { return true }
            let university = PhdProgramsDataProvider.university(for: program)
            let universityMatch = university.map {
                $0.name.lowercased().contains(query)
                    || $0.shortName.lowercased().contains(query)
                    || $0.city.lowercased().contains(query)
            } ?? false
            return universityMatch
                || program.name.lowercased().contains(query)
                || program.code.lowercased().contains(query)
                || program.fieldOfStudy.lowercased().contains(query)
        }
    }

    func university(for program: PhdProgram) -> University? {
        PhdProgramsDataProvider.university(for: program)
    }

    func setViewMode(_ mode: PhdViewMode) {
        viewMode = mode
    }

    func toggleUniversity(_ id: UUID) {
        if expandedUniversityIds.contains(id) {
            expandedUniversityIds.remove(id)
        } else {
            expandedUniversityIds.insert(id)
        }
    }

    func isExpanded(_ id: UUID) -> Bool {
        expandedUniversityIds.contains(id)
    }

    func selectCity(_ city: String?) {
        selectedCity = city
    }
}
