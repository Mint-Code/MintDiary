import SwiftUI

#if os(macOS)
// MARK: - MenuBarDiaryListView
struct MenuBarDiaryListView: View {
    @ObservedObject var diaryData: DiaryData
    
    init(_ diaryData: DiaryData) {
        self.diaryData = diaryData
    }
    
    // MARK: - 组件
    var body: some View {
        List {
            ForEach(0..<diaryData.diaryData.count, id: \.self) { index in
                if let diary = diaryData.diaryData[index] {
                    NavigationLink {
                        MenuBarDiaryDetailView(diary)
                    } label: {
                        Label(diary.name, systemImage: diary.icon)
                    }
                }
            }
        }
        .navigationTitle("日记")
    }
}

// MARK: - 预览
struct MenuBarDiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitView {
            MenuBarDiaryListView(DiaryData())
        } detail: {}
    }
}
#endif
