import SwiftUI

struct AppearanceSettingsView: View {
    @AppStorage("appTheme") private var appTheme = "dark"

    private let themes: [(key: String, title: String, icon: String)] = [
        ("dark", "Тёмная", "moon.fill"),
        ("light", "Светлая", "sun.max.fill"),
        ("system", "Системная", "iphone")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(themes, id: \.key) { theme in
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            appTheme = theme.key
                        }
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: theme.icon)
                                .font(.title3)
                                .foregroundStyle(appTheme == theme.key ? AppColors.accent : AppColors.neutral)
                                .frame(width: 32)

                            Text(theme.title)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundStyle(AppColors.textPrimary)

                            Spacer()

                            if appTheme == theme.key {
                                Image(systemName: "checkmark")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppColors.accent)
                            }
                        }
                        .cardStyle()
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(AppTheme.horizontalPadding)
        }
        .background(AppColors.background)
        .navigationTitle("Оформление")
        .navigationBarTitleDisplayMode(.inline)
    }
}
