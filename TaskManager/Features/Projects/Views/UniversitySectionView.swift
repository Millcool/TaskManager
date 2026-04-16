import SwiftUI

struct UniversitySectionView: View {
    let university: University
    let programs: [PhdProgram]
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    onToggle()
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: university.logoSystemImage)
                        .font(.title3)
                        .foregroundStyle(AppColors.accent)
                        .frame(width: 40, height: 40)
                        .background(AppColors.accent.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(university.shortName)
                            .font(.headline)
                            .foregroundStyle(AppColors.textPrimary)
                        HStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Image(systemName: "mappin")
                                    .font(.caption2)
                                Text(university.city)
                                    .font(.caption)
                            }
                            .foregroundStyle(AppColors.textSecondary)

                            Text("•")
                                .foregroundStyle(AppColors.neutral)

                            Text("\(programs.count) \(programsString(programs.count))")
                                .font(.caption)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.neutral)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(AppTheme.cardPadding)
                .background(AppColors.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius)
                        .stroke(AppColors.cardStroke, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(programs) { program in
                        ProgramCardView(program: program, university: university)
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    private func programsString(_ count: Int) -> String {
        let mod10 = count % 10
        let mod100 = count % 100
        if mod10 == 1 && mod100 != 11 {
            return "программа"
        } else if mod10 >= 2 && mod10 <= 4 && (mod100 < 10 || mod100 >= 20) {
            return "программы"
        } else {
            return "программ"
        }
    }
}
