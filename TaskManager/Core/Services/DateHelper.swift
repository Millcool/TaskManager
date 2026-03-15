import Foundation

enum DateHelper {
    private static var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2
        cal.locale = Locale(identifier: "ru_RU")
        return cal
    }

    static func periodStartDate(for date: Date, period: GoalPeriod) -> Date {
        switch period {
        case .day: return date.startOfDay
        case .week: return date.startOfWeek
        case .month: return date.startOfMonth
        case .year: return date.startOfYear
        }
    }

    static func periodEndDate(for date: Date, period: GoalPeriod) -> Date {
        let start = periodStartDate(for: date, period: period)
        switch period {
        case .day: return start.endOfDay
        case .week: return start.endOfWeek
        case .month: return start.endOfMonth
        case .year: return start.endOfYear
        }
    }

    static func navigate(from date: Date, period: GoalPeriod, direction: Int) -> Date {
        let component: Calendar.Component
        switch period {
        case .day: component = .day
        case .week: component = .weekOfYear
        case .month: component = .month
        case .year: component = .year
        }
        return calendar.date(byAdding: component, value: direction, to: date) ?? date
    }

    static func periodTitle(for date: Date, period: GoalPeriod) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")

        switch period {
        case .day:
            let cal = calendar
            if cal.isDateInToday(date) {
                return "Сегодня"
            } else if cal.isDateInYesterday(date) {
                return "Вчера"
            } else if cal.isDateInTomorrow(date) {
                return "Завтра"
            }
            formatter.dateFormat = "d MMMM yyyy"
            return formatter.string(from: date)

        case .week:
            let start = date.startOfWeek
            let end = start.adding(.day, value: 6)
            let startFmt = DateFormatter()
            startFmt.locale = Locale(identifier: "ru_RU")
            startFmt.dateFormat = "d MMM"
            let endFmt = DateFormatter()
            endFmt.locale = Locale(identifier: "ru_RU")
            endFmt.dateFormat = "d MMM"
            return "\(startFmt.string(from: start)) — \(endFmt.string(from: end))"

        case .month:
            formatter.dateFormat = "LLLL yyyy"
            return formatter.string(from: date).capitalized

        case .year:
            formatter.dateFormat = "yyyy"
            return formatter.string(from: date)
        }
    }
}
