import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    @ObservedObject var diaryData: DiaryData
    
    init(_ diaryData: DiaryData) {
        self.diaryData = diaryData
    }
    
    // MARK: - 组件
    var body: some View {
        NavigationSplitView {
            DiaryListView(diaryData)
        } detail: {
#if os(macOS)
            StartView(diaryData)
#endif
        }
    }
}

// MARK: - 预览
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(DiaryData())
    }
}
