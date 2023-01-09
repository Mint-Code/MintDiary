import SwiftUI

// MARK: - StartView
struct StartView: View {
    @ObservedObject var diaryData: DiaryData
    @Binding var selection: Int?

#if os(iOS)
    @Environment(\.dismiss) private var dismiss
#endif
    
    init(_ diaryData: DiaryData, selection: Binding<Int?>) {
        self.diaryData = diaryData
        self._selection = selection
    }
    
    // MARK: - TemplateView
    struct TemplateView: View {
        @ObservedObject var diaryData: DiaryData
        @Binding var selection: Int?
        var name: String
        var diary: Diary
#if os(iOS)
        var dismiss: DismissAction
#endif
        
        @Environment(\.colorScheme) private var colorScheme
        
#if os(iOS)
        init(_ name: String, _ diary: Diary, diaryData: DiaryData, dismiss: DismissAction, selection: Binding<Int?>) {
            self.name = name
            self.diary = diary
            self.diaryData = diaryData
            self.dismiss = dismiss
            self._selection = selection
        }
#else
        init(_ name: String, _ diary: Diary, diaryData: DiaryData, selection: Binding<Int?>) {
            self.name = name
            self.diary = diary
            self.diaryData = diaryData
            self._selection = selection
        }
#endif
        
        // MARK: - 组件
        var body: some View {
            VStack {
                Button {
                    diaryData.diaryData.insert(diary, at: 0)
                    selection = 0
#if os(iOS)
                    dismiss()
#endif
                } label: {
                    TemplatePreviewView(diary)
                }
                .buttonStyle(PlainButtonStyle())
                .redacted(reason: .placeholder)
                Text(name)
                    .resumeFont()
            }
        }
    }
    
    struct TemplatePreviewView: View {
        var diary: Diary
        
        @Environment(\.colorScheme) private var colorScheme
        
        private var displayData: [[(card: DiaryCardData, index: Int)]] {
            createDisplayData(diary)
        }
        
        init(_ diary: Diary) {
            self.diary = diary
        }
        
        var body: some View {
            ScrollView(.vertical) {
                Grid(alignment: .topLeading) {
                    ForEach(displayData, id: \.self.first?.index) { column in
                        GridRow {
                            ForEach(column, id: \.self.index) { card in
                                CardView(
                                    Binding(get: {
                                        card.card
                                    }, set: { newValue in }), false, diaryColumn: 2
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
            .padding()
            .padding()
            .background(colorScheme == .light ? Color.brightBackground : Color.secondaryBackground)
            .cornerRadius(.diaryTemplateCornerRadius * 4)
            .shadow(radius: .diaryTemplateShadowRadius * 4, x: .diaryTemplateShadowX * 4, y: .diaryTemplateShadowY * 4)
            .frame(width: .diaryTemplateWidth * 4, height: .diaryTemplateHeight * 4)
            .padding(.bottom)
            .padding(.bottom)
            .scaleEffect(0.25)
            .frame(width: .diaryTemplateWidth, height: .diaryTemplateGridHeight)
        }
    }
    
    var body: some View {
        List {
            Section("基本") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: .diaryTemplateGridWidth))]) {
#if os(iOS)
                    // MARK: -
                    TemplateView("空白日记", DiaryTemplate.empty, diaryData: diaryData, dismiss: dismiss)
                    // MARK: -
                    TemplateView("文本日记", DiaryTemplate.text, diaryData: diaryData, dismiss: dismiss)
#else
                    // MARK: -
                    TemplateView("空白日记", DiaryTemplate.empty, diaryData: diaryData, selection: $selection)
                    // MARK: -
                    TemplateView("文本日记", DiaryTemplate.text, diaryData: diaryData, selection: $selection)
#endif
                }
                .padding()
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.brightBackground)
#if os(iOS)
        .navigationTitle("新建日记")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Label("取消", systemImage: "xmark")
                }
            }
        }
#else
        .navigationTitle("开始")
#endif
    }
}

// MARK: - 预览
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(DiaryData(), selection: .constant(-1))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
