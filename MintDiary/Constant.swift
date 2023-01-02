import SwiftUI

// MARK: - 颜色
extension Color {
    static func gradient(_ level: Int) -> LinearGradient? {
        if level != 0 {
            return LinearGradient(
                gradient: Gradient(colors: [Color("Gradient\(level)Start"), Color("Gradient\(level)End")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return nil
        }
    }
    
    static func toGradient(_ color: Color) -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [color, color]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static func textColor(_ level: Int) -> Color {
        if level != 0 {
            return Color("TextColor\(level)")
        } else {
            return Color("TextColor1")
        }
    }
    
    static func secondaryColor(_ level: Int) -> Color {
        if level != 0 {
            return Color("SecondaryColor\(level)")
        } else {
            return Color("SecondaryColor1")
        }
    }
    
    static func opacityColor(_ level: Int) -> Color {
        if level != 0 {
            return Color("OpacityColor\(level)")
        } else {
            return Color("OpacityColor1")
        }
    }
    
#if os(iOS)
    static let brightBackground = Color(UIColor.systemBackground)
    static let background = Color(UIColor.quaternarySystemFill)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
#else
    static let brightBackground = Color(NSColor.textBackgroundColor)
    static let background = Color(NSColor.controlBackgroundColor)
    static let secondaryBackground = Color(NSColor.windowBackgroundColor)
    static let tertiaryBackground = Color(NSColor.underPageBackgroundColor)
#endif
}

// MARK: - 数值
extension CGFloat {
    static let lineSpacing: CGFloat = 4
    
    static let cardCornerRadius: CGFloat = 20
    static let cardShadowRadius: CGFloat = 4
    static let cardShadowX: CGFloat = 0
    static let cardShadowY: CGFloat = 3
    
    static let cardGridSpacing: CGFloat = 15
    
    static let textRectangleWidth: CGFloat = 5
    static let textRectangleCornerRadius: CGFloat = 3
    
    static let progressHeight: CGFloat = 15
    
    static let scrollPaneWidth: CGFloat = 6
    
    static let startDocumentCornerRadius: CGFloat = 20
    static let startDocumentShadowRadius: CGFloat = 4
    static let startDocumentShadowX: CGFloat = 0
    static let startDocumentShadowY: CGFloat = 3
    static let startDocumentWidth: CGFloat = 140
    static let startDocumentHeight: CGFloat = 170
    static let startDocumentGridWidth: CGFloat = 150
    static let startDocumentGridHeight: CGFloat = 170
}

extension Double {
    static let animationTime: Double = 0.2
}
