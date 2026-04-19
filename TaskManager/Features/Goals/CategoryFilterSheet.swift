import SwiftUI

struct CategoryFilterSheet: View {
    @Bindable var viewModel: GoalsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""

    private var filteredCategories: [Category] {
        let query = searchText.trimmingCharacters(in: .whitespaces).lowercased()
        guard !query.isEmpty else { return viewModel.allCategories }
        return viewModel.allCategories.filter { $0.name.lowercased().contains(query) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        viewModel.clearCategoryFilter()
                    } label: {
                        HStack {
                            Text("Все категории")
                                .foregroundStyle(AppColors.textPrimary)
                            Spacer()
                            if viewModel.selectedCategoryIds.isEmpty {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(AppColors.accent)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }

                Section {
                    ForEach(filteredCategories, id: \.id) { category in
                        Button {
                            viewModel.toggleCategoryFilter(category.id)
                        } label: {
                            HStack(spacing: 12) {
                                Circle()
                                    .fill(Color(hex: category.colorHex))
                                    .frame(width: 12, height: 12)
                                Text(category.name)
                                    .foregroundStyle(AppColors.textPrimary)
                                Spacer()
                                if viewModel.selectedCategoryIds.contains(category.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(AppColors.accent)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                } header: {
                    if !viewModel.selectedCategoryIds.isEmpty {
                        HStack {
                            Text("Выбрано: \(viewModel.selectedCategoryIds.count)")
                            Spacer()
                            Button("Сбросить") {
                                viewModel.clearCategoryFilter()
                            }
                            .textCase(nil)
                            .foregroundStyle(AppColors.accent)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Поиск категории")
            .navigationTitle("Фильтр")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Готово") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
    }
}
