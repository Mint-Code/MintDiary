import SwiftUI

// MARK: - StartView
struct StartView: View {
    @ObservedObject var diaryData: DiaryData
    
#if os(iOS)
    @Environment(\.dismiss) private var dismiss
#endif
    
    init(_ diaryData: DiaryData) {
        self.diaryData = diaryData
    }
    
    // MARK: - DocumentView
    struct DocumentView: View {
        @ObservedObject var diaryData: DiaryData
        var name: String
        var diary: Diary
#if os(iOS)
        var dismiss: DismissAction
#endif
        
        @Environment(\.colorScheme) private var colorScheme
        
#if os(iOS)
        init(_ name: String, _ diary: Diary, diaryData: DiaryData, dismiss: DismissAction) {
            self.name = name
            self.diary = diary
            self.diaryData = diaryData
            self.dismiss = dismiss
        }
#else
        init(_ name: String, _ diary: Diary, diaryData: DiaryData) {
            self.name = name
            self.diary = diary
            self.diaryData = diaryData
        }
#endif
        
        // MARK: - 组件
        var body: some View {
            VStack {
                Button {
                    diaryData.diaryData.insert(diary, at: 0)
#if os(iOS)
                    dismiss()
#endif
                } label: {
                    DiaryDetailView(diaryData, .constant(diary), 0, isScaling: true)
                        .padding()
                        .padding()
                        .background(Color.secondaryBackground)
                        .cornerRadius(.startDocumentCornerRadius * 4)
                        .shadow(radius: .startDocumentShadowRadius * 4, x: .startDocumentShadowX * 4, y: .startDocumentShadowY * 4)
                        .frame(width: .startDocumentWidth * 4, height: .startDocumentHeight * 4)
                        .scaleEffect(0.25)
                        .frame(width: .startDocumentWidth, height: .startDocumentHeight)
                }
                .buttonStyle(PlainButtonStyle())
                Text(name)
                    .resumeFont(level: 0)
            }
        }
    }
    
    var body: some View {
        List {
            Section("基本") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: .startDocumentGridWidth))]) {
#if os(iOS)
                    // MARK: -
                    DocumentView(
                        "空白日记",
                        Diary("新建空白日记", [], icon: "book", column: 2),
                        diaryData: diaryData,
                        dismiss: dismiss
                    )
                    // MARK: -
                    DocumentView(
                        "文本日记",
                        Diary(
                            "新建文本日记",
                            [DiaryCardData(.text(TextModel("段落", "这是一段文字。\n这是一段文字。", level: 0)))],
                            icon: "doc",
                            column: 1
                        ),
                        diaryData: diaryData,
                        dismiss: dismiss
                    )
#else
                    // MARK: -
                    DocumentView(
                        "空白日记",
                        Diary("新建空白日记", [], icon: "book", column: 2),
                        diaryData: diaryData
                    )
                    // MARK: -
                    DocumentView(
                        "文本日记",
                        Diary(
                            "新建文本日记",
                            [DiaryCardData(.text(TextModel("段落", "这是一段文字。\n这是一段文字。", level: 0)))],
                            icon: "doc",
                            column: 1
                        ),
                        diaryData: diaryData
                    )
#endif
                }
                .padding()
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.brightBackground)
#if os(iOS)
        .navigationTitle("新建日记")
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
        StartView(DiaryData())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
