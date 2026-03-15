import SwiftUI
import SwiftData

struct DataManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showDeleteConfirmation = false
    @State private var showShareSheet = false
    @State private var exportURL: URL?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Export
                VStack(alignment: .leading, spacing: 12) {
                    Text("Экспорт данных")
                        .font(.headline)
                        .foregroundStyle(AppColors.textPrimary)
                    Text("Экспортировать все цели в формате JSON")
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
        .sheet(isPresented: $showShareSheet) {
            if let url = exportURL {
                ShareSheet(items: [url])
            }
        }
    }

    private func exportData() {
        guard let data = DataExportService.exportGoals(from: modelContext) else { return }
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("goals_export.json")
        try? data.write(to: tempURL)
        exportURL = tempURL
        showShareSheet = true
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
