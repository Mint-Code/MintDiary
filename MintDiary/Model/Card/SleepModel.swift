import Foundation

// MARK: - SleepModel
struct SleepModel: CardModel {
    var sleep: Int
    var level: Int
    var column: Int
    
    init(_ sleep: Int, level: Int, column: Int = 1) {
        self.sleep = sleep
        self.level = level
        self.column = column
    }
}
