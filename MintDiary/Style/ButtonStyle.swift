import SwiftUI

// MARK: - ToolbarButtonStyle
struct ToolbarButtonStyle: ButtonStyle {
    var level: Int
    
    @State private var isHover = false

    init(level: Int) {
        self.level = level
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .onHover { hover in
                withAnimation(.easeInOut(duration: .animationTime)) {
                    self.isHover = hover
                }
            }
            .padding(.vertical, .cardToolbarButtonPaddingVertical)
            .padding(.horizontal, .cardToolbarButtonPaddingHorizontal)
            .foregroundColor(configuration.isPressed ? Color.textColor(level) : Color.secondaryColor(level))
            .background(isHover ? Color.opacityColor(level) : .clear)
            .background(configuration.isPressed ? Color.opacityColor(level) : .clear)
            .cornerRadius(.cardToolbarButtonCornerRadius)
    }
}

// MARK: - View扩展
extension View {
    func toolbarButtonStyle(level: Int) -> some View {
        self
            .buttonStyle(ToolbarButtonStyle(level: level))
    }
}
