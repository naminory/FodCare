import Testing
import Foundation
import SwiftData
@testable import FodCare

@Suite("HomeViewModel テスト")
struct HomeViewModelTests {

    // MARK: - 日付ナビゲーション

    @Test("初期日付は今日")
    @MainActor
    func initialDate() {
        let vm = HomeViewModel()
        #expect(Calendar.current.isDateInToday(vm.selectedDate))
    }

    @Test("日付を1日進められる")
    @MainActor
    func moveDayForward() {
        let vm = HomeViewModel()
        let today = vm.selectedDate
        vm.moveDay(by: 1)
        let diff = Calendar.current.dateComponents([.day], from: today, to: vm.selectedDate).day
        #expect(diff == 1)
    }

    @Test("日付を1日戻せる")
    @MainActor
    func moveDayBackward() {
        let vm = HomeViewModel()
        let today = vm.selectedDate
        vm.moveDay(by: -1)
        let diff = Calendar.current.dateComponents([.day], from: today, to: vm.selectedDate).day
        #expect(diff == -1)
    }

    @Test("goToTodayで今日に戻る")
    @MainActor
    func goToToday() {
        let vm = HomeViewModel()
        vm.moveDay(by: -5)
        #expect(!Calendar.current.isDateInToday(vm.selectedDate))
        vm.goToToday()
        #expect(Calendar.current.isDateInToday(vm.selectedDate))
    }

    @Test("複数日移動が正しい")
    @MainActor
    func moveMultipleDays() {
        let vm = HomeViewModel()
        let today = vm.selectedDate
        vm.moveDay(by: 3)
        vm.moveDay(by: -1)
        let diff = Calendar.current.dateComponents([.day], from: today, to: vm.selectedDate).day
        #expect(diff == 2)
    }

    // MARK: - FODMAPサマリー

    @Test("食事なしの場合サマリーは全カテゴリ0")
    @MainActor
    func emptyFODMAPSummary() {
        let vm = HomeViewModel()
        let summary = vm.fodmapSummary(meals: [])
        for category in FODMAPCategory.allCases {
            #expect(summary[category] == 0)
        }
    }
}
