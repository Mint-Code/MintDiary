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
    
    static func tertiaryColor(_ level: Int) -> Color {
        if level != 0 {
            return Color("TertiaryColor\(level)")
        } else {
            return Color("TertiaryColor1")
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
    
    static let textFieldBorderWidth: CGFloat = 1.5
    static let textFieldSpacing: CGFloat = 2
    static let titleTextFieldPaddingVertical: CGFloat = 4
    
    static let cardToolbarButtonPaddingVertical: CGFloat = 6
    static let cardToolbarButtonPaddingHorizontal: CGFloat = 12
    static let cardToolbarButtonCornerRadius: CGFloat = 8
    
    static let progressHeight: CGFloat = 15
    
    static let scrollPaneWidth: CGFloat = 6
    
    static let diaryTemplateCornerRadius: CGFloat = 20
    static let diaryTemplateShadowRadius: CGFloat = 4
    static let diaryTemplateShadowX: CGFloat = 0
    static let diaryTemplateShadowY: CGFloat = 3
    static let diaryTemplateWidth: CGFloat = 140
    static let diaryTemplateHeight: CGFloat = 170
    static let diaryTemplateGridWidth: CGFloat = 150
    static let diaryTemplateGridHeight: CGFloat = 170
    
#if os(iOS)
    static let cardTemplateGridWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 200 : 150
#else
    static let cardTemplateGridWidth: CGFloat = 250
#endif
    
    static let xmarkSize: CGFloat = 16
}

extension CGSize {
    static let textFieldBorderCornerRadius: CGSize = CGSize(width: 8, height: 8)
}

extension Double {
    static let animationTime: Double = 0.2
}
