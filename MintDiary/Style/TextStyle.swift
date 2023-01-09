import SwiftUI

// MARK: - 文字风格
extension View {
    func bodyFont(_ textAlignment: TextAlignment = .leading, _ alignment: Alignment = .leading, level: Int = 0) -> some View {
        self
            .font(.body.weight(.light))
            .frame(maxWidth: .infinity, alignment: alignment)
            .multilineTextAlignment(textAlignment)
            .lineSpacing(.lineSpacing)
            .foregroundColor(.textColor(level))
    }
    
    func headlineFont(_ textAlignment: TextAlignment = .center, _ alignment: Alignment = .center, level: Int = 0) -> some View {
        self
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: alignment)
            .multilineTextAlignment(textAlignment)
            .lineLimit(1)
            .foregroundColor(.secondaryColor(level))
    }
    
    func resumeFont(_ textAlignment: TextAlignment = .center, _ alignment: Alignment = .center, level: Int = 0) -> some View {
        self
            .font(.body.weight(.light))
            .frame(maxWidth: .infinity, alignment: alignment)
            .multilineTextAlignment(textAlignment)
            .foregroundColor(.secondaryColor(level))
    }
    
    func xmarkFont() -> some View {
        self
            .font(.system(size: .xmarkSize, weight: .light))
            .foregroundColor(.accentColor)
    }
}
