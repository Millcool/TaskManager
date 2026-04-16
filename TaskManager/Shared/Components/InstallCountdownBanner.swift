import SwiftUI

struct InstallCountdownBanner: View {
    @State private var now = Date()
    @State private var pulse = false

    private let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

    private var remaining: TimeInterval {
        InstallTracker.remainingTime(from: now)
    }

    private var isCritical: Bool {
        InstallTracker.isInLastDay(from: now)
    }

    private var isExpired: Bool {
        InstallTracker.isExpired(from: now)
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(iconColor)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(titleText)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(primaryColor)
                Text(subtitleText)
                    .font(.caption)
                    .foregroundStyle(secondaryColor)
            }

            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                .stroke(isCritical ? Color.white.opacity(0.3) : AppColors.cardStroke, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
        .shadow(color: isCritical ? AppColors.red.opacity(0.5) : .clear, radius: 8, y: 2)
        .scaleEffect(pulse ? 1.02 : 1.0)
        .onReceive(timer) { now = $0 }
        .onAppear {
            if isCritical {
                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
        }
    }

    private var iconName: String {
        if isExpired { return "xmark.octagon.fill" }
        if isCritical { return "exclamationmark.triangle.fill" }
        return "clock.fill"
    }

    private var iconColor: Color {
        isCritical || isExpired ? .white : AppColors.accent
    }

    private var primaryColor: Color {
        isCritical || isExpired ? .white : AppColors.textPrimary
    }

    private var secondaryColor: Color {
        isCritical || isExpired ? .white.opacity(0.9) : AppColors.textSecondary
    }

    private var backgroundColor: Color {
        isCritical || isExpired ? AppColors.red : AppColors.cardBackground
    }

    private var titleText: String {
        if isExpired {
            return "Срок установки истёк"
        }
        if isCritical {
            return "Осталось меньше 24 часов"
        }
        return "До переустановки: \(formattedRemaining())"
    }

    private var subtitleText: String {
        if isExpired {
            return "Пересоберите приложение, чтобы оно снова запускалось."
        }
        if isCritical {
            return "\(formattedRemaining()) до удаления. Срочно пересоберите приложение."
        }
        return "Бесплатный аккаунт разработчика: 7 дней с момента установки"
    }

    private func formattedRemaining() -> String {
        let seconds = Int(remaining)
        let days = seconds / 86400
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        if days > 0 {
            return "\(days) д. \(hours) ч."
        }
        if hours > 0 {
            return "\(hours) ч. \(minutes) мин."
        }
        return "\(minutes) мин."
    }
}
