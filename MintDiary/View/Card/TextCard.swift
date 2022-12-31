import SwiftUI

// MARK: - TextCard
struct TextCard: View {
    @Binding var model: TextModel
    var isEditing: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var textHeight: CGFloat = 0
    @State private var buttonWidth: CGFloat = 0
    @State private var textCenter: Bool
    
    init(_ model: Binding<TextModel>, _ isEditing: Bool) {
        self._model = model
        self.isEditing = isEditing
        self._textCenter = State(initialValue: model.textCenter.wrappedValue)
    }
    
    // MARK: - 组件
    var body: some View {
        VStack {
            if isEditing {
                // MARK: -
                ZStack(alignment: .topTrailing) {
                    //TextEditor(text: $model.title)
                    TextField("", text: $model.title)
                        .textFieldStyle(PlainTextFieldStyle())
                        .headlineFont(level: model.level)
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .padding(.horizontal, buttonWidth)
                    Button {
                        withAnimation(.easeInOut(duration: .animationTime)) {
                            textCenter.toggle()
                        }
                        model.textCenter.toggle()
                    } label: {
                        Image(systemName: model.textCenter ? "text.alignleft" : "text.aligncenter")
                            .font(.headline)
                            .foregroundColor(.textColor(model.level))
                    }
                    .padding(.horizontal)
                    .buttonStyle(PlainButtonStyle())
                    .readSize { size in
                        buttonWidth = size.width
                    }
                }
            } else {
                // MARK: -
                Text(model.title)
                    .headlineFont(level: model.level)
                    .padding(.horizontal)
                    .padding(.horizontal)
            }
            if isEditing {
                if textCenter {
                    // MARK: -
                    TextEditor(text: $model.text)
                        .scrollContentBackground(.hidden)
                        .bodyFont(.center, .center, level: model.level)
                        .padding(.horizontal)
                        .padding(.horizontal)
                } else {
                    // MARK: -
                    TextEditor(text: $model.text)
                        .scrollContentBackground(.hidden)
                        .bodyFont(level: model.level)
                        .padding(.horizontal)
                        .padding(.horizontal)
                }
            } else {
                if textCenter {
                    // MARK: -
                    Text(model.text)
                        .bodyFont(.center, .center, level: model.level)
                        .padding(.horizontal)
                } else {
                    // MARK: -
                    HStack {
                        Rectangle()
                            .fill(Color.opacityColor(model.level))
                            .frame(width: .textRectangleWidth, height: textHeight)
                            .cornerRadius(.textRectangleCornerRadius)
                        Text(model.text)
                            .bodyFont(level: model.level)
                            .readSize { size in
                                textHeight = size.height
                            }
                    }
                    .padding(.horizontal)
                    .padding(.horizontal)
                }
            }
        }
        .cardEffect(model.level, model.column, colorScheme: colorScheme)
    }
}

// MARK: - 预览
struct TextCard_Previews: PreviewProvider {
    static var title: String = "TextCard测试"
    static var text1: String = """
这是一段文字。
这是另一段文字。
这里还有一段文字。
这里是最后一段文字。
没有文字了。
"""
    static var text2: String = """
这是一段文字。这是另一段文字。
这里是最后一段文字。
"""
    
    // MARK: - 容器
    struct TextCardContainer: View {
        @State var model: TextModel
        
        init(_ title: String, _ text: String, level: Int) {
            self.model = TextModel(title, text, level: level)
        }
        
        var body: some View {
            TextCard($model, true)
        }
    }
    
    static var previews: some View {
        Grid(alignment: .topLeading) {
            GridRow {
                TextCardContainer(title, text1, level: 0)
                TextCardContainer(title, text2, level: 0)
            }
            GridRow {
                TextCardContainer(title, text1, level: 1)
                TextCardContainer(title, text2, level: 2)
            }
            GridRow {
                TextCardContainer(title, text1, level: 3)
                TextCardContainer(title, text2, level: 4)
            }
            GridRow {
                TextCardContainer(title, text1, level: 5)
                TextCardContainer(title, text2, level: 6)
                    .preferredColorScheme(.light)
                    //.preferredColorScheme(.dark)
            }
        }
        .frame(width: 600, height: 700)
        .padding()
        .background(Color.secondaryBackground)
    }
}