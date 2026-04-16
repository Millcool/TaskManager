import Foundation

@Observable
final class PhdProgramsViewModel {
    var searchText: String = ""
    var selectedCity: String? = nil
    var expandedUniversityIds: Set<UUID> = []

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
