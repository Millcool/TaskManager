import Foundation

// swiftlint:disable type_body_length file_length
enum PhdProgramsDataProvider {

    // MARK: - University IDs — Москва

    private static let msuId = UUID(uuidString: "A0000001-0000-0000-0000-000000000001")!
    private static let hseId = UUID(uuidString: "A0000002-0000-0000-0000-000000000002")!
    private static let miptId = UUID(uuidString: "A0000004-0000-0000-0000-000000000004")!
    private static let baumanId = UUID(uuidString: "A0000006-0000-0000-0000-000000000006")!
    private static let skoltechId = UUID(uuidString: "A000000A-0000-0000-0000-00000000000A")!
    private static let mephiId = UUID(uuidString: "A000000B-0000-0000-0000-00000000000B")!
    private static let mireaId = UUID(uuidString: "A000000C-0000-0000-0000-00000000000C")!
    private static let rudnId = UUID(uuidString: "A000000D-0000-0000-0000-00000000000D")!
    private static let synergyId = UUID(uuidString: "A000000E-0000-0000-0000-00000000000E")!
    private static let ranepaId = UUID(uuidString: "A000000F-0000-0000-0000-00000000000F")!
    private static let maiId = UUID(uuidString: "A0000010-0000-0000-0000-000000000010")!
    private static let misisId = UUID(uuidString: "A0000011-0000-0000-0000-000000000011")!
    private static let finunivId = UUID(uuidString: "A0000012-0000-0000-0000-000000000012")!
    private static let ranId = UUID(uuidString: "A0000013-0000-0000-0000-000000000013")!

    // MARK: - University IDs — Санкт-Петербург

    private static let spbuId = UUID(uuidString: "A0000003-0000-0000-0000-000000000003")!
    private static let itmoId = UUID(uuidString: "A0000005-0000-0000-0000-000000000005")!
    private static let spbpuId = UUID(uuidString: "A0000014-0000-0000-0000-000000000014")!
    private static let letiId = UUID(uuidString: "A0000015-0000-0000-0000-000000000015")!
    private static let guapId = UUID(uuidString: "A0000016-0000-0000-0000-000000000016")!
    private static let spbgutId = UUID(uuidString: "A0000017-0000-0000-0000-000000000017")!
    private static let spbgmtuId = UUID(uuidString: "A0000018-0000-0000-0000-000000000018")!

    // MARK: - University IDs — Московская область

    private static let rgutisId = UUID(uuidString: "A0000019-0000-0000-0000-000000000019")!

    // MARK: - Universities

    static let universities: [University] = [
        // Москва
        University(id: msuId, name: "Московский государственный университет им. М.В. Ломоносова", shortName: "МГУ", city: "Москва", logoSystemImage: "building.columns.fill", websiteURL: "https://cs.msu.ru/education/aspirantura"),
        University(id: hseId, name: "Национальный исследовательский университет «Высшая школа экономики»", shortName: "НИУ ВШЭ", city: "Москва", logoSystemImage: "graduationcap.fill", websiteURL: "https://aspirantura.hse.ru"),
        University(id: miptId, name: "Московский физико-технический институт", shortName: "МФТИ", city: "Москва", logoSystemImage: "atom", websiteURL: "https://pk.mipt.ru/phd/"),
        University(id: mephiId, name: "Национальный исследовательский ядерный университет «МИФИ»", shortName: "НИЯУ МИФИ", city: "Москва", logoSystemImage: "bolt.shield.fill", websiteURL: "https://admission.mephi.ru/postgraduate/education/programs"),
        University(id: baumanId, name: "Московский государственный технический университет им. Н.Э. Баумана", shortName: "МГТУ им. Баумана", city: "Москва", logoSystemImage: "gearshape.2.fill", websiteURL: "https://bmstu.ru"),
        University(id: skoltechId, name: "Сколковский институт науки и технологий", shortName: "Сколтех", city: "Москва", logoSystemImage: "sparkles", websiteURL: "https://www.skoltech.ru/phd"),
        University(id: mireaId, name: "МИРЭА — Российский технологический университет", shortName: "РТУ МИРЭА", city: "Москва", logoSystemImage: "cpu", websiteURL: "https://www.mirea.ru/graduate-students/the-graduate-program/"),
        University(id: rudnId, name: "Российский университет дружбы народов им. Патриса Лумумбы", shortName: "РУДН", city: "Москва", logoSystemImage: "globe.europe.africa", websiteURL: "https://admission.rudn.ru/postgraduate/"),
        University(id: synergyId, name: "Университет «Синергия»", shortName: "Синергия", city: "Москва", logoSystemImage: "s.circle.fill", websiteURL: "https://synergy.ru/abiturientam/postgraduate_study"),
        University(id: ranepaId, name: "Российская академия народного хозяйства и государственной службы", shortName: "РАНХиГС", city: "Москва", logoSystemImage: "building.fill", websiteURL: "https://www.ranepa.ru/podgotovka-nauchnykh-kadrov/aspirantura/"),
        University(id: maiId, name: "Московский авиационный институт", shortName: "МАИ", city: "Москва", logoSystemImage: "airplane", websiteURL: "https://mai.ru/science/qualified/postgraduate/aspirants/"),
        University(id: misisId, name: "Национальный исследовательский технологический университет «МИСИС»", shortName: "МИСИС", city: "Москва", logoSystemImage: "hammer.fill", websiteURL: "https://misis.ru/applicants/admission/postgraduate/"),
        University(id: finunivId, name: "Финансовый университет при Правительстве Российской Федерации", shortName: "Финансовый университет", city: "Москва", logoSystemImage: "chart.line.uptrend.xyaxis", websiteURL: "https://www.fa.ru/"),
        University(id: ranId, name: "ФИЦ ИУ РАН / ИСП РАН", shortName: "ФИЦ ИУ РАН", city: "Москва", logoSystemImage: "brain.head.profile", websiteURL: "https://www.frccsc.ru/postgraduate/admission"),

        // Санкт-Петербург
        University(id: spbuId, name: "Санкт-Петербургский государственный университет", shortName: "СПбГУ", city: "Санкт-Петербург", logoSystemImage: "building.columns.fill", websiteURL: "https://abiturient.spbu.ru/programs/aspirantura/"),
        University(id: itmoId, name: "Национальный исследовательский университет ИТМО", shortName: "ИТМО", city: "Санкт-Петербург", logoSystemImage: "lightbulb.fill", websiteURL: "https://abit.itmo.ru/phd"),
        University(id: spbpuId, name: "Санкт-Петербургский политехнический университет Петра Великого", shortName: "СПбПУ", city: "Санкт-Петербург", logoSystemImage: "wrench.and.screwdriver.fill", websiteURL: "https://www.spbstu.ru/graduate-students/admission-information/"),
        University(id: letiId, name: "Санкт-Петербургский государственный электротехнический университет «ЛЭТИ»", shortName: "ЛЭТИ", city: "Санкт-Петербург", logoSystemImage: "bolt.fill", websiteURL: "https://abit.etu.ru/ru/postupayushhim/aspirantura/"),
        University(id: guapId, name: "Санкт-Петербургский государственный университет аэрокосмического приборостроения", shortName: "ГУАП", city: "Санкт-Петербург", logoSystemImage: "airplane.circle", websiteURL: "https://priem.guap.ru/asp"),
        University(id: spbgutId, name: "Санкт-Петербургский государственный университет телекоммуникаций им. проф. М.А. Бонч-Бруевича", shortName: "СПбГУТ", city: "Санкт-Петербург", logoSystemImage: "antenna.radiowaves.left.and.right", websiteURL: "https://priem.sut.ru/asp"),
        University(id: spbgmtuId, name: "Санкт-Петербургский государственный морской технический университет", shortName: "СПбГМТУ", city: "Санкт-Петербург", logoSystemImage: "ferry.fill", websiteURL: "https://www.smtu.ru"),

        // Московская область
        University(id: rgutisId, name: "Российский государственный университет туризма и сервиса", shortName: "РГУТиС", city: "Московская область", logoSystemImage: "suitcase.fill", websiteURL: "https://rguts.ru"),
    ]

