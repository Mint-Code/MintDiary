import Foundation

// MARK: - 创建用于展示的数据
func createDisplayData(_ diary: Diary) -> [[(card: DiaryCardData, index: Int)]] {
    var data: [[(card: DiaryCardData, index: Int)]] = [] // 显示的日记行及内容信息
    var columnIndex: Int = 0 // 每个日记行的索引
    var cardIndex: Int = 0 // 每个日记卡片的索引
    while cardIndex < diary.cardData.count {
        data.append([]) // 新建日记行
        var rowColumn: Int = 0 // 当前日记行已经使用的列数
        while rowColumn <= diary.column {
            if cardIndex < diary.cardData.count { // 判断当前卡片索引是否在范围内
                let card = diary.cardData[cardIndex] // 当前的卡片
                let cardColumn = card.column // 当前卡片所占的列数
                if rowColumn + cardColumn <= diary.column { // 判断当前行是否能容纳该卡片
                    data[columnIndex].append((card: card, index: cardIndex)) // 向当前行添加该卡片
                    rowColumn += cardColumn // 更新当前日记行已经使用的列数
                    cardIndex += 1 // 更新当前的卡片索引
                } else {
                    break
                }
            } else {
                break
            }
        }
        columnIndex += 1 // 更新当前的行索引
    }
    return data
}
