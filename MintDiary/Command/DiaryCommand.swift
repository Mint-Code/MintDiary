import SwiftUI

// MARK: - diaryIndex
extension FocusedValues {
    private struct FocusedDiaryIndexKey: FocusedValueKey {
        typealias Value = Binding<Int>
    }
    
    var diaryIndex: Binding<Int>? {
        get {
            self[FocusedDiaryIndexKey.self]
        }
        set {
            self[FocusedDiaryIndexKey.self] = newValue
        }
    }
}

// MARK: - isEditing
extension FocusedValues {
    private struct FocusedIsEditingKey: FocusedValueKey {
        typealias Value = Binding<Bool>
    }
    
    var isEditing: Binding<Bool>? {
        get {
            self[FocusedIsEditingKey.self]
        }
        set {
            self[FocusedIsEditingKey.self] = newValue
        }
    }
}

// MARK: DiaryCommand
struct DiaryCommand: Commands {
    @ObservedObject var diaryData: DiaryData
    
    @FocusedBinding(\.diaryIndex) private var diaryIndex: Int?
    @FocusedBinding(\.isEditing) private var isEditing: Bool?
    
    init(_ diaryData: DiaryData) {
        self.diaryData = diaryData
    }
    
    var body: some Commands {
        CommandMenu("日记") {
            Button {
                withAnimation(.easeInOut(duration: .animationTime)) {
                    if let index = diaryIndex {
                        diaryData.diaryData.remove(at: index)
                        diaryIndex = -1
                    }
                }
            } label: {
                Text("删除日记")
            }
            .keyboardShortcut("D", modifiers: [.command])
            .disabled(diaryIndex == nil || diaryIndex == -1)
            Button {
                withAnimation(.easeInOut(duration: .animationTime)) {
                    isEditing?.toggle()
                }
            } label: {
                Text((isEditing ?? false) ? "完成" : "编辑日记")
            }
            .keyboardShortcut("E", modifiers: [.command])
            .disabled(diaryIndex == nil || diaryIndex == -1)
        }
    }
}
