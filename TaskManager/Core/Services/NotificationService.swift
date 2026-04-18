import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    private let center = UNUserNotificationCenter.current()

    // MARK: - Permission

    func requestPermission() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    // MARK: - System Notifications

    func rescheduleAllSystemNotifications() {
        let defaults = UserDefaults.standard

        // Cancel old system notifications
        let systemIds = ["daily_planning", "weekly_planning", "monthly_planning", "yearly_planning"]
        center.removePendingNotificationRequests(withIdentifiers: systemIds)

        // Daily
        if defaults.bool(forKey: "notification_daily_enabled") {
            let hour = defaults.integer(forKey: "notification_daily_hour")
            let minute = defaults.integer(forKey: "notification_daily_minute")
            let h = hour == 0 && minute == 0 ? 23 : hour
            let m = hour == 0 && minute == 0 ? 50 : minute
            scheduleRepeating(
                id: "daily_planning",
                title: "Планирование дня",
                body: "Пора запланировать цели на завтра",
                hour: h, minute: m,
                weekday: nil
            )
        }

        // Weekly
        if defaults.bool(forKey: "notification_weekly_enabled") {
            let hour = defaults.integer(forKey: "notification_weekly_hour")
            let minute = defaults.integer(forKey: "notification_weekly_minute")
            let h = hour == 0 && minute == 0 ? 11 : hour
            scheduleRepeating(
                id: "weekly_planning",
                title: "Планирование недели",
                body: "Пора запланировать цели на следующую неделю",
                hour: h, minute: minute,
                weekday: 1 // Sunday
            )
        }

        // Monthly
        if defaults.bool(forKey: "notification_monthly_enabled") {
            let hour = defaults.integer(forKey: "notification_monthly_hour")
            let minute = defaults.integer(forKey: "notification_monthly_minute")
            let h = hour == 0 && minute == 0 ? 11 : hour
            scheduleMonthly(
                id: "monthly_planning",
                title: "Планирование месяца",
                body: "Пора запланировать цели на следующий месяц",
                day: 1, hour: h, minute: minute
            )
        }

        // Yearly
        if defaults.bool(forKey: "notification_yearly_enabled") {
            let hour = defaults.integer(forKey: "notification_yearly_hour")
            let minute = defaults.integer(forKey: "notification_yearly_minute")
            let h = hour == 0 && minute == 0 ? 11 : hour
            scheduleYearly(
                id: "yearly_planning",
                title: "Планирование года",
                body: "Пора запланировать цели на следующий год",
                month: 1, day: 1, hour: h, minute: minute
            )
        }
    }

    // MARK: - Goal Reminders

    func scheduleGoalReminder(_ reminder: GoalReminder, goalName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Напоминание"
        content.body = goalName
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: reminder.reminderDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: reminder.notificationIdentifier,
            content: content,
            trigger: trigger
        )

        center.add(request)
    }

    func cancelNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    // MARK: - PhD Application Start

    private static let phdApplicationIdPrefix = "phd_app_start_"

    func reschedulePhdApplicationStartNotifications(
        programs: [PhdProgram],
        store: PhdApplicationStore = .shared,
        universityLookup: @escaping (PhdProgram) -> University? = { PhdProgramsDataProvider.university(for: $0) }
    ) {
        center.getPendingNotificationRequests { [center] requests in
            let toRemove = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(Self.phdApplicationIdPrefix) }
            if !toRemove.isEmpty {
                center.removePendingNotificationRequests(withIdentifiers: toRemove)
            }

            let now = Date()
            for program in programs {
                guard store.status(for: program.id) == .notApplied else { continue }
                guard let start = PhdDateParser.date(from: program.applicationStartDate, reference: now) else { continue }
                let triggerDate = Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: start) ?? start
                guard triggerDate > now else { continue }

                let content = UNMutableNotificationContent()
                let uniName = universityLookup(program)?.shortName ?? "вуз"
                content.title = "Открыт приём документов"
                content.body = "\(uniName): «\(program.name)». Приём до \(program.applicationEndDate)."
                content.sound = .default

                let components = Calendar.current.dateComponents(
                    [.year, .month, .day, .hour, .minute],
                    from: triggerDate
                )
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

                let request = UNNotificationRequest(
                    identifier: Self.phdApplicationIdPrefix + program.id.uuidString,
                    content: content,
                    trigger: trigger
                )
                center.add(request)
            }
        }
    }

    // MARK: - PhD Daily Deadline (23:00)

    private static let phdDailyDeadlineIdPrefix = "phd_daily_deadline_"
    private static let phdDailyDeadlineHorizonDays = 30

    func rescheduleDailyDeadlineNotifications(
        programs: [PhdProgram],
        store: PhdApplicationStore = .shared,
        universityLookup: @escaping (PhdProgram) -> University? = { PhdProgramsDataProvider.university(for: $0) }
    ) {
        center.getPendingNotificationRequests { [center] requests in
            let toRemove = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(Self.phdDailyDeadlineIdPrefix) }
            if !toRemove.isEmpty {
                center.removePendingNotificationRequests(withIdentifiers: toRemove)
            }

            let calendar = Calendar.current
            let now = Date()

            for offset in 0..<Self.phdDailyDeadlineHorizonDays {
                guard let baseDate = calendar.date(byAdding: .day, value: offset, to: now),
                      let triggerDate = calendar.date(bySettingHour: 23, minute: 0, second: 0, of: baseDate),
                      triggerDate > now else { continue }

                let candidates: [(PhdProgram, Int)] = programs.compactMap { program in
                    guard store.status(for: program.id) == .notApplied,
                          let start = PhdDateParser.date(from: program.applicationStartDate, reference: triggerDate) else {
                        return nil
                    }
                    let fromDay = calendar.startOfDay(for: triggerDate)
                    let toDay = calendar.startOfDay(for: start)
                    guard let days = calendar.dateComponents([.day], from: fromDay, to: toDay).day, days > 0 else {
                        return nil
                    }
                    return (program, days)
                }

                guard let nearest = candidates.min(by: { $0.1 < $1.1 }) else { continue }
                let (program, days) = nearest
                let uniName = universityLookup(program)?.shortName ?? "вуз"

                let content = UNMutableNotificationContent()
                content.title = "До приёма документов: \(days) \(Self.russianDayWord(days))"
                content.body = "\(uniName) — «\(program.name)». Открытие: \(program.applicationStartDate)."
                content.sound = .default

                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(
                    identifier: Self.phdDailyDeadlineIdPrefix + String(offset),
                    content: content,
                    trigger: trigger
                )
                center.add(request)
            }
        }
    }

    // MARK: - PhD Random Program Daily (12:00)

    private static let phdRandomProgramIdPrefix = "phd_random_program_"
    private static let phdRandomProgramHorizonDays = 30

    func rescheduleDailyRandomProgramNotifications(
        programs: [PhdProgram],
        universityLookup: @escaping (PhdProgram) -> University? = { PhdProgramsDataProvider.university(for: $0) }
    ) {
        center.getPendingNotificationRequests { [center] requests in
            let toRemove = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(Self.phdRandomProgramIdPrefix) }
            if !toRemove.isEmpty {
                center.removePendingNotificationRequests(withIdentifiers: toRemove)
            }

            guard !programs.isEmpty else { return }
            let calendar = Calendar.current
            let now = Date()

            for offset in 0..<Self.phdRandomProgramHorizonDays {
                guard let baseDate = calendar.date(byAdding: .day, value: offset, to: now),
                      let triggerDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: baseDate),
                      triggerDate > now,
                      let program = programs.randomElement() else { continue }

                let uniName = universityLookup(program)?.shortName ?? "вуз"
                var lines: [String] = ["Код: \(program.code) • \(program.fieldOfStudy)"]
                if let page = PhdProgramsDataProvider.resolvedProgramPageURL(for: program) {
                    lines.append("Сайт программы: \(page)")
                }
                if let curriculum = PhdProgramsDataProvider.curriculumURL(for: program) {
                    lines.append("Учебный план: \(curriculum)")
                }
                if let portal = PhdProgramsDataProvider.resolvedApplicationPortalURL(for: program) {
                    lines.append("Подача документов: \(portal)")
                }

                let content = UNMutableNotificationContent()
                content.title = "Аспирантура дня — \(uniName)"
                content.subtitle = program.name
                content.body = lines.joined(separator: "\n")
                content.sound = .default
                content.userInfo = ["phdProgramId": program.id.uuidString]

                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(
                    identifier: Self.phdRandomProgramIdPrefix + String(offset),
                    content: content,
                    trigger: trigger
                )
                center.add(request)
            }
        }
    }

    // MARK: - Daily Goal Reminders (08:00 + 16:00)

    private static let dailyGoalMorningIdPrefix = "daily_goal_morning_"
    private static let dailyGoalAfternoonIdPrefix = "daily_goal_afternoon_"
    private static let dailyGoalHorizonDays = 7

    func rescheduleDailyGoalReminders(hasGoalsForToday: Bool) {
        center.getPendingNotificationRequests { [center] requests in
            let toRemove = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(Self.dailyGoalMorningIdPrefix) || $0.hasPrefix(Self.dailyGoalAfternoonIdPrefix) }
            if !toRemove.isEmpty {
                center.removePendingNotificationRequests(withIdentifiers: toRemove)
            }

            let calendar = Calendar.current
            let now = Date()

            for offset in 0..<Self.dailyGoalHorizonDays {
                guard let baseDate = calendar.date(byAdding: .day, value: offset, to: now) else { continue }
                let goalsToday = offset == 0 ? hasGoalsForToday : false

                if let morning = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: baseDate), morning > now, !goalsToday {
                    let content = UNMutableNotificationContent()
                    content.title = "Поставь цели на день"
                    content.body = "Доброе утро! Задай, что хочешь сделать сегодня."
                    content.sound = .default

                    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: morning)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                    let request = UNNotificationRequest(
                        identifier: Self.dailyGoalMorningIdPrefix + String(offset),
                        content: content,
                        trigger: trigger
                    )
                    center.add(request)
                }

                if let afternoon = calendar.date(bySettingHour: 16, minute: 0, second: 0, of: baseDate), afternoon > now {
                    let content = UNMutableNotificationContent()
                    if goalsToday {
                        content.title = "Как прогресс по целям?"
                        content.body = "Отметь, насколько продвинулся за сегодня."
                    } else {
                        content.title = "Цели на день не поставлены"
                        content.body = "Ещё есть время — выдели пару минут и запиши цели."
                    }
                    content.sound = .default

                    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: afternoon)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                    let request = UNNotificationRequest(
                        identifier: Self.dailyGoalAfternoonIdPrefix + String(offset),
                        content: content,
                        trigger: trigger
                    )
                    center.add(request)
                }
            }
        }
    }

    // MARK: - Study Question Daily (09:00)

    private static let studyQuestionIdPrefix = "study_question_"
    private static let studyQuestionHorizonDays = 30

    func rescheduleDailyStudyQuestionNotifications(groups: [StudyGroup] = StudyDataProvider.allGroups) {
        center.getPendingNotificationRequests { [center] requests in
            let toRemove = requests
                .map(\.identifier)
                .filter { $0.hasPrefix(Self.studyQuestionIdPrefix) }
            if !toRemove.isEmpty {
                center.removePendingNotificationRequests(withIdentifiers: toRemove)
            }

            let pool: [(group: StudyGroup, topic: StudyTopic, question: StudyQuestion)] = groups.flatMap { group in
                group.topics.flatMap { topic in
                    topic.questions.map { (group, topic, $0) }
                }
            }
            guard !pool.isEmpty else { return }

            let calendar = Calendar.current
            let now = Date()

            for offset in 0..<Self.studyQuestionHorizonDays {
                guard let baseDate = calendar.date(byAdding: .day, value: offset, to: now),
                      let triggerDate = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: baseDate),
                      triggerDate > now,
                      let pick = pool.randomElement() else { continue }

                let content = UNMutableNotificationContent()
                content.title = pick.question.question
                content.subtitle = "\(pick.group.title) · \(pick.topic.title)"
                content.body = pick.question.answer
                content.sound = .default
                content.userInfo = [
                    "studyQuestionId": pick.question.id.uuidString,
                    "studyTopicId": pick.topic.id.uuidString,
                    "studyGroupId": pick.group.id.uuidString
                ]

                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                let request = UNNotificationRequest(
                    identifier: Self.studyQuestionIdPrefix + String(offset),
                    content: content,
                    trigger: trigger
                )
                center.add(request)
            }
        }
    }

    private static func russianDayWord(_ n: Int) -> String {
        let lastTwo = abs(n) % 100
        if (11...14).contains(lastTwo) { return "дней" }
        switch abs(n) % 10 {
        case 1: return "день"
        case 2, 3, 4: return "дня"
        default: return "дней"
        }
    }

    // MARK: - Private

    private func scheduleRepeating(id: String, title: String, body: String, hour: Int, minute: Int, weekday: Int?) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        if let weekday {
            components.weekday = weekday
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request)
    }

    private func scheduleMonthly(id: String, title: String, body: String, day: Int, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var components = DateComponents()
        components.day = day
        components.hour = hour
        components.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request)
    }

    private func scheduleYearly(id: String, title: String, body: String, month: Int, day: Int, hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var components = DateComponents()
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        center.add(request)
    }
}
