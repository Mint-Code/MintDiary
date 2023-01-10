//
//  TemplatePreviewView.swift
//  MintDiary
//
//  Created by 徐正 on 2023/1/10.
//

import SwiftUI

struct TemplatePreviewView: View {
    var diary: Diary
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var displayData: [[(card: DiaryCardData, index: Int)]] {
        createDisplayData(diary)
    }
    
    init(_ diary: Diary) {
        self.diary = diary
    }
    
    var body: some View {
        ScrollView(.vertical) {
            Grid(alignment: .topLeading) {
                ForEach(displayData, id: \.self.first?.index) { column in
                    GridRow {
                        ForEach(column, id: \.self.index) { card in
                            CardView(
                                Binding(get: {
                                    card.card
                                }, set: { newValue in }), false, diaryColumn: 2
                            )
                        }
                    }
                }
                GridRow {
                    Color.clear
                        .frame(height: 0)
                        .gridCellColumns(diary.column)
                }
            }
            .padding()
        }
        .padding()
        .padding()
        .background(colorScheme == .light ? Color.brightBackground : Color.secondaryBackground)
        .cornerRadius(.diaryTemplateCornerRadius * 4)
        .shadow(radius: .diaryTemplateShadowRadius * 4, x: .diaryTemplateShadowX * 4, y: .diaryTemplateShadowY * 4)
        .frame(width: .diaryTemplateWidth * 4, height: .diaryTemplateHeight * 4)
        .padding(.bottom)
        .padding(.bottom)
        .scaleEffect(0.25)
        .frame(width: .diaryTemplateWidth, height: .diaryTemplateGridHeight)
        .redacted(reason: .placeholder)
    }
}

struct TemplatePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        TemplatePreviewView(DiaryTemplate.text)
    }
}
