import SwiftUI

struct ProgramDetailView: View {
    let program: PhdProgram
    let university: University?

    @State private var store = PhdApplicationStore.shared
    @State private var now: Date = Date()
    @State private var activeLink: SafariLink?
    private let tick = Timer.publish(every: 3600, on: .main, in: .common).autoconnect()

    private var status: PhdApplicationStatus { store.status(for: program.id) }
    private var urgency: PhdApplicationUrgency { PhdApplicationIndicator.urgency(for: program, now: now) }

    private var programPageURL: URL? {
        PhdProgramsDataProvider.resolvedProgramPageURL(for: program).flatMap(URL.init)
    }
    private var applicationPortalURL: URL? {
        PhdProgramsDataProvider.resolvedApplicationPortalURL(for: program).flatMap(URL.init)
    }
    private var curriculumURL: URL? {
        PhdProgramsDataProvider.curriculumURL(for: program).flatMap(URL.init)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                applicationStatusCard

                // University info
                if let uni = university {
                    HStack(spacing: 12) {
                        Image(systemName: uni.logoSystemImage)
                            .font(.title2)
                            .foregroundStyle(AppColors.accent)
                            .frame(width: 44, height: 44)
                            .background(AppColors.accent.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        VStack(alignment: .leading, spacing: 2) {
                            Text(uni.shortName)
                                .font(.headline)
                                .foregroundStyle(AppColors.textPrimary)
                            Text(uni.city)
                                .font(.subheadline)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }
                    .cardStyle()
                }

                // Useful links
                linksCard

                // General info
                VStack(spacing: 12) {
                    infoRow(title: "Код направления", value: program.code)
                    infoRow(title: "Направление", value: program.fieldOfStudy)
                    infoRow(title: "Срок обучения", value: "\(program.durationYears) \(yearsString(program.durationYears))")
                }
                .cardStyle()

                // Description
                if !program.programDescription.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        sectionTitle("Описание")
                        Text(program.programDescription)
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .cardStyle()
                }

                // Places
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Места")
                    HStack(spacing: 12) {
                        statBlock(value: "\(program.totalPlaces)", label: "Всего", color: AppColors.accent)
                        statBlock(value: "\(program.budgetPlaces)", label: "Бюджет", color: AppColors.green)
                        statBlock(value: "\(program.paidPlaces)", label: "Платных", color: Color(hex: "#F59E0B"))
                    }

                    if program.totalPlaces > 0 {
                        GeometryReader { geo in
                            HStack(spacing: 2) {
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(AppColors.green)
                                    .frame(width: geo.size.width * CGFloat(program.budgetPlaces) / CGFloat(program.totalPlaces))
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color(hex: "#F59E0B"))
                                    .frame(width: geo.size.width * CGFloat(program.paidPlaces) / CGFloat(program.totalPlaces))
                            }
                        }
                        .frame(height: 8)

                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Circle().fill(AppColors.green).frame(width: 8, height: 8)
                                Text("Бюджет").font(.caption).foregroundStyle(AppColors.textSecondary)
                            }
                            HStack(spacing: 4) {
                                Circle().fill(Color(hex: "#F59E0B")).frame(width: 8, height: 8)
                                Text("Платные").font(.caption).foregroundStyle(AppColors.textSecondary)
                            }
                        }
                    }
                }
                .cardStyle()

                // Cost
                if let tuition = program.tuitionPerYear {
                    VStack(spacing: 12) {
                        infoRow(title: "Стоимость обучения", value: formatCurrency(tuition) + " ₽/год")
                        infoRow(title: "За весь срок", value: formatCurrency(tuition * program.durationYears) + " ₽")
                    }
                    .cardStyle()
                } else if program.paidPlaces == 0 {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(AppColors.green)
                        Text("Все места бюджетные")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(AppColors.green)
                    }
                    .cardStyle()
                }

                // Dates
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Приёмная кампания")
                    infoRow(title: "Приём документов", value: "\(program.applicationStartDate) – \(program.applicationEndDate)")
                    infoRow(title: "Вступительные испытания", value: program.examPeriod)
                }
                .cardStyle()

                // Exams
                VStack(alignment: .leading, spacing: 12) {
                    sectionTitle("Вступительные испытания")
                    ForEach(program.entranceExams) { exam in
                        ExamBadgeView(exam: exam, activeLink: $activeLink)
                    }
                }
                .cardStyle()

                // Portfolio
                if program.portfolioRequired {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundStyle(Color(hex: "#EC4899"))
                            sectionTitle("Портфолио")
                        }
                        Text("Требуется")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(Color(hex: "#EC4899"))
                        if let details = program.portfolioDetails {
                            Text(details)
                                .font(.caption)
                                .foregroundStyle(AppColors.textSecondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .cardStyle()
                } else {
                    HStack {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(AppColors.neutral)
                        Text("Портфолио не требуется")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    .cardStyle()
                }

                // Last year stats
                if program.lastYearApplicants != nil || program.passingScoreLastYear != nil {
                    VStack(alignment: .leading, spacing: 12) {
                        sectionTitle("Статистика прошлого года")
                        if let applicants = program.lastYearApplicants {
                            infoRow(title: "Подало заявления", value: "\(applicants)")
                        }
                        if let enrolled = program.lastYearEnrolled {
                            infoRow(title: "Зачислено", value: "\(enrolled)")
                        }
                        if let score = program.passingScoreLastYear {
                            infoRow(title: "Проходной балл", value: "\(score)")
                        }
                        if let applicants = program.lastYearApplicants, let enrolled = program.lastYearEnrolled, enrolled > 0 {
                            let competition = Double(applicants) / Double(enrolled)
                            infoRow(title: "Конкурс", value: String(format: "%.1f чел./место", competition))
                        }
                    }
                    .cardStyle()
                }

                // Reviews
                if !program.reviews.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            sectionTitle("Отзывы")
                            Spacer()
                            Text("\(program.reviews.count)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(AppColors.accent)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(AppColors.accent.opacity(0.12))
                                .clipShape(Capsule())
                        }
                        ForEach(program.reviews) { review in
                            ReviewCardView(review: review)
                        }
                    }
                    .cardStyle()
                }

                // Disclaimer
                Text("Данные носят справочный характер и могут отличаться от актуальных. Проверяйте информацию на сайте вуза.")
                    .font(.caption2)
                    .foregroundStyle(AppColors.neutral)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
            }
            .padding(AppTheme.horizontalPadding)
        }
        .background(AppColors.background)
        .navigationTitle(program.name)
        .navigationBarTitleDisplayMode(.large)
        .onReceive(tick) { now = $0 }
        .sheet(item: $activeLink) { link in
            SafariView(url: link.url)
                .ignoresSafeArea()
        }
    }

    // MARK: - Useful links

    @ViewBuilder
    private var linksCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Полезные ссылки")

            if let url = programPageURL {
                linkRow(
                    title: "Страница программы",
                    subtitle: url.host ?? url.absoluteString,
                    systemImage: "globe",
                    color: AppColors.accent,
                    url: url
                )
            }

            if let url = applicationPortalURL {
                linkRow(
                    title: "Подача документов",
                    subtitle: url.host ?? url.absoluteString,
                    systemImage: "square.and.arrow.up.on.square",
                    color: Color(hex: "#F59E0B"),
                    url: url
                )
            }

            if let url = curriculumURL {
                linkRow(
                    title: "Учебный план (PDF)",
                    subtitle: "Открыть PDF во встроенном просмотре",
                    systemImage: "doc.richtext.fill",
                    color: AppColors.green,
                    url: url
                )
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "doc.text")
                        .foregroundStyle(AppColors.neutral)
                    Text("Учебный план PDF не опубликован публично вузом — загляните на страницу программы")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 2)
            }
        }
        .cardStyle()
    }

    private func linkRow(title: String, subtitle: String, systemImage: String, color: Color, url: URL) -> some View {
        Button {
            activeLink = SafariLink(url: url)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundStyle(color)
                    .frame(width: 32, height: 32)
                    .background(color.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textPrimary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                        .lineLimit(1)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(AppColors.neutral)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Application status card

    private var applicationStatusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: status.isApplied ? "checkmark.seal.fill" : "square.and.pencil")
                    .font(.title3)
                    .foregroundStyle(status.isApplied ? AppColors.green : AppColors.accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text(status.isApplied ? "Документы поданы" : "Документы не поданы")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.textPrimary)
                    if !status.isApplied, let highlight = urgency.highlightColor {
                        Text(urgency.label)
                            .font(.caption)
                            .foregroundStyle(highlight)
                    } else if status.isApplied {
                        Text("Отметка снимется, если нажмёте ещё раз")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                Spacer()
            }

            Button {
                store.toggle(program.id)
                NotificationService.shared.reschedulePhdApplicationStartNotifications(
                    programs: PhdProgramsDataProvider.programs
                )
            } label: {
                Text(status.isApplied ? "Снять отметку" : "Я подал документы")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(status.isApplied ? AppColors.textPrimary : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        status.isApplied
                            ? AppColors.cardBackground
                            : (urgency.highlightColor ?? AppColors.accent)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                            .stroke(AppColors.cardStroke, lineWidth: status.isApplied ? 1 : 0)
                    )
            }
            .buttonStyle(.plain)
        }
        .cardStyle()
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .stroke(applicationCardStrokeColor, lineWidth: applicationCardStrokeWidth)
        )
    }

    private var applicationCardStrokeColor: Color {
        if status.isApplied { return AppColors.green }
        return urgency.highlightColor ?? Color.clear
    }

    private var applicationCardStrokeWidth: CGFloat {
        if status.isApplied { return 2 }
        switch urgency {
        case .urgent: return 2
        case .soon: return 1.5
        case .upcoming: return 1
        default: return 0
        }
    }

    // MARK: - Helpers

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(AppColors.textSecondary)
            Spacer()
            Text(value)
                .foregroundStyle(AppColors.textPrimary)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(AppColors.textPrimary)
    }

    private func statBlock(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
    }

    private func formatCurrency(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }

    private func yearsString(_ years: Int) -> String {
        switch years {
        case 1: return "год"
        case 2, 3, 4: return "года"
        default: return "лет"
        }
    }
}