    // MARK: - Programs

    static let programs: [PhdProgram] = [

        // =====================================================================
        // МОСКВА
        // =====================================================================

        // MARK: — МГУ

        PhdProgram(
            id: UUID(uuidString: "B0000001-0000-0000-0000-000000000001")!,
            universityId: msuId,
            name: "Информатика и вычислительная техника",
            code: "09.06.01",
            fieldOfStudy: "Математическое и программное обеспечение ВМ",
            totalPlaces: 25, budgetPlaces: 18, paidPlaces: 7,
            tuitionPerYear: 490_000, durationYears: 4,
            passingScoreLastYear: 240,
            applicationStartDate: "1 июня", applicationEndDate: "15 августа",
            examPeriod: "1–15 сентября",
            portfolioRequired: true, portfolioDetails: "Список публикаций, участие в конференциях, рекомендательные письма",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика и программирование", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
                EntranceExam(id: UUID(), name: "Философия", type: .written, details: "История и философия науки", maxScore: 100),
            ],
            reviews: [
                StudentReview(id: UUID(), authorName: "Алексей М.", year: 2024, rating: 4,
                    text: "Сильная научная школа, много возможностей для исследований.",
                    pros: ["Престиж диплома", "Сильные научные руководители", "Доступ к лабораториям"],
                    cons: ["Большая бюрократия", "Стипендия невысокая"]),
            ],
            lastYearApplicants: 85, lastYearEnrolled: 23,
            programDescription: "Программа на факультете ВМК МГУ. Специализация на программном обеспечении и информатике."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000001-0001-0000-0000-000000000001")!,
            universityId: msuId,
            name: "Искусственный интеллект и машинное обучение",
            code: "1.2.1",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 15, budgetPlaces: 12, paidPlaces: 3,
            tuitionPerYear: 490_000, durationYears: 4,
            passingScoreLastYear: 250,
            applicationStartDate: "1 июня", applicationEndDate: "15 августа",
            examPeriod: "1–15 сентября",
            portfolioRequired: true, portfolioDetails: "Публикации, рекомендации научного руководителя",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "ИИ и машинное обучение", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: 60, lastYearEnrolled: 13,
            programDescription: "Программа ВМК МГУ по искусственному интеллекту и машинному обучению."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000001-0002-0000-0000-000000000001")!,
            universityId: msuId,
            name: "Математическое моделирование",
            code: "01.06.01",
            fieldOfStudy: "Математика и механика",
            totalPlaces: 20, budgetPlaces: 16, paidPlaces: 4,
            tuitionPerYear: 490_000, durationYears: 4,
            passingScoreLastYear: 230,
            applicationStartDate: "1 июня", applicationEndDate: "15 августа",
            examPeriod: "1–15 сентября",
            portfolioRequired: true, portfolioDetails: "Публикации, научные работы",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Математика", type: .written, details: "Высшая математика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: 50, lastYearEnrolled: 18,
            programDescription: "Программа мехмата МГУ: математическое моделирование, численные методы."
        ),

        // MARK: — НИУ ВШЭ

