import SwiftUI

// MARK: - ToolbarButtonStyle
struct ToolbarButtonStyle: ButtonStyle {
    var level: Int
    var isSelected: Bool
    
    @State private var isHover = false

    init(level: Int, isSelected: Bool = false) {
        self.level = level
        self.isSelected = isSelected
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.vertical, .cardToolbarButtonPaddingVertical)
            .padding(.horizontal, .cardToolbarButtonPaddingHorizontal)
            .foregroundColor(configuration.isPressed ? Color.textColor(level) : Color.secondaryColor(level))
            .background(isSelected ? Color.opacityColor(level) : .clear)
            .background(isHover ? Color.opacityColor(level) : .clear)
            .background(configuration.isPressed ? Color.opacityColor(level) : .clear)
            .cornerRadius(.cardToolbarButtonCornerRadius)
            .onHover { hover in
                withAnimation(.easeInOut(duration: .animationTime)) {
                    self.isHover = hover
                }
            }
    }
}

// MARK: - View扩展
extension View {
    func toolbarButtonStyle(level: Int, isSelected: Bool = false) -> some View {
        self
            .buttonStyle(ToolbarButtonStyle(level: level, isSelected: isSelected))
    }
}
