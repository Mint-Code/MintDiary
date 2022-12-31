import Foundation

// MARK: - TextModel
struct TextModel: CardModel {
    var title: String
    var text: String
    var level: Int
    var column: Int
    var textCenter: Bool
    
    init(_ title: String, _ text: String, level: Int, column: Int = 1, textCenter: Bool = false) {
        self.title = title
        self.text = text
        self.level = level
        self.column = column
        self.textCenter = textCenter
    }
}
