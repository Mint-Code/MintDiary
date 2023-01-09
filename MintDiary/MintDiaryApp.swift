import SwiftUI

// MARK: - MintDiaryApp
@main
struct MintDiaryApp: App {
    @StateObject var diaryData = DiaryData()
    
    var body: some Scene {
        // MARK: - 主窗口
        WindowGroup {
            ContentView(diaryData)
                .task {
                    diaryData.load()
                }
                .onChange(of: diaryData.diaryData) { _ in
                    diaryData.save()
                }
        }
        .commands {
            DiaryCommand(diaryData)
        }
#if os(macOS)
        // MARK: - 状态栏
        MenuBarExtra {
            NavigationStack {
                MenuBarDiaryListView(diaryData)
            }
            .frame(width: 500, height: 300)
        } label: {
            Label("薄荷日记", systemImage: "book.fill")
        }
        .menuBarExtraStyle(.window)
#endif
    }
}
