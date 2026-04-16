import SwiftUI
import SwiftData

struct DataManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showDeleteConfirmation = false
    @State private var showFileImporter = false
    @State private var importAlertMessage: String?
    @State private var showImportAlert = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Export
                VStack(alignment: .leading, spacing: 12) {
                    Text("Экспорт данных")
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("Экспортировать все цели, категории и напоминания в формате JSON")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)

                    Button {
                        exportData()
                    } label: {
                        Label("Экспортировать", systemImage: "square.and.arrow.up")
                            .accentButtonStyle()
                    }
                }
                .cardStyle()

                // Import
                VStack(alignment: .leading, spacing: 12) {
                    Text("Импорт данных")
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("Восстановить цели, категории и напоминания из JSON-бэкапа")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)

                    Button {
                        showFileImporter = true
                    } label: {
                        Label("Импортировать", systemImage: "square.and.arrow.down")
                            .accentButtonStyle()
                    }
                }
                .cardStyle()

                // Delete
                VStack(alignment: .leading, spacing: 12) {
                    Text("Удаление данных")
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("Удалить все цели, категории и напоминания. Это действие нельзя отменить.")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)

                    Button {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Удалить все данные", systemImage: "trash")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(AppColors.red)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.buttonCornerRadius))
                    }
                }
                .cardStyle()
            }
            .padding(AppTheme.horizontalPadding)
        }
        .background(AppColors.background)
        .navigationTitle("Данные")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Удалить все данные?", isPresented: $showDeleteConfirmation) {
            Button("Отмена", role: .cancel) {}
            Button("Удалить", role: .destructive) {
                DataExportService.deleteAllData(from: modelContext)
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
        } message: {
            Text("Все цели, категории и напоминания будут удалены без возможности восстановления, включая данные в iCloud.")
        }
        .alert("Импорт", isPresented: $showImportAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(importAlertMessage ?? "")
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result)
        }
    }

    private func exportData() {
        guard let data = DataExportService.exportGoals(from: modelContext) else { return }
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("goals_export.json")
        try? data.write(to: tempURL)

        let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }

        // Find the topmost presented controller
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }

        // iPad requires popover source
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = topVC.view
            popover.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        topVC.present(activityVC, animated: true)
    }

    private func handleImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            guard url.startAccessingSecurityScopedResource() else {
                importAlertMessage = "Нет доступа к файлу."
                showImportAlert = true
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }

            do {
                let data = try Data(contentsOf: url)
                try DataExportService.importGoals(from: data, into: modelContext)
                importAlertMessage = "Данные успешно импортированы!"
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } catch {
                importAlertMessage = error.localizedDescription
            }
            showImportAlert = true

        case .failure(let error):
            importAlertMessage = "Ошибка выбора файла: \(error.localizedDescription)"
            showImportAlert = true
        }
    }
}
