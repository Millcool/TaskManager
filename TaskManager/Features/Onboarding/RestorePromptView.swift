import SwiftUI
import SwiftData

struct RestorePromptView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let latestBackup: BackupFileManager.BackupFile
    var onDone: () -> Void

    @State private var isRestoring = false
    @State private var resultMessage: String?
    @State private var showResult = false

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "icloud.and.arrow.down.fill")
                .font(.system(size: 72))
                .foregroundStyle(AppColors.accent)
                .padding(.top, 40)

            Text("Найден бэкап")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.textPrimary)

            VStack(spacing: 8) {
                Text("Восстановить данные из предыдущей установки?")
                    .font(.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)

                Text(formatted(latestBackup.date))
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textPrimary)
                Text(latestBackup.location == .iCloud ? "iCloud Drive" : "Локальный файл")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(.horizontal, 32)

            Spacer()

            VStack(spacing: 12) {
                Button {
                    restore()
                } label: {
                    HStack {
                        if isRestoring { ProgressView().tint(.white).scaleEffect(0.8) }
                        Text("Восстановить")
                    }
                    .accentButtonStyle()
                }
                .disabled(isRestoring)

                Button {
                    onDone()
                    dismiss()
                } label: {
                    Text("Начать с нуля")
                        .fontWeight(.medium)
                        .foregroundStyle(AppColors.textSecondary)
                }
                .disabled(isRestoring)
            }
            .padding(.horizontal, AppTheme.horizontalPadding)
            .padding(.bottom, 32)
        }
        .background(AppColors.background)
        .alert("Восстановление", isPresented: $showResult) {
            Button("OK") {
                onDone()
                dismiss()
            }
        } message: {
            Text(resultMessage ?? "")
        }
    }

    private func restore() {
        isRestoring = true
        do {
            try BackupCoordinator.shared.restore(from: latestBackup, context: modelContext)
            resultMessage = "✅ Данные восстановлены."
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } catch {
            resultMessage = "❌ \(error.localizedDescription)"
        }
        showResult = true
        isRestoring = false
    }

    private func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.locale = Locale(identifier: "ru_RU")
        return f.string(from: date)
    }
}
