import Foundation
import SwiftData
import Observation

@Observable
@MainActor
final class SymptomRecordViewModel {
    var date: Date = .now
    var time: Date = .now
    var bloating: Int = 0
    var abdominalPain: Int = 0
    var gas: Int = 0
    var diarrhea: Int = 0
    var constipation: Int = 0
    var bristolScale: Int? = nil
    var memo: String = ""

    var overallScore: Int {
        bloating + abdominalPain + gas + diarrhea + constipation
    }

    var severityLabel: String {
        switch overallScore {
        case 0: "症状なし"
        case 1...4: "軽度"
        case 5...9: "中度"
        case 10...15: "重度"
        default: "不明"
        }
    }

    func value(for type: SymptomType) -> Int {
        switch type {
        case .bloating: bloating
        case .abdominalPain: abdominalPain
        case .gas: gas
        case .diarrhea: diarrhea
        case .constipation: constipation
        }
    }

    func setValue(_ value: Int, for type: SymptomType) {
        switch type {
        case .bloating: bloating = value
        case .abdominalPain: abdominalPain = value
        case .gas: gas = value
        case .diarrhea: diarrhea = value
        case .constipation: constipation = value
        }
    }

    func save(modelContext: ModelContext) {
        let record = SymptomRecord(
            date: date,
            time: time,
            bloating: bloating,
            abdominalPain: abdominalPain,
            gas: gas,
            diarrhea: diarrhea,
            constipation: constipation,
            bristolScale: bristolScale,
            memo: memo.isEmpty ? nil : memo
        )
        modelContext.insert(record)
        try? modelContext.save()
    }

    func reset() {
        bloating = 0
        abdominalPain = 0
        gas = 0
        diarrhea = 0
        constipation = 0
        bristolScale = nil
        memo = ""
        time = .now
    }
}
