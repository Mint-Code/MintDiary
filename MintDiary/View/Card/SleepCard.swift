import SwiftUI

// MARK: - SleepCard
struct SleepCard: View {
    @Binding var model: SleepModel
    var isEditing: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(_ model: Binding<SleepModel>, _ isEditing: Bool) {
        self._model = model
        self.isEditing = isEditing
    }
    
    // MARK: - IconView
    struct IconView: View {
        var level: Int
        
        init(level: Int) {
            self.level = level
        }
        
        var body: some View {
            Image(systemName: "moon.zzz.fill")
                .font(.title)
                .foregroundColor(.textColor(level))
        }
    }
    
    // MARK: - TextView
    struct TextView: View {
        var sleep: Int
        var level: Int
        
        init(_ sleep: Int, level: Int) {
            self.sleep = sleep
            self.level = level
        }
        
        var body: some View {
            Text("\(sleep)小时")
                .font(.body)
                .foregroundColor(.textColor(level))
                .lineLimit(1)
        }
    }
    
    // MARK: - ProgressView
    struct ProgressView: View {
        var sleep: Int
        var level: Int
        
        init(_ sleep: Int, level: Int) {
            self.sleep = sleep
            self.level = level
        }
        
        var body: some View {
            HStack(spacing: 0) {
                ForEach(1...12, id: \.self) { index in
                    if index > sleep {
                        Rectangle()
                            .fill(Color.opacityColor(level))
                            .frame(height: .progressHeight)
                    } else {
                        ZStack(alignment: .top) {
                            Rectangle()
                                .fill(Color.opacityColor(level))
                                .frame(height: .progressHeight)
                            Rectangle()
                                .fill(Color.opacityColor(level))
                                .frame(height: .progressHeight)
                            Rectangle()
                                .fill(Color.secondaryColor(level))
                                .frame(height: .progressHeight)
                        }
                    }
                }
            }
            .cornerRadius(.cardCornerRadius)
            .frame(minWidth: 100)
        }
    }
    
    // MARK: - 组件
    var body: some View {
        VStack {
            Text("睡眠时长")
                .headlineFont(level: model.level)
                .padding(.horizontal)
            if isEditing {
                // MARK: -
                Stepper {
                    Text("\(model.sleep)小时")
                        .font(.body)
                        .foregroundColor(.textColor(model.level))
                } onIncrement: {
                    model.sleep += 1
                } onDecrement: {
                    model.sleep -= 1
                }
            } else {
                ViewThatFits {
                    // MARK: -
                    HStack {
                        IconView(level: model.level)
                        TextView(model.sleep, level: model.level)
                        ProgressView(model.sleep, level: model.level)
                    }
                    // MARK: -
                    HStack {
                        IconView(level: model.level)
                        ProgressView(model.sleep, level: model.level)
                    }
                    // MARK: -
                    HStack {
                        IconView(level: model.level)
                        TextView(model.sleep, level: model.level)
                    }
                    // MARK: -
                    TextView(model.sleep, level: model.level)
                }
                .padding(.horizontal)
                .padding(.horizontal)
            }
        }
        .cardEffect(model.level, model.column, colorScheme: colorScheme)
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
            SleepCard($model, false)
        }
    }
    
    static var previews: some View {
        Grid(alignment: .topLeading) {
            GridRow {
                SleepCardContainer(2, level: 0)
                    .frame(width: 250)
                SleepCardContainer(4, level: 0)
                    .frame(width: 150)
            }
            GridRow {
                SleepCardContainer(6, level: 1)
                    .frame(width: 250)
                SleepCardContainer(7, level: 2)
                    .frame(width: 150)
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
