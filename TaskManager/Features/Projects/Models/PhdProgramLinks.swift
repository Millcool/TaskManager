import Foundation

struct PhdProgramLinks {
    let programPageURL: String?
    let applicationPortalURL: String?
    let curriculumURL: String?

    init(
        programPageURL: String? = nil,
        applicationPortalURL: String? = nil,
        curriculumURL: String? = nil
    ) {
        self.programPageURL = programPageURL
        self.applicationPortalURL = applicationPortalURL
        self.curriculumURL = curriculumURL
    }

    var isEmpty: Bool {
        programPageURL == nil && applicationPortalURL == nil && curriculumURL == nil
    }
}
