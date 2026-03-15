import SwiftUI
import SwiftData

struct CategoryManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var categories: [Category] = []
    @State private var showAddAlert = false
    @State private var newCategoryName = ""
    @State private var newCategoryColor = "#8B5CF6"
    @State private var editingCategory: Category?

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if categories.isEmpty {
                    EmptyStateView(
                        icon: "folder",
                        title: "Нет категорий",
                        subtitle: "Добавьте категории для группировки целей"
                    )
                } else {
                    ForEach(categories, id: \.id) { category in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color(hex: category.colorHex))
                                .frame(width: 12, height: 12)

                            Text(category.name)
                                .font(.body)
                                .foregroundStyle(AppColors.textPrimary)

                            Spacer()

                            Text("\(category.goals?.count ?? 0)")
                                .font(.caption)
                                .foregroundStyle(AppColors.textSecondary)

                            Button {
                                editingCategory = category
                                newCategoryName = category.name
                                newCategoryColor = category.colorHex
                                showAddAlert = true
                            } label: {
                                Image(systemName: "pencil")
                                    .foregroundStyle(AppColors.accent)
                            }

                            Button {
                                deleteCategory(category)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(AppColors.red)
                            }
                        }
                        .cardStyle()
                    }
                }
            }
            .padding(AppTheme.horizontalPadding)
        }
        .background(AppColors.background)
        .navigationTitle("Категории")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editingCategory = nil
                    newCategoryName = ""
                    newCategoryColor = "#8B5CF6"
                    showAddAlert = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColors.accent)
                }
            }
        }
        .sheet(isPresented: $showAddAlert) {
            categoryFormSheet
        }
        .onAppear { fetchCategories() }
    }

    private var categoryFormSheet: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Название категории", text: $newCategoryName)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(AppColors.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))

                ColorPickerRow(title: "Цвет", selectedHex: $newCategoryColor)

                Button {
                    saveCategory()
                } label: {
                    Text(editingCategory == nil ? "Создать" : "Сохранить")
                        .accentButtonStyle()
                }
                .disabled(newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty)

                Spacer()
            }
            .padding(AppTheme.horizontalPadding)
            .padding(.top, 20)
            .background(AppColors.background)
            .navigationTitle(editingCategory == nil ? "Новая категория" : "Редактировать")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { showAddAlert = false }
                        .foregroundStyle(AppColors.textSecondary)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func fetchCategories() {
        let descriptor = FetchDescriptor<Category>(sortBy: [SortDescriptor(\.name)])
        categories = (try? modelContext.fetch(descriptor)) ?? []
    }

    private func saveCategory() {
        let name = newCategoryName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }

        if let editing = editingCategory {
            editing.name = name
            editing.colorHex = newCategoryColor
        } else {
            let category = Category(name: name, colorHex: newCategoryColor)
            modelContext.insert(category)
        }

        try? modelContext.save()
        showAddAlert = false
        fetchCategories()
    }

    private func deleteCategory(_ category: Category) {
        modelContext.delete(category)
        try? modelContext.save()
        fetchCategories()
    }
}
