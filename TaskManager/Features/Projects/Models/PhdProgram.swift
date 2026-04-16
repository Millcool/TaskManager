import Foundation

struct PhdProgram: Identifiable {
    let id: UUID
    let universityId: UUID
    let name: String
    let code: String
    let fieldOfStudy: String

    let totalPlaces: Int
    let budgetPlaces: Int
    let paidPlaces: Int

    let tuitionPerYear: Int?
    let durationYears: Int

    let passingScoreLastYear: Int?

    let applicationStartDate: String
    let applicationEndDate: String
    let examPeriod: String

    let portfolioRequired: Bool
    let portfolioDetails: String?

    let entranceExams: [EntranceExam]
    let reviews: [StudentReview]

    let lastYearApplicants: Int?
    let lastYearEnrolled: Int?

    let programDescription: String
}
