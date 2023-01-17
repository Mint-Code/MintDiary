import SwiftUI

// MARK: - CardView
struct CardView: View {
    @Binding var diaryCardData: DiaryCardData
    var diaryColumn: Int
    var isEditing: Bool
    
    init(_ diaryCardData: Binding<DiaryCardData>, _ isEditing: Bool, diaryColumn: Int) {
        self._diaryCardData = diaryCardData
        self.isEditing = isEditing
        self.diaryColumn = diaryColumn
    }
    
    // MARK: - 组件
    var body: some View {
        switch diaryCardData.card {
        case .text(let model):
            // MARK: -
            TextCard(
                Binding {
                    model
                } set: { newValue in
                    diaryCardData.card = .text(newValue)
                }, isEditing, diaryColumn: diaryColumn
            )
        case .sleep(let model):
            // MARK: -
            SleepCard(
                Binding {
                    model
                } set: { newValue in
                    diaryCardData.card = .sleep(newValue)
                }, isEditing, diaryColumn: diaryColumn
            )
        case .title(let model):
            // MARK: -
            TitleCard(
                Binding {
                    model
                } set: { newValue in
                    diaryCardData.card = .title(newValue)
                }, isEditing, diaryColumn: diaryColumn
            )
        }
    }
}

// MARK: - 预览
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            .constant(DiaryCardData(
                .text(TextModel("新建文本", "这是一段文本。\n这是一段文本。", level: 3))
            )), false, diaryColumn: 1
        )
    }
}
