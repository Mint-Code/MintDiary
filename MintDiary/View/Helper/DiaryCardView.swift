import SwiftUI

// MARK: - DiaryCardView
struct DiaryCardView: View {
    @Binding var diaryCardData: DiaryCardData
    var isEditing: Bool
    
    init(_ diaryCardData: Binding<DiaryCardData>, _ isEditing: Bool) {
        self._diaryCardData = diaryCardData
        self.isEditing = isEditing
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
                }, isEditing
            )
        case .sleep(let model):
            // MARK: -
            SleepCard(
                Binding {
                    model
                } set: { newValue in
                    diaryCardData.card = .sleep(newValue)
                }, isEditing
            )
        }
    }
}

// MARK: - 预览
struct DiaryCardView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryCardView(
            .constant(DiaryCardData(
                .text(TextModel("新建文本", "这是一段文本。\n这是一段文本。", level: 3))
            )), false
        )
    }
}
