import SwiftUI

#if os(macOS)
// MARK: - MenuBarDiaryDetailView
struct MenuBarDiaryDetailView: View {
    var diary: Diary
    
    private var displayData: [[(card: DiaryCardData, index: Int)]] {
        createDisplayData(diary)
    }
    
    init(_ diary: Diary) {
        self.diary = diary
    }
    
    // MARK: - 组件
    var body: some View {
        // MARK: -
        ScrollView(.vertical) {
            Grid(alignment: .topLeading, horizontalSpacing: .cardGridSpacing, verticalSpacing: .cardGridSpacing) {
                ForEach(displayData, id: \.self.first?.index) { column in
                    GridRow {
                        ForEach(column, id: \.self.index) { card in
                            CardView(
                                Binding {
                                    card.card
                                } set: { _ in }, false, diaryColumn: 2
                            )
                        }
                    }
                }
                GridRow {
                    Color.clear
                        .frame(height: 0)
                        .gridCellColumns(diary.column)
                }
            }
            .padding()
        }
        .navigationTitle(diary.name)
    }
}

// MARK: - 预览
struct MenuBarDiaryDetailView_Previews: PreviewProvider {
    // MARK: - 容器
    struct MenuBarDiaryDetailViewContainer: View {
        @State private var diary = Diary(
            "新建文本日记",
            [DiaryCardData(.text(TextModel("段落", "这是一段文字。\n这是一段文字。", level: 0)))],
            icon: "doc.fill",
            column: 1
        )
        
        var body: some View {
            MenuBarDiaryDetailView(diary)
        }
    }
    
    static var previews: some View {
        MenuBarDiaryDetailViewContainer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
#endif
