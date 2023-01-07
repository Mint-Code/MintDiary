import SwiftUI

// MARK: - MintDiaryApp
@main
struct MintDiaryApp: App {
    @StateObject var diaryData = DiaryData()
    
    var body: some Scene {
        WindowGroup {
            ContentView(diaryData)
                .task {
                    diaryData.load()
                }
                .onChange(of: diaryData.diaryData) { _ in
                    diaryData.save()
                }
        }
#if os(macOS)
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