        PhdProgram(
            id: UUID(uuidString: "B0000002-0000-0000-0000-000000000002")!,
            universityId: hseId,
            name: "Информатика и вычислительная техника",
            code: "09.06.01",
            fieldOfStudy: "Информатика и вычислительная техника",
            totalPlaces: 20, budgetPlaces: 15, paidPlaces: 5,
            tuitionPerYear: 632_000, durationYears: 4,
            passingScoreLastYear: 260,
            applicationStartDate: "20 июня", applicationEndDate: "17 августа",
            examPeriod: "1–18 сентября",
            portfolioRequired: true, portfolioDetails: "Резюме, мотивационное письмо, публикации, исследовательский проект",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Портфолио", type: .portfolio, details: "Оценка исследовательского потенциала", maxScore: 100),
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .oral, details: "Компьютерные науки", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский (TOEFL/IELTS или внутренний)", maxScore: 100),
            ],
            reviews: [
                StudentReview(id: UUID(), authorName: "Мария К.", year: 2024, rating: 5,
                    text: "Отличная аспирантура с международным уровнем. Много конференций и стажировок.",
                    pros: ["Международные связи", "Грантовая поддержка", "Современные лаборатории"],
                    cons: ["Высокие требования к публикациям", "Интенсивная нагрузка"]),
            ],
            lastYearApplicants: 120, lastYearEnrolled: 18,
            programDescription: "Аспирантура ВШЭ с акцентом на машинное обучение, алгоритмы и ИИ."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000002-0001-0000-0000-000000000002")!,
            universityId: hseId,
            name: "Компьютерные и информационные технологии",
            code: "02.06.01",
            fieldOfStudy: "Компьютерные и информационные науки",
            totalPlaces: 12, budgetPlaces: 8, paidPlaces: 4,
            tuitionPerYear: 632_000, durationYears: 4,
            passingScoreLastYear: 245,
            applicationStartDate: "20 июня", applicationEndDate: "17 августа",
            examPeriod: "1–18 сентября",
            portfolioRequired: true, portfolioDetails: "Резюме, мотивационное письмо, исследовательский проект",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Портфолио", type: .portfolio, details: "Исследовательский потенциал", maxScore: 100),
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .oral, details: "Информационные технологии", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: 55, lastYearEnrolled: 10,
            programDescription: "Программа ВШЭ по компьютерным и информационным технологиям."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000002-0002-0000-0000-000000000002")!,
            universityId: hseId,
            name: "Системный анализ, управление и обработка информации",
            code: "2.3.1",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 18, budgetPlaces: 13, paidPlaces: 5,
            tuitionPerYear: 654_000, durationYears: 3,
            passingScoreLastYear: 250,
            applicationStartDate: "20 июня", applicationEndDate: "17 августа",
            examPeriod: "1–18 сентября",
            portfolioRequired: true, portfolioDetails: "Портфолио научных достижений",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Портфолио", type: .portfolio, details: "Оценка исследовательского потенциала", maxScore: 100),
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .oral, details: "Системный анализ", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: 60, lastYearEnrolled: 14,
            programDescription: "Аспирантура ВШЭ по системному анализу. 13 бюджетных мест."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000002-0003-0000-0000-000000000002")!,
            universityId: hseId,
            name: "Математическое и программное обеспечение ВС",
            code: "2.3.5",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 10, budgetPlaces: 7, paidPlaces: 3,
            tuitionPerYear: 654_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "17 августа",
            examPeriod: "1–18 сентября",
            portfolioRequired: true, portfolioDetails: "Портфолио",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Портфолио", type: .portfolio, details: "Исследовательский потенциал", maxScore: 100),
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .oral, details: "Программное обеспечение", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Программа ВШЭ по математическому и программному обеспечению вычислительных систем."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000002-0004-0000-0000-000000000002")!,
            universityId: hseId,
            name: "Теоретическая информатика и кибернетика",
            code: "1.2.3",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 8, budgetPlaces: 6, paidPlaces: 2,
            tuitionPerYear: 632_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "17 августа",
            examPeriod: "1–18 сентября",
            portfolioRequired: true, portfolioDetails: "Портфолио",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Портфолио", type: .portfolio, details: "Исследовательский потенциал", maxScore: 100),
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .oral, details: "Теоретическая информатика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Программа ВШЭ/МИЭМ по теоретической информатике и кибернетике."
        ),

        // MARK: — МФТИ

        PhdProgram(
            id: UUID(uuidString: "B0000005-0000-0000-0000-000000000005")!,
            universityId: miptId,
            name: "Искусственный интеллект и машинное обучение",
            code: "1.2.1",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 6, budgetPlaces: 5, paidPlaces: 1,
            tuitionPerYear: 921_000, durationYears: 4,
            passingScoreLastYear: 255,
            applicationStartDate: "1 июня", applicationEndDate: "10 августа",
            examPeriod: "20 августа – 5 сентября",
            portfolioRequired: true, portfolioDetails: "Научные публикации, патенты, рекомендации",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "ИИ, алгоритмы и ML", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
                EntranceExam(id: UUID(), name: "Философия", type: .oral, details: "История и философия науки", maxScore: 100),
            ],
            reviews: [
                StudentReview(id: UUID(), authorName: "Игорь Л.", year: 2024, rating: 5,
                    text: "МФТИ — это бренд. Связи с индустрией через базовые кафедры в Яндексе и ABBYY.",
                    pros: ["Связь с индустрией", "Базовые кафедры в IT-компаниях", "Стипендия до 80 000 ₽/мес"],
                    cons: ["Много формальностей", "Далеко от центра Москвы"]),
            ],
            lastYearApplicants: 40, lastYearEnrolled: 5,
            programDescription: "Аспирантура МФТИ по ИИ и ML. Базовые кафедры в ведущих IT-компаниях."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000005-0001-0000-0000-000000000005")!,
            universityId: miptId,
            name: "Информатика и вычислительная техника",
            code: "09.06.01",
            fieldOfStudy: "Информатика и вычислительная техника",
            totalPlaces: 11, budgetPlaces: 9, paidPlaces: 2,
            tuitionPerYear: 934_000, durationYears: 3,
            passingScoreLastYear: 240,
            applicationStartDate: "1 июня", applicationEndDate: "10 августа",
            examPeriod: "20 августа – 5 сентября",
            portfolioRequired: true, portfolioDetails: "Публикации, рекомендации",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
                EntranceExam(id: UUID(), name: "Философия", type: .oral, details: "История и философия науки", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: 50, lastYearEnrolled: 10,
            programDescription: "Аспирантура МФТИ по информатике. 317 бюджетных мест по всем направлениям."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000005-0002-0000-0000-000000000005")!,
            universityId: miptId,
            name: "Системный анализ, управление и обработка информации",
            code: "2.3.1",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 8, budgetPlaces: 6, paidPlaces: 2,
            tuitionPerYear: 921_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "1 июня", applicationEndDate: "10 августа",
            examPeriod: "20 августа – 5 сентября",
            portfolioRequired: true, portfolioDetails: "Публикации, рекомендации",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Системный анализ", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура МФТИ по системному анализу и обработке информации."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000005-0003-0000-0000-000000000005")!,
            universityId: miptId,
            name: "Математическое моделирование, численные методы",
            code: "1.2.2",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 10, budgetPlaces: 8, paidPlaces: 2,
            tuitionPerYear: 921_000, durationYears: 4,
            passingScoreLastYear: 245,
            applicationStartDate: "1 июня", applicationEndDate: "10 августа",
            examPeriod: "20 августа – 5 сентября",
            portfolioRequired: true, portfolioDetails: "Научные публикации",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Математика", type: .written, details: "Высшая математика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: 35, lastYearEnrolled: 9,
            programDescription: "Аспирантура МФТИ по математическому моделированию."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000005-0004-0000-0000-000000000005")!,
            universityId: miptId,
            name: "Математическое и программное обеспечение ВС",
            code: "2.3.5",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 8, budgetPlaces: 6, paidPlaces: 2,
            tuitionPerYear: 934_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "1 июня", applicationEndDate: "10 августа",
            examPeriod: "20 августа – 5 сентября",
            portfolioRequired: true, portfolioDetails: "Публикации, рекомендации",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Программное обеспечение ВС", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура МФТИ по математическому и программному обеспечению."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000005-0005-0000-0000-000000000005")!,
            universityId: miptId,
            name: "Когнитивное моделирование",
            code: "5.12.4",
            fieldOfStudy: "Когнитивные науки",
            totalPlaces: 5, budgetPlaces: 4, paidPlaces: 1,
            tuitionPerYear: 921_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "1 июня", applicationEndDate: "10 августа",
            examPeriod: "20 августа – 5 сентября",
            portfolioRequired: true, portfolioDetails: "Публикации, рекомендации",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .oral, details: "Когнитивное моделирование", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура МФТИ по когнитивному моделированию (ФПМИ)."
        ),

        // MARK: — НИЯУ МИФИ

        PhdProgram(
            id: UUID(uuidString: "B000000B-0000-0000-0000-00000000000B")!,
            universityId: mephiId,
            name: "Информатика и вычислительная техника",
            code: "09.06.01",
            fieldOfStudy: "Информатика и вычислительная техника",
            totalPlaces: 20, budgetPlaces: 15, paidPlaces: 5,
            tuitionPerYear: 430_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "1 июня", applicationEndDate: "31 июля",
            examPeriod: "август",
            portfolioRequired: true, portfolioDetails: "Портфолио научных достижений",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура МИФИ по информатике. Минимальный проходной балл — 30 из 100."
        ),

        PhdProgram(
            id: UUID(uuidString: "B000000B-0001-0000-0000-00000000000B")!,
            universityId: mephiId,
            name: "Искусственный интеллект и машинное обучение",
            code: "1.2.1",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 10, budgetPlaces: 8, paidPlaces: 2,
            tuitionPerYear: 430_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "1 июня", applicationEndDate: "31 июля",
            examPeriod: "август",
            portfolioRequired: true, portfolioDetails: "Портфолио",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "ИИ и ML", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура МИФИ по искусственному интеллекту и машинному обучению."
        ),

        PhdProgram(
            id: UUID(uuidString: "B000000B-0002-0000-0000-00000000000B")!,
            universityId: mephiId,
            name: "Кибербезопасность и криптография",
            code: "2.3.4",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 12, budgetPlaces: 10, paidPlaces: 2,
            tuitionPerYear: 430_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "1 июня", applicationEndDate: "31 июля",
            examPeriod: "август",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информационная безопасность", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура МИФИ по кибербезопасности. Институт финансовых технологий."
        ),

        PhdProgram(
            id: UUID(uuidString: "B000000B-0003-0000-0000-00000000000B")!,
            universityId: mephiId,
            name: "Информатика и информационные процессы",
            code: "2.3.8",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 10, budgetPlaces: 8, paidPlaces: 2,
            tuitionPerYear: 430_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "1 июня", applicationEndDate: "31 июля",
            examPeriod: "август",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура МИФИ по информатике и информационным процессам."
        ),

        // MARK: — МГТУ им. Баумана

        PhdProgram(
            id: UUID(uuidString: "B0000007-0000-0000-0000-000000000007")!,
            universityId: baumanId,
            name: "Информатика и вычислительная техника",
            code: "09.06.01",
            fieldOfStudy: "Системы автоматизации проектирования",
            totalPlaces: 20, budgetPlaces: 16, paidPlaces: 4,
            tuitionPerYear: 415_000, durationYears: 4,
            passingScoreLastYear: 210,
            applicationStartDate: "1 июня", applicationEndDate: "31 августа",
            examPeriod: "5–20 сентября",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика и ВТ", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
                EntranceExam(id: UUID(), name: "Философия", type: .oral, details: "История и философия науки", maxScore: 100),
            ],
            reviews: [
                StudentReview(id: UUID(), authorName: "Сергей Д.", year: 2023, rating: 3,
                    text: "Бауманка даёт хорошую инженерную подготовку, но научная часть слабее.",
                    pros: ["Инженерная школа", "Связи с ОПК", "Много лабораторий"],
                    cons: ["Устаревшие подходы", "Мало международных публикаций"]),
            ],
            lastYearApplicants: 50, lastYearEnrolled: 18,
            programDescription: "Аспирантура МГТУ им. Баумана. Инженерный уклон, САПР и системное программирование."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000007-0001-0000-0000-000000000007")!,
            universityId: baumanId,
            name: "Системный анализ, управление и обработка информации",
            code: "2.3.1",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 10, budgetPlaces: 8, paidPlaces: 2,
            tuitionPerYear: 415_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "1 июня", applicationEndDate: "31 августа",
            examPeriod: "5–20 сентября",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Системный анализ", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура Баумана по системному анализу и управлению."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000007-0002-0000-0000-000000000007")!,
            universityId: baumanId,
            name: "Управление в организационных системах",
            code: "2.3.4",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 8, budgetPlaces: 6, paidPlaces: 2,
            tuitionPerYear: 415_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "1 июня", applicationEndDate: "31 августа",
            examPeriod: "5–20 сентября",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Управление в организационных системах", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура Баумана по управлению в организационных системах."
        ),

        // MARK: — Сколтех

        PhdProgram(
            id: UUID(uuidString: "B000000B-5C00-0000-0000-00000000000B")!,
            universityId: skoltechId,
            name: "Computational and Data Science and Engineering",
            code: "09.06.01",
            fieldOfStudy: "Computer Science и Data Science",
            totalPlaces: 25, budgetPlaces: 25, paidPlaces: 0,
            tuitionPerYear: nil, durationYears: 4,
            passingScoreLastYear: 270,
            applicationStartDate: "1 декабря", applicationEndDate: "27 апреля",
            examPeriod: "апрель – май (интервью)",
            portfolioRequired: true, portfolioDetails: "CV, мотивационное письмо, 2 рекомендательных письма",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Интервью", type: .interview, details: "Собеседование с потенциальным научным руководителем", maxScore: 100),
                EntranceExam(id: UUID(), name: "Английский язык", type: .test, details: "TOEFL iBT ≥ 79 или IELTS ≥ 6.5", maxScore: nil),
                EntranceExam(id: UUID(), name: "Портфолио", type: .portfolio, details: "Академический профиль и исследовательский потенциал", maxScore: 100),
            ],
            reviews: [
                StudentReview(id: UUID(), authorName: "Николай Ш.", year: 2024, rating: 5,
                    text: "Лучшее финансирование среди российских аспирантур. Полностью на английском.",
                    pros: ["Стипендия 75 000 ₽/мес", "Английский язык обучения", "Все бюджетные места"],
                    cons: ["Далеко от центра Москвы", "Маленький вуз"]),
            ],
            lastYearApplicants: 200, lastYearEnrolled: 22,
            programDescription: "Международная программа Сколтеха на английском. Все места бюджетные, высокая стипендия."
        ),

        // MARK: — РТУ МИРЭА

        PhdProgram(
            id: UUID(uuidString: "B000000C-0000-0000-0000-00000000000C")!,
            universityId: mireaId,
            name: "Компьютерные науки и информатика",
            code: "1.2",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 15, budgetPlaces: 10, paidPlaces: 5,
            tuitionPerYear: 350_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура РТУ МИРЭА по компьютерным наукам. Очная форма обучения."
        ),

        PhdProgram(
            id: UUID(uuidString: "B000000C-0001-0000-0000-00000000000C")!,
            universityId: mireaId,
            name: "Информатика и информационные процессы",
            code: "2.3.8",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 10, budgetPlaces: 7, paidPlaces: 3,
            tuitionPerYear: 350_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика и ИТ", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура МИРЭА по информатике и информационным процессам."
        ),

        // MARK: — РУДН

        PhdProgram(
            id: UUID(uuidString: "B000000D-0000-0000-0000-00000000000D")!,
            universityId: rudnId,
            name: "Информатика и вычислительная техника",
            code: "09.06.01",
            fieldOfStudy: "Информатика и вычислительная техника",
            totalPlaces: 12, budgetPlaces: 8, paidPlaces: 4,
            tuitionPerYear: 370_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "1 июня", applicationEndDate: "22 июля",
            examPeriod: "август",
            portfolioRequired: true, portfolioDetails: "Портфолио научных достижений",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Портфолио", type: .portfolio, details: "Обзор научных достижений", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура РУДН по информатике. Мин. проходной — 30 из 100."
        ),

        PhdProgram(
            id: UUID(uuidString: "B000000D-0001-0000-0000-00000000000D")!,
            universityId: rudnId,
            name: "Теоретическая информатика и кибернетика",
            code: "1.2.3",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 8, budgetPlaces: 5, paidPlaces: 3,
            tuitionPerYear: 370_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "1 июня", applicationEndDate: "22 июля",
            examPeriod: "август",
            portfolioRequired: true, portfolioDetails: "Портфолио",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Теоретическая информатика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Портфолио", type: .portfolio, details: "Научные достижения", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура РУДН по теоретической информатике и кибернетике."
        ),

        // MARK: — Синергия

        PhdProgram(
            id: UUID(uuidString: "B000000E-0000-0000-0000-00000000000E")!,
            universityId: synergyId,
            name: "Информационные технологии",
            code: "09.06.01",
            fieldOfStudy: "Информатика и вычислительная техника",
            totalPlaces: 30, budgetPlaces: 5, paidPlaces: 25,
            tuitionPerYear: 280_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "1 февраля", applicationEndDate: "26 августа",
            examPeriod: "по мере подачи",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Собеседование", type: .interview, details: "Интервью + оценка достижений", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура Синергии. 21 направление, включая IT. Очная, заочная и дистанционная формы."
        ),

        // MARK: — РАНХиГС

        PhdProgram(
            id: UUID(uuidString: "B000000F-0000-0000-0000-00000000000F")!,
            universityId: ranepaId,
            name: "Информационные технологии и телекоммуникации",
            code: "09.06.01",
            fieldOfStudy: "Информационные технологии",
            totalPlaces: 10, budgetPlaces: 5, paidPlaces: 5,
            tuitionPerYear: 400_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "21 сентября",
            examPeriod: "сентябрь–октябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "IT (приоритетный)", maxScore: 10),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 10),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура РАНХиГС по информационным технологиям. Шкала оценок — 10 баллов."
        ),

        // MARK: — МАИ

        PhdProgram(
            id: UUID(uuidString: "B0000010-0000-0000-0000-000000000010")!,
            universityId: maiId,
            name: "Информатика, кибернетика и энергетика",
            code: "09.06.01",
            fieldOfStudy: "Информатика и кибернетика",
            totalPlaces: 15, budgetPlaces: 10, paidPlaces: 5,
            tuitionPerYear: 380_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: true, portfolioDetails: "Предварительная защита проекта",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика и кибернетика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Предзащита проекта", type: .oral, details: "Защита исследовательского проекта", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура МАИ — информатика и кибернетика. Отдельные конкурсы по организациям."
        ),

        // MARK: — МИСИС

        PhdProgram(
            id: UUID(uuidString: "B0000011-0000-0000-0000-000000000011")!,
            universityId: misisId,
            name: "Информационные технологии и телекоммуникации",
            code: "2.3",
            fieldOfStudy: "Информационные технологии",
            totalPlaces: 12, budgetPlaces: 8, paidPlaces: 4,
            tuitionPerYear: 380_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информационные технологии", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура МИСИС по IT. Очная форма, обязательная лабораторная и педагогическая практика."
        ),

        // MARK: — Финансовый университет

        PhdProgram(
            id: UUID(uuidString: "B0000012-0000-0000-0000-000000000012")!,
            universityId: finunivId,
            name: "Искусственный интеллект и машинное обучение",
            code: "1.2.1",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 10, budgetPlaces: 5, paidPlaces: 5,
            tuitionPerYear: 330_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "ИИ, NLP, анализ данных", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура Финуниверситета по ИИ и ML. Факультет ИТ и анализа больших данных."
        ),

        // MARK: — ФИЦ ИУ РАН / ИСП РАН

        PhdProgram(
            id: UUID(uuidString: "B0000013-0000-0000-0000-000000000013")!,
            universityId: ranId,
            name: "Системный анализ, управление и обработка информации",
            code: "2.3.1",
            fieldOfStudy: "Информационные технологии",
            totalPlaces: 2, budgetPlaces: 2, paidPlaces: 0,
            tuitionPerYear: nil, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "31 июля",
            examPeriod: "сентябрь",
            portfolioRequired: true, portfolioDetails: "Публикации, рекомендации",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Системный анализ", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура ФИЦ ИУ РАН (Институт системного анализа). 2 бюджетных места."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000013-0001-0000-0000-000000000013")!,
            universityId: ranId,
            name: "Математическое и программное обеспечение ВС",
            code: "05.13.11",
            fieldOfStudy: "Математическое и программное обеспечение",
            totalPlaces: 3, budgetPlaces: 3, paidPlaces: 0,
            tuitionPerYear: nil, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "31 июля",
            examPeriod: "сентябрь",
            portfolioRequired: true, portfolioDetails: "Публикации, рекомендации",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Системное программирование", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура ИСП РАН по системному программированию и теоретической информатике."
        ),

        // =====================================================================
        // САНКТ-ПЕТЕРБУРГ
        // =====================================================================

        // MARK: — СПбГУ

        PhdProgram(
            id: UUID(uuidString: "B0000004-0000-0000-0000-000000000004")!,
            universityId: spbuId,
            name: "Информатика и информационные процессы",
            code: "2.3.8",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 18, budgetPlaces: 14, paidPlaces: 4,
            tuitionPerYear: 156_900, durationYears: 3,
            passingScoreLastYear: 220,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Информатика", type: .written, details: "Информатика и информационные процессы", maxScore: 50),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский/немецкий/французский", maxScore: 30),
            ],
            reviews: [
                StudentReview(id: UUID(), authorName: "Ольга С.", year: 2024, rating: 4,
                    text: "Хорошая программа, Петербург создаёт правильную атмосферу для науки.",
                    pros: ["Классическое образование", "Связи с РАН", "Низкая стоимость обучения"],
                    cons: ["Консервативный подход", "Долгая процедура защиты"]),
            ],
            lastYearApplicants: 55, lastYearEnrolled: 16,
            programDescription: "Аспирантура СПбГУ по информатике. Электронная подача через Госуслуги."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000004-0001-0000-0000-000000000004")!,
            universityId: spbuId,
            name: "Искусственный интеллект и машинное обучение",
            code: "1.2.1",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 12, budgetPlaces: 8, paidPlaces: 4,
            tuitionPerYear: 156_900, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Информатика", type: .written, details: "Компьютерные науки и ИИ", maxScore: 50),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 30),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура СПбГУ по ИИ и ML. Степень — кандидат физ.-мат. наук."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000004-0002-0000-0000-000000000004")!,
            universityId: spbuId,
            name: "Прикладная математика",
            code: "01.06.01",
            fieldOfStudy: "Математика и механика",
            totalPlaces: 15, budgetPlaces: 12, paidPlaces: 3,
            tuitionPerYear: 156_900, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Математика", type: .written, details: "Прикладная математика", maxScore: 50),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 30),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура матмеха СПбГУ по прикладной математике. Программа Contemporary Mathematics на английском."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000004-0003-0000-0000-000000000004")!,
            universityId: spbuId,
            name: "Теоретическая информатика и кибернетика",
            code: "2.3.8",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 10, budgetPlaces: 7, paidPlaces: 3,
            tuitionPerYear: 156_900, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Теоретическая информатика", type: .written, details: "Теория информатики и кибернетика", maxScore: 50),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 30),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура СПбГУ по теоретической информатике и кибернетике."
        ),

        // MARK: — ИТМО

        PhdProgram(
            id: UUID(uuidString: "B0000006-0000-0000-0000-000000000006")!,
            universityId: itmoId,
            name: "Информатика и информационные процессы",
            code: "2.3.8",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 30, budgetPlaces: 25, paidPlaces: 5,
            tuitionPerYear: 420_000, durationYears: 3,
            passingScoreLastYear: 235,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь (дистанционно)",
            portfolioRequired: true, portfolioDetails: "Портфолио, участие в олимпиадах/хакатонах",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .oral, details: "Информатика и программирование (5-балльная шкала)", maxScore: 5),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык (3-балльная шкала)", maxScore: 3),
            ],
            reviews: [
                StudentReview(id: UUID(), authorName: "Андрей П.", year: 2024, rating: 5,
                    text: "ИТМО — лучший вуз для CS-аспирантуры в Питере. Победители ICPC создают уникальную среду.",
                    pros: ["Сильное CS-сообщество", "Молодые профессора", "273 бюджетных места всего"],
                    cons: ["Стипендия минимальная"]),
            ],
            lastYearApplicants: 70, lastYearEnrolled: 20,
            programDescription: "Аспирантура ИТМО — многократного чемпиона мира по программированию. 273 бюджетных места."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000006-0001-0000-0000-000000000006")!,
            universityId: itmoId,
            name: "Искусственный интеллект и машинное обучение",
            code: "1.2.1",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 15, budgetPlaces: 12, paidPlaces: 3,
            tuitionPerYear: 420_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь (дистанционно)",
            portfolioRequired: true, portfolioDetails: "Портфолио",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .oral, details: "ИИ и ML (5-балльная шкала)", maxScore: 5),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .test, details: "Английский язык (3-балльная шкала)", maxScore: 3),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура ИТМО по искусственному интеллекту и машинному обучению."
        ),

        // MARK: — СПбПУ (Политех)

        PhdProgram(
            id: UUID(uuidString: "B0000014-0000-0000-0000-000000000014")!,
            universityId: spbpuId,
            name: "Информатика и вычислительная техника",
            code: "09.06.01",
            fieldOfStudy: "Математическое и программное обеспечение ВМ",
            totalPlaces: 15, budgetPlaces: 10, paidPlaces: 5,
            tuitionPerYear: 350_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: true, portfolioDetails: "Собеседование с научным руководителем (обязательно)",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика и ВТ", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура СПбПУ, Высшая школа программной инженерии. Общежитие для иногородних."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000014-0001-0000-0000-000000000014")!,
            universityId: spbpuId,
            name: "Искусственный интеллект и машинное обучение",
            code: "1.2.1",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 10, budgetPlaces: 7, paidPlaces: 3,
            tuitionPerYear: 350_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: true, portfolioDetails: "Собеседование с научным руководителем",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "ИИ и ML", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура Политеха по ИИ и ML. Институт компьютерных наук и кибербезопасности."
        ),

        // MARK: — ЛЭТИ

        PhdProgram(
            id: UUID(uuidString: "B0000015-0000-0000-0000-000000000015")!,
            universityId: letiId,
            name: "Информатика и вычислительная техника",
            code: "09.06.01",
            fieldOfStudy: "Информатика и вычислительная техника",
            totalPlaces: 20, budgetPlaces: 15, paidPlaces: 5,
            tuitionPerYear: 300_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
                EntranceExam(id: UUID(), name: "Философия", type: .oral, details: "История и философия науки", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура ЛЭТИ по информатике. Всего 119 мест по всем направлениям."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000015-0001-0000-0000-000000000015")!,
            universityId: letiId,
            name: "Вычислительные системы и их элементы",
            code: "2.3.2",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 10, budgetPlaces: 7, paidPlaces: 3,
            tuitionPerYear: 300_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Вычислительные системы", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура ЛЭТИ: защита ВС, распределённые информационные системы."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000015-0002-0000-0000-000000000015")!,
            universityId: letiId,
            name: "Искусственный интеллект и машинное обучение",
            code: "1.2.1",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 8, budgetPlaces: 5, paidPlaces: 3,
            tuitionPerYear: 300_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "ИИ и ML", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура ЛЭТИ по искусственному интеллекту и машинному обучению."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000015-0003-0000-0000-000000000015")!,
            universityId: letiId,
            name: "Кибербезопасность",
            code: "1.2.4",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 8, budgetPlaces: 5, paidPlaces: 3,
            tuitionPerYear: 300_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информационная безопасность", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура ЛЭТИ по кибербезопасности."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000015-0004-0000-0000-000000000015")!,
            universityId: letiId,
            name: "Методы и системы защиты информации",
            code: "2.3.6",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 6, budgetPlaces: 4, paidPlaces: 2,
            tuitionPerYear: 300_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Защита информации", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура ЛЭТИ по защите информации и информационной безопасности."
        ),

        // MARK: — ГУАП

        PhdProgram(
            id: UUID(uuidString: "B0000016-0000-0000-0000-000000000016")!,
            universityId: guapId,
            name: "Управление в технических системах",
            code: "27.06.01",
            fieldOfStudy: "Системный анализ и управление",
            totalPlaces: 10, budgetPlaces: 7, paidPlaces: 3,
            tuitionPerYear: 300_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Системный анализ и управление", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура ГУАП по управлению в технических системах и системному анализу."
        ),

        // MARK: — СПбГУТ

        PhdProgram(
            id: UUID(uuidString: "B0000017-0000-0000-0000-000000000017")!,
            universityId: spbgutId,
            name: "Анализ данных и прикладной ИИ",
            code: "09.06.01",
            fieldOfStudy: "Информатика и вычислительная техника",
            totalPlaces: 10, budgetPlaces: 6, paidPlaces: 4,
            tuitionPerYear: 280_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика и ИИ", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура СПбГУТ: анализ данных и прикладной ИИ. 10 исследовательских профилей."
        ),

        // MARK: — СПбГМТУ

        PhdProgram(
            id: UUID(uuidString: "B0000018-0000-0000-0000-000000000018")!,
            universityId: spbgmtuId,
            name: "Информатика и информационные процессы",
            code: "2.3.8",
            fieldOfStudy: "Информационные технологии и телекоммуникации",
            totalPlaces: 8, budgetPlaces: 5, paidPlaces: 3,
            tuitionPerYear: 250_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Информатика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура СПбГМТУ по информатике и информационным процессам."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000018-0001-0000-0000-000000000018")!,
            universityId: spbgmtuId,
            name: "Искусственный интеллект и машинное обучение",
            code: "1.2.1",
            fieldOfStudy: "Компьютерные науки и информатика",
            totalPlaces: 6, budgetPlaces: 4, paidPlaces: 2,
            tuitionPerYear: 250_000, durationYears: 4,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "20 августа",
            examPeriod: "сентябрь",
            portfolioRequired: false, portfolioDetails: nil,
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "ИИ и ML", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Аспирантура СПбГМТУ по искусственному интеллекту."
        ),

        // MARK: — РГУТиС

        PhdProgram(
            id: UUID(uuidString: "B0000019-0000-0000-0000-000000000019")!,
            universityId: rgutisId,
            name: "Региональная и отраслевая экономика",
            code: "5.2.3",
            fieldOfStudy: "Экономика (ВШБ, менеджмента и права)",
            totalPlaces: 25, budgetPlaces: 0, paidPlaces: 25,
            tuitionPerYear: 285_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "10 сентября",
            examPeriod: "сентябрь",
            portfolioRequired: true, portfolioDetails: "Реферат по научной специальности, список научных публикаций, рекомендация научного руководителя",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Региональная и отраслевая экономика", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Программа ВШ бизнеса, менеджмента и права РГУТиС по специальности 5.2.3 (ранее 38.06.01). Поступление только на платные места. Данные за 2026 год — уточняйте на rguts.ru, результаты 2025 года и статистика по конкурсу публикуются в разделе приёмной комиссии."
        ),

        PhdProgram(
            id: UUID(uuidString: "B0000019-0001-0000-0000-000000000019")!,
            universityId: rgutisId,
            name: "Менеджмент",
            code: "5.2.6",
            fieldOfStudy: "Экономика (ВШБ, менеджмента и права)",
            totalPlaces: 15, budgetPlaces: 0, paidPlaces: 15,
            tuitionPerYear: 285_000, durationYears: 3,
            passingScoreLastYear: nil,
            applicationStartDate: "20 июня", applicationEndDate: "10 сентября",
            examPeriod: "сентябрь",
            portfolioRequired: true, portfolioDetails: "Реферат, публикации, рекомендация",
            entranceExams: [
                EntranceExam(id: UUID(), name: "Специальная дисциплина", type: .written, details: "Менеджмент", maxScore: 100),
                EntranceExam(id: UUID(), name: "Иностранный язык", type: .written, details: "Английский язык", maxScore: 100),
            ],
            reviews: [],
            lastYearApplicants: nil, lastYearEnrolled: nil,
            programDescription: "Программа ВШ бизнеса РГУТиС по научной специальности 5.2.6 Менеджмент. Ориентация на менеджмент в сфере туризма, гостеприимства и сервиса. Данные по местам и стоимости за 2026 год — справочные, уточняйте на rguts.ru."
        ),
    ]

    // MARK: - Helpers

    static func programs(for university: University) -> [PhdProgram] {
        programs.filter { $0.universityId == university.id }
    }

    static func university(for program: PhdProgram) -> University? {
        universities.first { $0.id == program.universityId }
    }
}
// swiftlint:enable type_body_length file_length
