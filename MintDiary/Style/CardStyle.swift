import SwiftUI

// MARK: - 卡片风格
extension View {
    func cardEffect(_ level: Int, _ column: Int, colorScheme: ColorScheme) -> some View {
        self
            .gridCellColumns(column)
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(
                level == 0 ?
                Color.toGradient(.brightBackground) :
                    Color.gradient(level)!
            )
            .cornerRadius(.cardCornerRadius)
            .shadow(radius: .cardShadowRadius, x: .cardShadowX, y: .cardShadowY)
    }
}
