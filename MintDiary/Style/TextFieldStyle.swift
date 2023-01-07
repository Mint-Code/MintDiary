import SwiftUI

// MARK: - 文本输入框风格
extension View {
    func textFieldBorder(level: Int = 0) -> some View {
        self
            .background(
                RoundedRectangle(cornerSize: .textFieldBorderCornerRadius)
                    .stroke(Color.opacityColor(level), lineWidth: .textFieldBorderWidth)
            )
    }
    
    func titleTextFieldStyle(level: Int = 0) -> some View {
        self
            .textFieldStyle(.plain)
            .headlineFont(level: level)
            .padding(.vertical, .titleTextFieldPaddingVertical)
            .textFieldBorder(level: level)
    }
    
    func contentTextFieldStyle(level: Int = 0) -> some View {
        self
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            .padding(.horizontal)
            .padding(.vertical)
            .textFieldBorder(level: level)
            .padding(.horizontal)
    }
}
