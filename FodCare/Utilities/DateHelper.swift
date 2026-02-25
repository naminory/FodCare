import Foundation

enum DateHelper {
    private static let calendar = Calendar.current

    /// 日付の開始時刻（00:00:00）
    static func startOfDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    /// 日付の終了時刻（23:59:59）
    static func endOfDay(_ date: Date) -> Date {
        calendar.date(byAdding: .day, value: 1, to: startOfDay(date))!.addingTimeInterval(-1)
    }

    /// n日前の日付
    static func daysAgo(_ days: Int, from date: Date = .now) -> Date {
        calendar.date(byAdding: .day, value: -days, to: startOfDay(date))!
    }

    /// 表示用の日付フォーマット（例: "2月25日（火）"）
    static func displayDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日（E）"
        return formatter.string(from: date)
    }

    /// 時刻フォーマット（例: "14:30"）
    static func displayTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "H:mm"
        return formatter.string(from: date)
    }

    /// 今日かどうか
    static func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    /// 同じ日かどうか
    static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        calendar.isDate(date1, inSameDayAs: date2)
    }
}
