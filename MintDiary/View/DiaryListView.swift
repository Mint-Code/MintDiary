import SwiftUI

#if os(iOS)
// MARK: - DiaryListView - iOS
struct DiaryListView: View {
    @ObservedObject var diaryData: DiaryData
    
    @State var isOnStartView: Bool = false
    
    init(_ diaryData: DiaryData) {
        self.diaryData = diaryData
    }
    
    // MARK: - 组件 - iOS
    var body: some View {
        List {
            ForEach(0..<diaryData.diaryData.count, id: \.self) { index in
                if let diary = $diaryData.diaryData[index] {
                    NavigationLink {
                        DiaryDetailView(diaryData, diary, index: index)
                    } label: {
                        Label(diary.name.wrappedValue, systemImage: diary.icon.wrappedValue)
                    }
                }
            }
        }
        .navigationTitle("薄荷日记")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isOnStartView.toggle()
                } label: {
                    Label("新建", systemImage: "plus")
                }
            }
        }
        .fullScreenCover(isPresented: $isOnStartView) {
            NavigationStack {
                StartView(diaryData)
            }
        }
    }
}
#else
// MARK: - DiaryListView - macOS
struct DiaryListView: View {
    @ObservedObject var diaryData: DiaryData
    
    @State var selection: Int? = -1
    
    init(_ diaryData: DiaryData) {
        self.diaryData = diaryData
    }
    
    // MARK: - 组件 - macOS
    var body: some View {
        List(selection: $selection) {
            ForEach(-1..<0, id: \.self) { index in
                NavigationLink {
                    StartView(diaryData, selection: $selection)
                } label: {
                    Label("开始", systemImage: "doc.badge.plus")
                }
            }
            Section("日记") {
                ForEach(0..<diaryData.diaryData.count, id: \.self) { index in
                    if let diary = $diaryData.diaryData[index] {
                        NavigationLink {
                            DiaryDetailView(diaryData, diary, selection: $selection)
                        } label: {
                            Label(diary.name.wrappedValue, systemImage: diary.icon.wrappedValue)
                        }
                    }
                }
            }
        }
        .navigationTitle("薄荷日记")
        .onChange(of: selection) { _ in
            if selection == nil {
                selection = -1
            }
        }
    }
}
#endif

// MARK: - 预览
struct DiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSplitView {
            DiaryListView(DiaryData())
        } detail: {}
    }
}
