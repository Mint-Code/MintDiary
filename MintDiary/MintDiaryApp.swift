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
    }
}
