import SwiftUI
import SwiftData

struct RulesTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = RulesViewModel()
    @State private var showAddSheet = false
    @State private var addKind: RuleKind = .rule

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterBar
                    .padding(.horizontal, AppTheme.horizontalPadding)
                    .padding(.top, 8)
                    .padding(.bottom, 12)

                if !viewModel.searchQuery.isEmpty || viewModel.selectedKind != nil {
                    searchField
                        .padding(.horizontal, AppTheme.horizontalPadding)
                        .padding(.bottom, 8)
                }

                if viewModel.rules.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "list.bullet.rectangle",
                        title: "Пока пусто",
                        subtitle: "Нажмите +, чтобы добавить правило, стратегию или принцип"
                    )
                    Spacer()
                } else if viewModel.filteredRules.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "magnifyingglass",
                        title: "Ничего не найдено",
                        subtitle: "Измените фильтр или поисковый запрос"
                    )
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.groupedByKind, id: \.kind) { group in
                                section(for: group.kind, rules: group.rules)
                            }
                        }
                        .padding(.horizontal, AppTheme.horizontalPadding)
                        .padding(.bottom, 20)
                    }
                }
            }
            .background(AppColors.background)
            .navigationTitle("Правила")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation { toggleSearch() }
                    } label: {
                        Image(systemName: viewModel.searchQuery.isEmpty ? "magnifyingglass" : "xmark.circle.fill")
                            .foregroundStyle(AppColors.accent)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(RuleKind.allCases, id: \.self) { k in
                            Button {
                                addKind = k
                                showAddSheet = true
                            } label: {
                                Label("Новое: \(k.title.lowercased())", systemImage: k.icon)
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.accent)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                RuleFormView(mode: .create(addKind), viewModel: viewModel)
            }
            .onAppear {
                viewModel.setup(modelContext: modelContext)
            }
        }
    }

    private func toggleSearch() {
        if viewModel.searchQuery.isEmpty && viewModel.selectedKind == nil {
            viewModel.searchQuery = " "
            viewModel.searchQuery = ""
        } else {
            viewModel.searchQuery = ""
            viewModel.selectedKind = nil
        }
    }

    private var filterBar: some View {
        HStack(spacing: 8) {
            filterChip(title: "Все", isSelected: viewModel.selectedKind == nil) {
                viewModel.selectedKind = nil
            }
            ForEach(RuleKind.allCases, id: \.self) { k in
                filterChip(title: k.pluralTitle, isSelected: viewModel.selectedKind == k) {
                    viewModel.selectedKind = (viewModel.selectedKind == k) ? nil : k
                }
            }
        }
    }

    private func filterChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? AppColors.accent : AppColors.cardBackground)
                .foregroundStyle(isSelected ? .white : AppColors.textPrimary)
                .clipShape(Capsule())
        }
    }

    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColors.textSecondary)
            TextField("Поиск", text: Binding(
                get: { viewModel.searchQuery },
                set: { viewModel.searchQuery = $0 }
            ))
            .textFieldStyle(.plain)
            if !viewModel.searchQuery.isEmpty {
                Button {
                    viewModel.searchQuery = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .padding(10)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
    }

    private func section(for kind: RuleKind, rules: [Rule]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: kind.icon)
                    .foregroundStyle(Color(hex: kind.defaultColorHex))
                Text(kind.pluralTitle)
                    .font(.headline)
                    .foregroundStyle(AppColors.textPrimary)
                Text("\(rules.count)")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                Spacer()
            }

            VStack(spacing: 8) {
                ForEach(Array(rules.enumerated()), id: \.element.id) { index, rule in
                    NavigationLink(destination: RuleDetailView(rule: rule, viewModel: viewModel)) {
                        RuleRowView(rule: rule)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button {
                            viewModel.togglePinned(rule)
                        } label: {
                            Label(
                                rule.isPinned ? "Открепить" : "Закрепить",
                                systemImage: rule.isPinned ? "pin.slash" : "pin"
                            )
                        }
                        Button {
                            viewModel.moveUp(rule)
                        } label: {
                            Label("Выше", systemImage: "arrow.up")
                        }
                        .disabled(index == 0)
                        Button {
                            viewModel.moveDown(rule)
                        } label: {
                            Label("Ниже", systemImage: "arrow.down")
                        }
                        .disabled(index == rules.count - 1)
                        Divider()
                        Button(role: .destructive) {
                            viewModel.delete(rule)
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            viewModel.delete(rule)
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                        Button {
                            viewModel.togglePinned(rule)
                        } label: {
                            Label(
                                rule.isPinned ? "Открепить" : "Закрепить",
                                systemImage: rule.isPinned ? "pin.slash" : "pin"
                            )
                        }
                        .tint(AppColors.accent)
                    }
                }
            }
        }
    }
}
