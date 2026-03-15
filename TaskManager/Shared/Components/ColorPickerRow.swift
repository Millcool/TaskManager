import SwiftUI

struct ColorPickerRow: View {
    let title: String
    @Binding var selectedHex: String

    private let colors = [
        "#8B5CF6", "#EC4899", "#EF4444", "#F97316",
        "#EAB308", "#22C55E", "#14B8A6", "#3B82F6"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(AppColors.textSecondary)

            HStack(spacing: 10) {
                ForEach(colors, id: \.self) { hex in
                    Circle()
                        .fill(Color(hex: hex))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: selectedHex == hex ? 2 : 0)
                        )
                        .onTapGesture {
                            selectedHex = hex
                        }
                }
            }
        }
    }
}
