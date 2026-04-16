import SwiftUI
import SwiftData

struct BackupListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var backups: [BackupFileManager.BackupFile] = []
    @State private var selectedBackup: BackupFileManager.BackupFile?
    @State private var showRestoreConfirmation = false
    @State private var showDeleteConfirmation = false
    @State private var resultMessage: String?
    @State private var showResult = false

    var body: some View {
        NavigationStack {
            Group {
                if backups.isEmpty {
                    EmptyStateView(
                        icon: "tray",
                        title: "Нет бэкапов",
                        subtitle: "Сделайте первый бэкап в настройках"
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(backups) { backup in
                                row(for: backup)
                            }
                        }
                        .padding(AppTheme.horizontalPadding)
                    }
                }
            }
            .background(AppColors.background)
            .navigationTitle("Бэкапы")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Готово") { dismiss() }
                        .foregroundStyle(AppColors.accent)
                }
            }
            .onAppear { reload() }
            .alert("Восстановить из бэкапа?", isPresented: $showRestoreConfirmation) {
                Button("Отмена", role: .cancel) {}
                Button("Восстановить", role: .destructive) {
                    performRestore()
                }
            } message: {
                Text("Данные из бэкапа будут добавлены к текущим. Существующие цели и категории сохранятся. Продолжить?")
            }
            .alert("Удалить бэкап?", isPresented: $showDeleteConfirmation) {
                Button("Отмена", role: .cancel) {}
                Button("Удалить", role: .destructive) {
                    if let backup = selectedBackup {
                        BackupFileManager.delete(backup)
                        reload()
                    }
                }
            }
            .alert("Восстановление", isPresented: $showResult) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text(resultMessage ?? "")
            }
        }
    }

    private func row(for backup: BackupFileManager.BackupFile) -> some View {
        HStack(spacing: 12) {
            Image(systemName: backup.location == .iCloud ? "icloud.fill" : "doc.fill")
                .foregroundStyle(AppColors.accent)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(formatted(backup.date))
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textPrimary)
                Text("\(backup.location == .iCloud ? "iCloud" : "Локально") · \(sizeString(backup.sizeBytes))")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            Spacer()

            Menu {
                Button {
                    selectedBackup = backup
                    showRestoreConfirmation = true
                } label: {
                    Label("Восстановить", systemImage: "arrow.clockwise")
                }
                Button {
                    share(backup)
                } label: {
                    Label("Поделиться", systemImage: "square.and.arrow.up")
                }
                Divider()
                Button(role: .destructive) {
                    selectedBackup = backup
                    showDeleteConfirmation = true
                } label: {
                    Label("Удалить", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundStyle(AppColors.accent)
            }
        }
        .padding(14)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
    }

    private func reload() {
        backups = BackupFileManager.listBackups()
    }

    private func performRestore() {
        guard let backup = selectedBackup else { return }
        do {
            try BackupCoordinator.shared.restore(from: backup, context: modelContext)
            resultMessage = "✅ Данные из бэкапа успешно восстановлены."
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } catch {
            resultMessage = "❌ Ошибка: \(error.localizedDescription)"
        }
        showResult = true
    }

    private func share(_ backup: BackupFileManager.BackupFile) {
        let vc = UIActivityViewController(activityItems: [backup.url], applicationActivities: nil)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        var topVC = rootVC
        while let presented = topVC.presentedViewController { topVC = presented }
        if let popover = vc.popoverPresentationController {
            popover.sourceView = topVC.view
            popover.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        topVC.present(vc, animated: true)
    }

    private func formatted(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.locale = Locale(identifier: "ru_RU")
        return f.string(from: date)
    }

    private func sizeString(_ bytes: Int) -> String {
        ByteCountFormatter.string(fromByteCount: Int64(bytes), countStyle: .file)
    }
}
