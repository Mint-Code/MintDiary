import SwiftUI

#if os(iOS)
// MARK: - DiaryDetailView - iOS
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
    
    init(_ diaryData: DiaryData, _ diary: Binding<Diary>, index: Int) {
        self.diaryData = diaryData
        self._diary = diary
        self.index = index
    }
    
    // MARK: - 组件 - iOS
    var body: some View {
        if delete {
            Text("该日记已被删除")
                .resumeFont()
        } else {
            // MARK: -
            ScrollView(.vertical) {
                Grid(alignment: .topLeading, horizontalSpacing: .cardGridSpacing, verticalSpacing: .cardGridSpacing) {
                    ForEach(displayData, id: \.self.first?.index) { column in
                        GridRow {
                            ForEach(column, id: \.self.index) { card in
                                CardView(
                                    Binding {
                                        card.card
                                    } set: { newValue in
                                        diary.cardData[card.index] = newValue
                                    }, isEditing, diaryColumn: diary.column
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbarTitleMenu {
                RenameButton()
            }
            .background(colorScheme == .light ? Color.secondaryBackground : Color.secondaryBackground)
            // MARK: - 工具栏 - iOS
            .toolbar(id: "DiaryDetailToolbar") {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    // MARK: -
                    ToolbarItem(id: "Edit", placement: .primaryAction, showsByDefault: true) {
                        Button {
                            withAnimation(.easeInOut(duration: .animationTime)) {
                                isEditing.toggle()
                            }
                        } label: {
                            Label(isEditing ? "完成" : "编辑", systemImage: isEditing ? "checkmark" : "square.and.pencil")
                        }
                    }
                    if isEditing {
                        ToolbarItem(id: "Add", placement: .primaryAction, showsByDefault: true) {
                            Button {
                                isAddingCard.toggle()
                            } label: {
                                Label("添加", systemImage: "plus")
                            }
                        }
                    } else {
                        ToolbarItem(id: "Delete", placement: .primaryAction, showsByDefault: true) {
                            Button {
                                withAnimation(.easeInOut(duration: .animationTime)) {
                                    deleteAlert.toggle()
                                }
                            } label: {
                                Label("删除", systemImage: "trash")
                            }
                        }
                    }
                } else {
                    // MARK: -
                    ToolbarItem(id: "Edit", placement: .navigationBarLeading, showsByDefault: true) {
                        Button {
                            withAnimation(.easeInOut(duration: .animationTime)) {
                                isEditing.toggle()
                            }
                        } label: {
                            Label(isEditing ? "完成" : "编辑", systemImage: isEditing ? "checkmark" : "square.and.pencil")
                        }
                    }
                    if isEditing {
                        ToolbarItem(id: "Add", placement: .primaryAction, showsByDefault: true) {
                            Button {
                                isAddingCard.toggle()
                            } label: {
                                Label("添加", systemImage: "plus")
                            }
                        }
                    } else {
                        ToolbarItem(id: "Delete", placement: .primaryAction, showsByDefault: true) {
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
            }
            .toolbarRole(.editor)
            // MARK: - 警告 - iOS
            .alert(isPresented: $deleteAlert) {
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
                                var _: Diary = diaryData.diaryData.remove(at: index)
                                delete = true
                            }
                        }
                    )
                )
            }
            .sheet(isPresented: $isAddingCard) {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    DiaryDetailAddCardView($diary)
                } else {
                    DiaryDetailAddCardView($diary)
                        .presentationDetents([.fraction(0.4), .fraction(0.6), .fraction(0.8)])
                }
            }
        }
    }
}

// MARK: - DiaryDetailAddCardView - iOS
struct DiaryDetailAddCardView: View {
    @Binding var diary: Diary
    
    @Environment(\.dismiss) private var dismiss
    
    init(_ diary: Binding<Diary>) {
        self._diary = diary
    }
    
    // MARK: -
    var body: some View {
        ZStack(alignment: .topLeading) {
            // MARK: -
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .xmarkFont()
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            // MARK: -
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: .cardTemplateGridWidth), spacing: .cardGridSpacing)], spacing: .cardGridSpacing) {
                    DiaryDetailCardPreviewView($diary, "文本段落", .text(CardTemplate.text), dismiss: dismiss) {
                        TextCard(.constant(CardTemplate.text), false, diaryColumn: 1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    DiaryDetailCardPreviewView($diary, "睡眠时长", .sleep(CardTemplate.sleep), dismiss: dismiss) {
                        SleepCard(.constant(CardTemplate.sleep), false, diaryColumn: 1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .padding()
                .padding()
            }
        }
    }
}

// MARK: - DiaryDetailCardPreviewView - iOS
struct DiaryDetailCardPreviewView<Card: View>: View {
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
            .buttonStyle(.plain)
            Text(name)
                .resumeFont()
        }
    }
}
#else
// MARK: - DiaryDetailView - macOS
struct DiaryDetailView: View {
    @ObservedObject var diaryData: DiaryData
    @Binding var diary: Diary
    @Binding var selection: Int?
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isEditing: Bool = false
    @State private var isAddingCard: Bool = false
    @State private var deleteAlert: Bool = false
    @State private var isRenaming: Bool = false
    
