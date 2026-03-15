import SwiftUI

enum AppColors {
    static let background = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.051, green: 0.051, blue: 0.059, alpha: 1) // #0D0D0F
            : UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1) // #F2F2F7
    })

    static let cardBackground = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.102, green: 0.102, blue: 0.180, alpha: 1) // #1A1A2E
            : UIColor.white
    })

    static let accent = Color(hex: "#8B5CF6")
    static let green = Color(hex: "#22C55E")
    static let red = Color(hex: "#EF4444")

    static let neutral = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.420, green: 0.447, blue: 0.502, alpha: 1) // #6B7280
            : UIColor(red: 0.612, green: 0.639, blue: 0.686, alpha: 1) // #9CA3AF
    })

    static let textPrimary = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.white
            : UIColor(red: 0.110, green: 0.110, blue: 0.118, alpha: 1) // #1C1C1E
    })

    static let textSecondary = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.612, green: 0.639, blue: 0.686, alpha: 1) // #9CA3AF
            : UIColor(red: 0.420, green: 0.447, blue: 0.502, alpha: 1) // #6B7280
    })

    static let cardStroke = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.white.withAlphaComponent(0.06)
            : UIColor.black.withAlphaComponent(0.08)
    })
}
