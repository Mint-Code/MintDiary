import SwiftUI

#if os(iOS)
// MARK: - StartView - iOS
struct StartView: View {
    @ObservedObject var diaryData: DiaryData

    @Environment(\.dismiss) private var dismiss
    
    init(_ diaryData: DiaryData) {
        self.diaryData = diaryData
    }
    
    // MARK: - 组件 - iOS
    var body: some View {
        List {
            // MARK: -
            Section("基本") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: .diaryTemplateGridWidth))]) {
                    StartTemplateView("空白日记", DiaryTemplate.empty, diaryData: diaryData, dismiss: dismiss)
                    StartTemplateView("文本日记", DiaryTemplate.text, diaryData: diaryData, dismiss: dismiss)
                    StartTemplateView("基本日记", DiaryTemplate.simpleDiary, diaryData: diaryData, dismiss: dismiss)
                }
                .padding()
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.brightBackground)
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
    }
}

// MARK: - StartTemplateView - iOS
struct StartTemplateView: View {
    @ObservedObject var diaryData: DiaryData
    var name: String
    var diary: Diary
    var dismiss: DismissAction
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(_ name: String, _ diary: Diary, diaryData: DiaryData, dismiss: DismissAction) {
        self.name = name
        self.diary = diary
        self.diaryData = diaryData
        self.dismiss = dismiss
    }
    
    // MARK: -
    var body: some View {
        VStack {
            Button {
                diaryData.diaryData.insert(diary, at: 0)
                dismiss()
            } label: {
                TemplatePreviewView(diary)
            }
            .buttonStyle(PlainButtonStyle())
            Text(name)
                .resumeFont()
        }
    }
}
#else
// MARK: - StartView - macOS
struct StartView: View {
    @ObservedObject var diaryData: DiaryData
    @Binding var selection: Int?
    
    init(_ diaryData: DiaryData, selection: Binding<Int?>) {
        self.diaryData = diaryData
        self._selection = selection
    }
    
    // MARK: - 组件 - macOS
    var body: some View {
        List {
            // MARK: -
            Section("基本") {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: .diaryTemplateGridWidth))]) {
                    StartTemplateView("空白日记", DiaryTemplate.empty, diaryData: diaryData, selection: $selection)
                    StartTemplateView("文本日记", DiaryTemplate.text, diaryData: diaryData, selection: $selection)
                    StartTemplateView("基本日记", DiaryTemplate.simpleDiary, diaryData: diaryData, selection: $selection)
                }
                .padding()
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.brightBackground)
        .navigationTitle("开始")
    }
}

// MARK: - StartTemplateView - macOS
struct StartTemplateView: View {
    @ObservedObject var diaryData: DiaryData
    @Binding var selection: Int?
    var name: String
    var diary: Diary
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(_ name: String, _ diary: Diary, diaryData: DiaryData, selection: Binding<Int?>) {
        self.name = name
        self.diary = diary
        self.diaryData = diaryData
        self._selection = selection
    }

    var body: some View {
        VStack {
            Button {
                diaryData.diaryData.insert(diary, at: 0)
                selection = 0
            } label: {
                DiaryPreviewView(diary)
            }
            .buttonStyle(PlainButtonStyle())
            .redacted(reason: .placeholder)
            Text(name)
                .resumeFont()
        }
    }
}
#endif

// MARK: - 预览
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
#if os(iOS)
        StartView(DiaryData())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
#else
        StartView(DiaryData(), selection: .constant(-1))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
#endif
    }
}
