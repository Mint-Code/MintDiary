import SwiftUI

// MARK: - SleepCard
struct SleepCard: View {
    @Binding var model: SleepModel
    var diaryColumn: Int
    var isEditing: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var buttonWidth: CGFloat = 0
    
    init(_ model: Binding<SleepModel>, _ isEditing: Bool, diaryColumn: Int) {
        self._model = model
        self.isEditing = isEditing
        self.diaryColumn = diaryColumn
    }
    
    // MARK: - 图标
    @ViewBuilder private var icon: some View {
        Image(systemName: "moon.zzz.fill")
            .font(.title)
            .foregroundColor(.textColor(model.level))
    }
    
    // MARK: - 文字
    @ViewBuilder private var text: some View {
        Text("\(model.sleep)小时")
            .font(.body)
            .foregroundColor(.textColor(model.level))
            .lineLimit(1)
    }
    
    // MARK: - 进度条
    @ViewBuilder private var progress: some View {
        HStack(spacing: 0) {
            ForEach(1...12, id: \.self) { index in
                if index > model.sleep {
                    Rectangle()
                        .fill(Color.opacityColor(model.level))
                        .frame(height: .progressHeight)
                } else {
                    ZStack(alignment: .top) {
                        Rectangle()
                            .fill(Color.tertiaryColor(model.level))
                            .frame(height: .progressHeight)
                        Rectangle()
                            .fill(Color.secondaryColor(model.level))
                            .frame(height: .progressHeight)
                    }
                }
            }
        }
        .cornerRadius(.cardCornerRadius)
        .frame(minWidth: 100)
    }
    
    // MARK: - 组件
    var body: some View {
        VStack {
            if isEditing {
                ViewThatFits {
                    HStack {
                        Color.clear
                            .frame(width: buttonWidth, height: 0)
                        Text("睡眠时长")
                            .headlineFont(level: model.level)
                        MoreButtonView($model, diaryColumn: diaryColumn)
                            .readSize { size in
                                buttonWidth = size.width
                            }
                    }
                }
            } else {
                Text("睡眠时长")
                    .headlineFont(level: model.level)
                    .padding(.horizontal)
                    .padding(.horizontal)
            }
            if isEditing {
                // MARK: -
#if os(iOS)
                HStack {
                    ViewThatFits {
                        Text("\(model.sleep)小时")
                            .font(.body)
                            .lineLimit(1)
                            .foregroundColor(.textColor(model.level))
                        Text("\(model.sleep)")
                            .font(.body)
                            .lineLimit(1)
                            .foregroundColor(.textColor(model.level))
                    }
                    Stepper("") {
                        if model.sleep < 12 {
                            model.sleep += 1
                        }
                    } onDecrement: {
                        if model.sleep > 0 {
                            model.sleep -= 1
                        }
                    }
                    .labelsHidden()
                }
                .padding(.horizontal)
#else
                Stepper {
                    Text("\(model.sleep)小时")
                        .font(.body)
                        .foregroundColor(.textColor(model.level))
                } onIncrement: {
                    model.sleep += 1
                } onDecrement: {
                    model.sleep -= 1
                }
                .padding(.horizontal)
                .padding(.horizontal)
#endif
            } else {
                ViewThatFits {
                    // MARK: -
                    HStack {
                        icon
                        text
                        progress
                    }
                    // MARK: -
                    HStack {
                        icon
                        progress
                    }
                    // MARK: -
                    HStack {
                        icon
                        text
                    }
                    // MARK: -
                    text
                }
                .padding(.horizontal)
                .padding(.horizontal)
            }
        }
        .cardStyle(model.level, model.column, colorScheme: colorScheme)
    }
}

// MARK: - 预览
struct SleepCard_Previews: PreviewProvider {
    // MARK: - 容器
    struct SleepCardContainer: View { 
        @State var model: SleepModel
        
        init(_ sleep: Int, level: Int) {
            self.model = SleepModel(sleep, level: level)
        }
        
        var body: some View {
            SleepCard($model, false, diaryColumn: 2)
        }
    }
    
    static var previews: some View {
        Grid(alignment: .topLeading, horizontalSpacing: .cardGridSpacing, verticalSpacing: .cardGridSpacing) {
            GridRow {
                SleepCardContainer(2, level: 0)
                    .frame(width: 250)
                SleepCardContainer(4, level: 0)
                    .frame(width: 120)
            }
            GridRow {
                SleepCardContainer(6, level: 1)
                    .frame(width: 250)
                SleepCardContainer(7, level: 2)
                    .frame(width: 120)
            }
            GridRow {
                SleepCardContainer(8, level: 3)
                    .frame(width: 300)
                SleepCardContainer(9, level: 4)
                    .frame(width: 200)
            }
            GridRow {
                SleepCardContainer(10, level: 5)
                    .frame(width: 300)
                SleepCardContainer(12, level: 6)
                    .frame(width: 200)
                    .preferredColorScheme(.light)
                    //.preferredColorScheme(.dark)
            }
        }
        .frame(width: 600, height: 500)
        .padding()
        .background(Color.secondaryBackground)
    }
}
