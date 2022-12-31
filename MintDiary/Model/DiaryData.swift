import SwiftUI

// MARK: - DiaryData
class DiaryData: ObservableObject {
    @Published var diaryData: [Diary] = [Diary()]
    
    init() {
        setup()
    }
        
    private static func getDataFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("MintDiary.data")
    }
    
    func load() {
        do {
            let fileURL = try DiaryData.getDataFileURL()
            let fileData = try Data(contentsOf: fileURL)
            diaryData = try JSONDecoder().decode([Diary].self, from: fileData)
            print("数据加载：\(String(describing: $diaryData.count))")
        } catch {
            print("加载失败。")
        }
    }
    
    func save() {
        do {
            let fileURL = try DiaryData.getDataFileURL()
            let fileData = try JSONEncoder().encode(diaryData)
            try fileData.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("保存失败。")
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - DiaryItem
enum DiaryCard: Equatable, CaseIterable, Codable {
    case text(TextModel)
    case sleep(SleepModel)
    
    static var allCases: [DiaryCard] {
        [
            .text(TextModel("新建文本", "这是一段文本。\n这是一段文本。", level: 5)),
            .sleep(SleepModel(8, level: 1))
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
        }
    }
    
    init(_ card: DiaryCard) {
        self.card = card
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}