import SwiftUI

// MARK: - DiaryData
class DiaryData: ObservableObject {
    @Published var diaryData: [Diary] = [Diary()]
    
    init() {
        setup()
    }
        
    private static func getDataFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("MintDiary.data")
    }
    
    func load() {
        do {
            let fileURL = try DiaryData.getDataFileURL()
            let fileData = try Data(contentsOf: fileURL)
            diaryData = try JSONDecoder().decode([Diary].self, from: fileData)
            print("数据加载。")
        } catch {
            print("加载失败：\(error.localizedDescription)")
        }
    }
    
    func save() {
        do {
            let fileURL = try DiaryData.getDataFileURL()
            let fileData = try JSONEncoder().encode(diaryData)
            try fileData.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("保存失败：\(error.localizedDescription)")
        }
    }
    
    func setup() {
        do {
            let fileURL = try DiaryData.getDataFileURL()
            let fileData = try Data(contentsOf: fileURL)
            diaryData = try JSONDecoder().decode([Diary].self, from: fileData)
        } catch {
            save()
        }
    }
}

// MARK: - Diary
struct Diary: Identifiable, Equatable, Hashable, Codable {
    var id = UUID()
    var name: String
    var icon: String
    var cardData: [DiaryCardData]
    var column: Int
    
    init(
        _ name: String = "新建空白日记",
        _ cardData: [DiaryCardData] = [],
        icon: String = "book",
        column: Int = 2
    ) {
        self.cardData = cardData
        self.column = column
        self.name = name
        self.icon = icon
    }
    
    init(
        _ name: String = "新建空白日记",
        icon: String = "book",
        column: Int = 2,
        @DiaryContentBuilder cardData: () -> [DiaryCardData]
    ) {
        self.cardData = cardData()
        self.column = column
        self.name = name
        self.icon = icon
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - DiaryItem
enum DiaryCard: Equatable, CaseIterable, Codable {
    case text(TextModel)
    case sleep(SleepModel)
    case title(TitleModel)
    
    static var allCases: [DiaryCard] {
        [
            .text(CardTemplate.text),
            .sleep(CardTemplate.sleep),
            .title(CardTemplate.title)
        ]
    }
}

// MARK: - DiaryItemData
struct DiaryCardData: Identifiable, Equatable, Hashable, Codable {
    var id = UUID()
    var card: DiaryCard
    var column: Int {
        switch card {
        case .text(let model):
            return model.column
        case .sleep(let model):
            return model.column
        case .title(let model):
            return model.column
        }
    }
    
    init(_ card: DiaryCard) {
        self.card = card
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - DiaryTemplate
struct DiaryTemplate {
    static var empty = Diary("新建空白日记", icon: "book", column: 2) {}
    
    static var text = Diary("新建文本日记", icon: "doc", column: 1) {
        TextModel("段落", "这是一段文字。\n这是一段文字。", level: 0)
    }
    
    static var simpleDiary = Diary("新建日记", icon: "book.closed", column: 3) {
        TitleModel("日记标题", .newYork, .bold, level: 6, column: 3)
        TextModel("今日小记", "今天发生了什么？\n在这里记录今天发生的事情……", level: 1, column: 2)
        TextModel("今日心情", "今天的心情怎么样？\n在这里记录你的心情……", level: 4)
        SleepModel(8, level: 3)
        TextModel("今日小记", "今天发生了什么？\n在这里记录今天发生的事情……", level: 5, column: 2)
        TextModel("今日小记", "今天发生了什么？\n在这里记录今天发生的事情……", level: 2, column: 3)
    }
}

// MARK: - CardTemplate
struct CardTemplate {
    static var text = TextModel("段落", "这是一段文字。\n这是一段文字。", level: 0)
    static var sleep = SleepModel(8, level: 0)
    static var title = TitleModel("标题文字", level: 0)
}

// MARK: - DiaryContentBuilder
@resultBuilder
enum DiaryContentBuilder {
    static func buildBlock(_ components: any CardModel...) -> [DiaryCardData] {
        var content: [DiaryCardData] = []
        for model in components {
            if let textModel = model as? TextModel {
                content.append(DiaryCardData(.text(textModel)))
            } else if let sleepModel = model as? SleepModel {
                content.append(DiaryCardData(.sleep(sleepModel)))
            } else if let titleModel = model as? TitleModel {
                content.append(DiaryCardData(.title(titleModel)))
            }
        }
        return content
    }
}
