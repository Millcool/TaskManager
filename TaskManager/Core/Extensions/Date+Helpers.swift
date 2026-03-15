import Foundation

extension Date {
    private static var appCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2 // Monday
        return cal
    }

    var startOfDay: Date {
        Date.appCalendar.startOfDay(for: self)
    }

    var startOfWeek: Date {
        let cal = Date.appCalendar
        let components = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return cal.date(from: components) ?? self
    }

    var startOfMonth: Date {
        let cal = Date.appCalendar
        let components = cal.dateComponents([.year, .month], from: self)
        return cal.date(from: components) ?? self
    }

    var startOfYear: Date {
        let cal = Date.appCalendar
        let components = cal.dateComponents([.year], from: self)
        return cal.date(from: components) ?? self
    }

    func adding(_ component: Calendar.Component, value: Int) -> Date {
        Date.appCalendar.date(byAdding: component, value: value, to: self) ?? self
    }

    var endOfDay: Date {
        adding(.day, value: 1).addingTimeInterval(-1)
    }

    var endOfWeek: Date {
        startOfWeek.adding(.weekOfYear, value: 1).addingTimeInterval(-1)
    }

    var endOfMonth: Date {
        startOfMonth.adding(.month, value: 1).addingTimeInterval(-1)
    }

    var endOfYear: Date {
        startOfYear.adding(.year, value: 1).addingTimeInterval(-1)
    }
}
