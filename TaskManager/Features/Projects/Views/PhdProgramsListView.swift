import SwiftUI

struct PhdProgramsListView: View {
    @State private var viewModel = PhdProgramsViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.verticalSpacing) {
                // City filter chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        cityChip(title: "Все", city: nil)
                        ForEach(viewModel.cities, id: \.self) { city in
                            cityChip(title: city, city: city)
                        }
                    }
                    .padding(.horizontal, AppTheme.horizontalPadding)
                }

                // Stats summary
                HStack(spacing: 12) {
                    summaryItem(value: "\(viewModel.filteredUniversities.count)", label: "вузов")
                    summaryItem(
                        value: "\(viewModel.filteredUniversities.reduce(0) { $0 + viewModel.programs(for: $1).count })",
                        label: "программ"
                    )
                    summaryItem(
                        value: "\(viewModel.filteredUniversities.reduce(0) { $0 + viewModel.programs(for: $1).reduce(0) { $0 + $1.budgetPlaces } })",
                        label: "бюдж. мест"
                    )
                }
                .padding(.horizontal, AppTheme.horizontalPadding)

                // Universities list
                LazyVStack(spacing: AppTheme.verticalSpacing) {
                    ForEach(viewModel.filteredUniversities) { university in
                        UniversitySectionView(
                            university: university,
                            programs: viewModel.programs(for: university),
                            isExpanded: viewModel.isExpanded(university.id),
                            onToggle: { viewModel.toggleUniversity(university.id) }
                        )
                    }
                }
                .padding(.horizontal, AppTheme.horizontalPadding)

                if viewModel.filteredUniversities.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundStyle(AppColors.neutral)
                        Text("Ничего не найдено")
                            .font(.headline)
                            .foregroundStyle(AppColors.textSecondary)
                        Text("Попробуйте изменить параметры поиска")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.neutral)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                }

                // Disclaimer
                Text("Данные носят справочный характер. Актуальную информацию уточняйте на сайтах вузов.")
                    .font(.caption2)
                    .foregroundStyle(AppColors.neutral)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.horizontalPadding)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
            }
            .padding(.top, 8)
        }
        .background(AppColors.background)
        .navigationTitle("Аспирантура")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.searchText, prompt: "Поиск университета или программы")
    }

    private func cityChip(title: String, city: String?) -> some View {
        let isSelected = viewModel.selectedCity == city
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.selectCity(city)
            }
        } label: {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? .white : AppColors.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? AppColors.accent : AppColors.cardBackground)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : AppColors.cardStroke, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private func summaryItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.accent)
            Text(label)
                .font(.caption2)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                .stroke(AppColors.cardStroke, lineWidth: 1)
        )
    }
}
