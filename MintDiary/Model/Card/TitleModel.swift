import SwiftUI

// MARK: - TitleModel
struct TitleModel: CardModel {
    var title: String
    var font: TitleFontType
    var weight: TitleFontWeight
    var level: Int
    var column: Int
    
    init(_ title: String, _ font: TitleFontType = .system, _ weight: TitleFontWeight = .light, level: Int, column: Int = 1) {
        self.title = title
        self.level = level
        self.column = column
        self.font = font
        self.weight = weight
    }
}

// MARK: - TitleFontType
enum TitleFontType: Codable {
    case system
    case newYork
}

// MARK: - TitleFontWeight
enum TitleFontWeight: Codable {
    case light
    case medium
    case bold
}
