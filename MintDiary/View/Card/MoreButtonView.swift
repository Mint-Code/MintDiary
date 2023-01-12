import SwiftUI

struct MoreButtonView<Model: CardModel>: View {
    @Binding var model: Model
    var diaryColumn: Int
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var isEditingMore: Bool = false
    
    private var colorName: [Int: String] {
        if colorScheme == .light {
            return [
                0: "纯白",
                1: "淡绿",
                2: "浅绿",
                3: "中绿",
                4: "翠绿",
                5: "黛绿",
                6: "墨绿"
            ]
        } else {
            return [
                0: "纯黑",
                1: "暗红",
                2: "深红",
                3: "鲜红",
                4: "粉红",
                5: "浅粉",
                6: "淡粉"
            ]
        }
    }
    
    init(_ model: Binding<Model>, diaryColumn: Int) {
        self._model = model
        self.diaryColumn = diaryColumn
    }
    
    private var button: some View {
        Button {
            isEditingMore.toggle()
        } label: {
            Image(systemName: "pencil.line")
        }
        .toolbarButtonStyle(level: model.level)
        .padding(.trailing)
    }
    
    private var form: some View {
        Form {
            Stepper("横跨\(model.column)列") {
                withAnimation(.easeInOut(duration: .animationTime)) {
                    if model.column < diaryColumn {
                        model.column += 1
                    }
                }
            } onDecrement: {
                withAnimation(.easeInOut(duration: .animationTime)) {
                    if model.column > 1 {
                        model.column -= 1
                    }
                }
            }
            Stepper("\(colorName[model.level] ?? "")底色") {
                withAnimation(.easeInOut(duration: .animationTime)) {
                    if model.level < 6 {
                        model.level += 1
                    }
                }
            } onDecrement: {
                withAnimation(.easeInOut(duration: .animationTime)) {
                    if model.level > 0 {
                        model.level -= 1
                    }
                }
            }
        }
    }
    
    var body: some View {
#if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            button
                .popover(isPresented: $isEditingMore) {
                    form
                        .frame(width: 400, height: 200)
                }
        } else {
            button
                .sheet(isPresented: $isEditingMore) {
                    form
                        .presentationDetents([.fraction(0.4), .fraction(0.6), .fraction(0.8)])
                }
        }
#else
        button
            .popover(isPresented: $isEditingMore) {
                form
                    .formStyle(.grouped)
                    .frame(width: 400, height: 200)
            }
#endif
    }
}

struct MoreButtonView_Previews: PreviewProvider {
    struct MoreButtonViewContainer: View {
        @State var model: TextModel
        
        init(_ title: String, _ text: String, level: Int) {
            self.model = TextModel(title, text, level: level)
        }
        
        var body: some View {
            TextCard($model, true, diaryColumn: 2)
        }
    }
    
    static var previews: some View {
        MoreButtonViewContainer("Hello", "World", level: 0)
            .padding()
    }
}
