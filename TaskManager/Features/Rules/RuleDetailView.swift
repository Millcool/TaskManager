import SwiftUI

struct RuleDetailView: View {
    let rule: Rule
    var viewModel: RulesViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var showEditSheet = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: rule.kind.icon)
                        .foregroundStyle(Color(hex: rule.colorHex))
                    Text(rule.kind.title)
                        .font(.subheadline)
                        .foregroundStyle(AppColors.textSecondary)
                    if rule.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption)
                            .foregroundStyle(AppColors.accent)
                    }
                    Spacer()
                }

                Text(rule.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textPrimary)

                if !rule.content.isEmpty {
                    Text(rule.content)
                        .font(.body)
                        .foregroundStyle(AppColors.textPrimary)
                        .textSelection(.enabled)
                }

                Divider().padding(.vertical, 4)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Создано: \(formatted(rule.createdAt))")
                        .font(.caption)
                        .foregroundStyle(AppColors.textSecondary)
                    if rule.updatedAt != rule.createdAt {
                        Text("Обновлено: \(formatted(rule.updatedAt))")
                            .font(.caption)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppTheme.horizontalPadding)
        }
        .background(AppColors.background)
        .navigationTitle(rule.kind.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showEditSheet = true
                    } label: {
                        Label("Редактировать", systemImage: "pencil")
                    }
                    Button {
                        viewModel.togglePinned(rule)
                    } label: {
                        Label(rule.isPinned ? "Открепить" : "Закрепить",
                              systemImage: rule.isPinned ? "pin.slash" : "pin")
                    }
                    Divider()
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(AppColors.accent)
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            RuleFormView(mode: .edit(rule), viewModel: viewModel)
        }
        .alert("Удалить?", isPresented: $showDeleteConfirmation) {
            Button("Отмена", role: .cancel) {}
            Button("Удалить", role: .destructive) {
                viewModel.delete(rule)
                dismiss()
            }
        }
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
    }
}
