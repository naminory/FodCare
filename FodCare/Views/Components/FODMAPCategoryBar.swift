import SwiftUI

// FODMAP 5分類の横並び表示バー
struct FODMAPCategoryBar: View {
    let fructanLevel: Int
    let gosLevel: Int
    let lactoseLevel: Int
    let fructoseLevel: Int
    let polyolLevel: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(items, id: \.category) { item in
                VStack(spacing: 4) {
                    Circle()
                        .fill(item.level.color)
                        .frame(width: 24, height: 24)
                        .overlay {
                            Text(item.level.label)
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    Text(item.category.rawValue)
                        .font(.system(size: 9))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
    }

    private var items: [(category: FODMAPCategory, level: FODMAPLevel)] {
        [
            (.fructan, FODMAPLevel(rawValue: fructanLevel) ?? .low),
            (.gos, FODMAPLevel(rawValue: gosLevel) ?? .low),
            (.lactose, FODMAPLevel(rawValue: lactoseLevel) ?? .low),
            (.fructose, FODMAPLevel(rawValue: fructoseLevel) ?? .low),
            (.polyol, FODMAPLevel(rawValue: polyolLevel) ?? .low)
        ]
    }
}

// FoodItemから直接表示するコンビニエンスイニシャライザ
extension FODMAPCategoryBar {
    init(foodItem: FoodItem) {
        self.init(
            fructanLevel: foodItem.fructanLevel,
            gosLevel: foodItem.gosLevel,
            lactoseLevel: foodItem.lactoseLevel,
            fructoseLevel: foodItem.fructoseLevel,
            polyolLevel: foodItem.polyolLevel
        )
    }
}

#Preview {
    FODMAPCategoryBar(
        fructanLevel: 2, gosLevel: 0, lactoseLevel: 0,
        fructoseLevel: 1, polyolLevel: 0
    )
}
