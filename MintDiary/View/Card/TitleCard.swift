import SwiftUI

// MARK: TitleCard
struct TitleCard: View {
    @Binding var model: TitleModel
    var diaryColumn: Int
    var isEditing: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var buttonWidth: CGFloat = 0
    
    private var font: Font {
        var font: Font
        switch(model.font) {
        case .system:
            font = .system(.largeTitle)
        case .newYork:
            font = .system(.largeTitle, design: .serif)
        }
        switch(model.weight) {
        case .light:
            font = font.weight(.ultraLight)
        case .medium:
            font = font.weight(.regular)
        case .bold:
            font = font.weight(.bold)
        }
        return font
    }
    
    private var smallFont: Font {
        var font: Font
        switch(model.font) {
        case .system:
            font = .system(.body)
        case .newYork:
            font = .system(.body, design: .serif)
        }
        switch(model.weight) {
        case .light:
            font = font.weight(.light)
        case .medium:
            font = font.weight(.regular)
        case .bold:
            font = font.weight(.bold)
        }
        return font
    }
    
    init(_ model: Binding<TitleModel>, _ isEditing: Bool, diaryColumn: Int) {
        self._model = model
        self.diaryColumn = diaryColumn
        self.isEditing = isEditing
    }
    
    // MARK: - 字体选择器
    @ViewBuilder private var fontSelector: some View {
        Button {
            withAnimation(.easeInOut(duration: .animationTime)) {
                model.font = .system
            }
        } label: {
            Text("字体")
                .font(.system(.headline, design: .default).weight(.light))
        }
        .toolbarButtonStyle(level: model.level, isSelected: model.font == .system)
        Button {
            withAnimation(.easeInOut(duration: .animationTime)) {
                model.font = .newYork
            }
        } label: {
            Text("字体")
                .font(.system(.headline, design: .serif))
        }
        .toolbarButtonStyle(level: model.level, isSelected: model.font == .newYork)
    }
    
    // MARK: - 字体粗细选择器
    @ViewBuilder private var fontWeightSelector: some View {
        Button {
            withAnimation(.easeInOut(duration: .animationTime)) {
                model.weight = .light
            }
        } label: {
            Text("细")
                .font(smallFont.weight(.light))
        }
        .toolbarButtonStyle(level: model.level, isSelected: model.weight == .light)
        Button {
            withAnimation(.easeInOut(duration: .animationTime)) {
                model.weight = .medium
            }
        } label: {
            Text("中")
                .font(smallFont.weight(.medium))
        }
        .toolbarButtonStyle(level: model.level, isSelected: model.weight == .medium)
        Button {
            withAnimation(.easeInOut(duration: .animationTime)) {
                model.weight = .bold
            }
        } label: {
            Text("粗")
                .font(smallFont.weight(.bold))
        }
        .toolbarButtonStyle(level: model.level, isSelected: model.weight == .bold)
    }
    
    // MARK: - 组件
    var body: some View {
        VStack {
            if isEditing {
                // MARK: -
                VStack {
                    HStack {
                        Color.clear
                            .frame(width: buttonWidth, height: 0)
                        TextField("请输入……", text: $model.title)
                            .foregroundColor(.textColor(model.level))
                            .font(smallFont)
                            .titleTextFieldStyle(level: model.level)
                        MoreButtonView($model, diaryColumn: diaryColumn)
                            .readSize { size in
                                buttonWidth = size.width
                            }
                    }
                    ViewThatFits {
                        // MARK: -
                        HStack {
                            fontSelector
                            Spacer()
                            Rectangle()
                                .fill(Color.opacityColor(model.level))
                                .frame(width: 1.5)
                            Spacer()
                            fontWeightSelector
                        }
                        // MARK: -
                        VStack {
                            HStack {
                                fontSelector
                                Spacer(minLength: 0)
                            }
                            Rectangle()
                                .fill(Color.opacityColor(model.level))
                                .frame(height: 1.5)
                            HStack {
                                fontWeightSelector
                                Spacer(minLength: 0)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.horizontal)
                }
            } else {
                // MARK: -
                Text(model.title)
                    .titleFont(font, level: model.level)
            }
        }
        .cardStyle(model.level, model.column, colorScheme: colorScheme)
    }
}

// MARK:  预览
struct TitleCard_Previews: PreviewProvider {
    // MARK: - 容器
    struct TitleCardContainer: View {
        @State var model: TitleModel
        
        init(_ title: String, _ font: TitleFontType = .system, _ weight: TitleFontWeight = .light, level: Int) {
            self.model = TitleModel(title, font, weight, level: level)
        }
        
        var body: some View {
            TitleCard($model, true, diaryColumn: 2)
        }
    }
    
    static var previews: some View {
        ScrollView(.vertical) {
            Grid(alignment: .topLeading, horizontalSpacing: .cardGridSpacing, verticalSpacing: .cardGridSpacing) {
                GridRow {
                    TitleCardContainer("日记标题 Title", level: 0)
                    TitleCardContainer("日记标题 Title", .newYork, level: 0)
                }
                GridRow {
                    TitleCardContainer("日记标题 Title", level: 1)
                    TitleCardContainer("日记标题 Title", .newYork, level: 2)
                }
                GridRow {
                    TitleCardContainer("日记标题 Title", level: 3)
                    TitleCardContainer("日记标题 Title", .newYork, level: 4)
                }
                GridRow {
                    TitleCardContainer("日记标题 Title", level: 5)
                    TitleCardContainer("日记标题 Title", .newYork, level: 6)
                        .preferredColorScheme(.light)
                        //.preferredColorScheme(.dark)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.secondaryBackground)
    }
}