    private var indexBinding: Binding<Int>? {
        if let index = selection {
            return Binding {
                index
            } set: { newValue in
                selection = newValue
            }
        } else {
            return nil
        }
    }

    private var displayData: [[(card: DiaryCardData, index: Int)]] {
        createDisplayData(diary)
    }
    
    init(_ diaryData: DiaryData, _ diary: Binding<Diary>, selection: Binding<Int?>) {
        self.diaryData = diaryData
        self._diary = diary
        self._selection = selection
    }
    
    // MARK: - 组件 - macOS
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
                                } set: { newValue in
                                    diary.cardData[card.index] = newValue
                                }, isEditing, diaryColumn: diary.column
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
        .focusedSceneValue(\.diaryIndex, indexBinding)
        .focusedSceneValue(\.isEditing, $isEditing)
        .navigationTitle($diary.name)
        // MARK: - 工具栏 - macOS
        .toolbar(id: "DiaryDetailToolbar") {
            ToolbarItem(id: "Rename", placement: .navigation, showsByDefault: true) {
                Button {
                    isRenaming.toggle()
                } label: {
                    Label(isRenaming ? "完成" : "重命名", systemImage: isRenaming ? "checkmark" : "pencil.line")
                }
                .popover(isPresented: $isRenaming) {
                    
                    TextField("请输入……", text: $diary.name)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                        .titleTextFieldStyle()
                        .bodyFont(level: 0)
                        .frame(width: 200)
                        .padding()
                }
            }
            ToolbarItem(id: "Edit", placement: .primaryAction, showsByDefault: true) {
                Button {
                    withAnimation(.easeInOut(duration: .animationTime)) {
                        isEditing.toggle()
                    }
                } label: {
                    Label(isEditing ? "完成" : "编辑", systemImage: isEditing ? "checkmark" : "square.and.pencil")
                }
            }
            ToolbarItem(id: "Add", placement: .primaryAction, showsByDefault: true) {
                Button {
                    isAddingCard.toggle()
                } label: {
                    Label("添加", systemImage: "plus")
                }
                .disabled(isEditing ? false : true)
            }
            ToolbarItem(id: "Delete", placement: .primaryAction, showsByDefault: true) {
                Button {
                    withAnimation(.easeInOut(duration: .animationTime)) {
                        deleteAlert.toggle()
                    }
                } label: {
                    Label("删除", systemImage: "trash")
                }
                .disabled(isEditing ? true : false)
            }
        }
        .toolbarRole(.editor)
        // MARK: - 警告 - macOS
        .alert(isPresented: $deleteAlert) {
            Alert(
                title: Text("删除日记"),
                message: Text("您确定要删除该日记吗？"),
                primaryButton: .default(
                    Text("删除"),
                    action: {
                        withAnimation(.easeInOut(duration: .animationTime)) {
                            if let index = selection {
                                var _: Diary = diaryData.diaryData.remove(at: index)
                                selection = -1
                            }
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
        }
        .sheet(isPresented: $isAddingCard) {
            DiaryDetailAddCardView($diary)
                .frame(minWidth: 600, maxWidth: 1200, minHeight: 400, maxHeight: 800)
        }
    }
}

// MARK: - AddCardView - macOS
struct DiaryDetailAddCardView: View {
    @Binding var diary: Diary
    
    @Environment(\.dismiss) private var dismiss
    
    init(_ diary: Binding<Diary>) {
        self._diary = diary
    }
    
    // MARK: -
    var body: some View {
        ZStack(alignment: .topLeading) {
            // MARK: -
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .xmarkFont()
            }
            .buttonStyle(PlainButtonStyle())
            .padding()
            // MARK: -
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: .cardTemplateGridWidth), spacing: .cardGridSpacing)], spacing: .cardGridSpacing) {
                    DiaryDetailCardPreviewView($diary, "文本段落", .text(CardTemplate.text), dismiss: dismiss) {
                        TextCard(.constant(CardTemplate.text), false, diaryColumn: 1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    DiaryDetailCardPreviewView($diary, "睡眠时长", .sleep(CardTemplate.sleep), dismiss: dismiss) {
                        SleepCard(.constant(CardTemplate.sleep), false, diaryColumn: 1)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .padding()
                .padding()
            }
        }
    }
}

// MARK: - CardPreviewView - macOS
struct DiaryDetailCardPreviewView<Card: View>: View {
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
            .buttonStyle(.plain)
            Text(name)
                .resumeFont()
        }
    }
}
#endif

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
#if os(iOS)
            DiaryDetailView(DiaryData(), $diary, index: 0)
#else
            DiaryDetailView(DiaryData(), $diary, selection: .constant(0))
#endif
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
