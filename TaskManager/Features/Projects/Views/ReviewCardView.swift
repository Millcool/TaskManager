import SwiftUI

struct ReviewCardView: View {
    let review: StudentReview

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(review.authorName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
                Text("\(review.year)")
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
            }

            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= review.rating ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundStyle(star <= review.rating ? Color(hex: "#F59E0B") : AppColors.neutral)
                }
            }

            Text(review.text)
                .font(.subheadline)
                .foregroundStyle(AppColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)

            if !review.pros.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(review.pros, id: \.self) { pro in
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "plus.circle.fill")
                                .font(.caption2)
                                .foregroundStyle(AppColors.green)
                                .padding(.top, 2)
                            Text(pro)
                                .font(.caption)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }
                }
            }

            if !review.cons.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(review.cons, id: \.self) { con in
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "minus.circle.fill")
                                .font(.caption2)
                                .foregroundStyle(AppColors.red)
                                .padding(.top, 2)
                            Text(con)
                                .font(.caption)
                                .foregroundStyle(AppColors.textSecondary)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(AppColors.cardBackground.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.smallCornerRadius)
                .stroke(AppColors.cardStroke, lineWidth: 1)
        )
    }
}
