import SwiftUI

// MARK: - DiaryDetailView
struct DiaryDetailView: View {
    @ObservedObject var diaryData: DiaryData
    @Binding var diary: Diary
    var index: Int
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isEditing: Bool = false
    @State private var isAddingCard: Bool = false
    @State private var deleteAlert: Bool = false
    @State private var delete: Bool = false

    private var displayData: [[(card: DiaryCardData, index: Int)]] {
        createDisplayData(diary)
    }
    
    init(_ diaryData: DiaryData, _ diary: Binding<Diary>, _ index: Int) {
        self.diaryData = diaryData
        self._diary = diary
        self.index = index
    }
    
    // MARK: - AddCardView
    struct AddCardView: View {
        @Binding var diary: Diary
        
        @Environment(\.dismiss) private var dismiss
        
        init(_ diary: Binding<Diary>) {
            self._diary = diary
        }
        
        // MARK: - CardPreviewView
        struct CardPreviewView<Card: View>: View {
            @Binding var diary: Diary
            var name: String
            var card: Card
            var data: DiaryCard
            var dismiss: DismissAction
            
            init(_ diary: Binding<Diary>, _ name: String, _ data: DiaryCard, dismiss: DismissAction, @ViewBuilder card: () -> Card) {
                self._diary = diary
                self.name = name
                self.card = card()
                self.data = data
                self.dismiss = dismiss
            }
            
            var body: some View {
                VStack {
                    Button {
                        withAnimation(.easeInOut(duration: .animationTime)) {
                            diary.cardData.append(DiaryCardData(data))
                        }
                        dismiss()
                    } label: {
                        card
                    }
                    .buttonStyle(PlainButtonStyle())
                    Text(name)
                        .resumeFont(level: 0)
                }
            }
        }
        
        var body: some View {
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: .cardGridSpacing)], spacing: .cardGridSpacing) {
                    CardPreviewView($diary, "文本段落", .text(CardDocument.text), dismiss: dismiss) {
                        TextCard(.constant(CardDocument.text), false)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    CardPreviewView($diary, "睡眠时长", .sleep(CardDocument.sleep), dismiss: dismiss) {
                        SleepCard(.constant(CardDocument.sleep), false)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .padding()
                .padding(.vertical)
            }
        }
    }
    
    // MARK: - 组件
    var body: some View {
        if delete {
            // MARK: -
            Text("该日记已被删除")
                .resumeFont(level: 0)
                .navigationTitle("")
        } else {
            // MARK: -
            ScrollView(.vertical) {
                Grid(alignment: .topLeading, horizontalSpacing: .cardGridSpacing, verticalSpacing: .cardGridSpacing) {
                    ForEach(displayData, id: \.self.first?.index) { column in
                        GridRow {
                            ForEach(column, id: \.self.index) { card in
                                DiaryCardView(
                                    Binding {
                                        card.card
                                    } set: { newValue in
                                        diary.cardData[card.index] = newValue
                                    }, isEditing
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
            .navigationTitle($diary.name)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarTitleMenu {
                RenameButton()
            }
            .background(colorScheme == .light ? Color.secondaryBackground : Color.secondaryBackground)
#endif
            // MARK: - 工具栏
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        withAnimation(.easeInOut(duration: .animationTime)) {
                            isEditing.toggle()
                        }
                    } label: {
                        Label(isEditing ? "完成" : "编辑", systemImage: isEditing ? "checkmark" : "square.and.pencil")
                    }
                }
                if isEditing {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isAddingCard.toggle()
                        } label: {
                            Label("添加", systemImage: "plus")
                        }
                    }
                } else {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            withAnimation(.easeInOut(duration: .animationTime)) {
                                deleteAlert.toggle()
                            }
                        } label: {
                            Label("删除", systemImage: "trash")
                        }
                    }
                }
            }
            .toolbarRole(.editor)
            .alert(isPresented: $deleteAlert) {
#if os(iOS)
                Alert(
                    title: Text("删除日记"),
                    message: Text("您确定要删除该日记吗？"),
                    primaryButton: .default(
                        Text("取消"),
                        action: {
                            deleteAlert.toggle()
                        }
                    ),
                    secondaryButton: .destructive(
                        Text("删除"),
                        action: {
                            withAnimation(.easeInOut(duration: .animationTime)) {
                                delete.toggle()
                                var _: Diary = diaryData.diaryData.remove(at: index)
                            }
                        }
                    )
                )
#else
                Alert(
                    title: Text("删除日记"),
                    message: Text("您确定要删除该日记吗？"),
                    primaryButton: .default(
                        Text("删除"),
                        action: {
                            withAnimation(.easeInOut(duration: .animationTime)) {
                                delete.toggle()
                                var _: Diary = diaryData.diaryData.remove(at: index)
                            }
                        }
                    ),
                    secondaryButton: .default(
                        Text("取消"),
                        action: {
                            deleteAlert.toggle()
                        }
                    )
                )
#endif
            }
            .sheet(isPresented: $isAddingCard) {
#if os(iOS)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    AddCardView($diary)
                } else {
                    AddCardView($diary)
                        .presentationDetents([.fraction(0.4), .fraction(0.6), .fraction(0.8)])
                }
#else
                AddCardView($diary)
                    .frame(minWidth: 600, maxWidth: 1200, minHeight: 400, maxHeight: 800)
#endif
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
        if UIDevice.current.userInterfaceIdiom == .pad {
            NavigationSplitView {} detail: {
                DiaryDetailViewContainer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            NavigationSplitView {
                DiaryDetailViewContainer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } detail: {}
        }
#else
        DiaryDetailViewContainer()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
#endif
    }
}
