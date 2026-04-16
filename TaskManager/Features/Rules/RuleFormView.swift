import SwiftUI

enum RuleFormMode {
    case create(RuleKind)
    case edit(Rule)
}

struct RuleFormView: View {
    let mode: RuleFormMode
    var viewModel: RulesViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var content: String = ""
    @State private var kind: RuleKind = .rule
    @State private var colorHex: String = "#3B82F6"
    @State private var isPinned: Bool = false

    private var isEditing: Bool {
        if case .edit = mode { return true }
        return false
    }

    private var navTitle: String {
        isEditing ? "Редактировать" : "Новая запись"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Kind
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Тип")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                        Picker("Тип", selection: $kind) {
                            ForEach(RuleKind.allCases, id: \.self) { k in
                                Text(k.title).tag(k)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: kind) { _, newValue in
                            if !isEditing {
                                colorHex = newValue.defaultColorHex
                            }
                        }
                    }

                    // Title
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Заголовок")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                        TextField("Краткая формулировка", text: $title)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(AppColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                    }

                    // Content
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Описание")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                        TextField("Подробно опишите правило, стратегию или принцип", text: $content, axis: .vertical)
                            .textFieldStyle(.plain)
                            .lineLimit(4...12)
                            .padding(12)
                            .background(AppColors.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
                    }

                    ColorPickerRow(title: "Цвет", selectedHex: $colorHex)

                    Toggle(isOn: $isPinned) {
                        Label("Закрепить наверху", systemImage: "pin.fill")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    .tint(AppColors.accent)
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))

                    Button {
                        save()
                    } label: {
                        Text(isEditing ? "Сохранить" : "Создать")
                            .accentButtonStyle()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                    .opacity(title.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
                }
                .padding(AppTheme.horizontalPadding)
            }
            .background(AppColors.background)
            .navigationTitle(navTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { dismiss() }
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
            .onAppear { loadInitial() }
        }
    }

    private func loadInitial() {
        switch mode {
        case .create(let defaultKind):
            kind = defaultKind
            colorHex = defaultKind.defaultColorHex
        case .edit(let rule):
            title = rule.title
            content = rule.content
            kind = rule.kind
            colorHex = rule.colorHex
            isPinned = rule.isPinned
        }
    }

    private func save() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        switch mode {
        case .create:
            viewModel.add(
                title: trimmed,
                content: content,
                kind: kind,
                colorHex: colorHex,
                isPinned: isPinned
            )
        case .edit(let rule):
            viewModel.update(
                rule,
                title: trimmed,
                content: content,
                kind: kind,
                colorHex: colorHex,
                isPinned: isPinned
            )
        }

        dismiss()
    }
}
