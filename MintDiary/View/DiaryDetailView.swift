import SwiftUI

// MARK: - DiaryDetailView
struct DiaryDetailView: View {
    @ObservedObject var diaryData: DiaryData
    @Binding var diary: Diary
    var index: Int
    var isScaling: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isEditing: Bool = false
    @State private var delete: Bool = false
    
    // MARK: - displayData
    private var displayData: [[(card: DiaryCardData, index: Int)]] {
        var data: [[(card: DiaryCardData, index: Int)]] = [] // 显示的日记行及内容信息
        var columnIndex: Int = 0 // 每个日记行的索引
        var cardIndex: Int = 0 // 每个日记卡片的索引
        while cardIndex < diary.cardData.count {
            data.append([]) // 新建日记行
            var rowColumn: Int = 0 // 当前日记行已经使用的列数
            while rowColumn <= diary.column {
                if cardIndex < diary.cardData.count { // 判断当前卡片索引是否在范围内
                    let card = diary.cardData[cardIndex] // 当前的卡片
                    let cardColumn = card.column // 当前卡片所占的列数
                    if rowColumn + cardColumn <= diary.column { // 判断当前行是否能容纳该卡片
                        data[columnIndex].append((card: card, index: cardIndex)) // 向当前行添加该卡片
                        rowColumn += cardColumn // 更新当前日记行已经使用的列数
                        cardIndex += 1 // 更新当前的卡片索引
                    } else {
                        break
                    }
                } else {
                    break
                }
            }
            columnIndex += 1 // 更新当前的行索引
        }
        return data
    }
    
    init(_ diaryData: DiaryData, _ diary: Binding<Diary>, _ index: Int, isScaling: Bool = false) {
        self.diaryData = diaryData
        self._diary = diary
        self.index = index
        self.isScaling = isScaling
    }
    
    // MARK: - 组件
    var body: some View {
        if delete {
            // MARK: -
            Text("该日记已被删除")
                .resumeFont(level: 0)
        } else {
            // MARK: -
            ScrollView(.vertical) {
                Grid(alignment: .topLeading) {
                    ForEach(displayData, id: \.self.first?.index) { column in
                        GridRow {
                            ForEach(column, id: \.self.index) { card in
                                DiaryCardView(
                                    Binding(get: {
                                        card.card
                                    }, set: { newValue in
                                        diary.cardData[card.index] = newValue
                                    }), isEditing
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
            .background(Color.secondaryBackground)
            .toolbar {
                if !isScaling {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            withAnimation(.easeInOut(duration: .animationTime)) {
                                delete = true
                                var _: Diary = diaryData.diaryData.remove(at: index)
                            }
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                    }
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            withAnimation(.easeInOut(duration: .animationTime)) {
                                isEditing.toggle()
                            }
                        } label: {
                            Label(isEditing ? "完成" : "编辑", systemImage: isEditing ? "checkmark" : "square.and.pencil")
                        }
                    }
                }
            }
        }
    }
}

// MARK: - 预览
struct DiaryDetailView_Previews: PreviewProvider {
    // MARK: - 容器
    struct DiaryDetailViewContainer: View {
        @State private var diary = Diary(
            "新建文本日记",
            [DiaryCardData(.text(TextModel("段落", "这是一段文字。\n这是一段文字。", level: 0)))],
            icon: "doc.fill",
            column: 1
        )
        
        var body: some View {
            DiaryDetailView(DiaryData(), $diary, 0)
        }
    }
    
    static var previews: some View {
#if os(iOS)
        NavigationSplitView {
            DiaryDetailViewContainer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } detail: {}
#else
        DiaryDetailViewContainer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
#endif
    }
}
