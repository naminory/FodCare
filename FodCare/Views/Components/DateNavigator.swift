import SwiftUI

struct DateNavigator: View {
    @Binding var date: Date
    var onPrevious: () -> Void
    var onNext: () -> Void

    var body: some View {
        HStack {
            Button {
                onPrevious()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundStyle(ColorTheme.primary)
            }

            Spacer()

            VStack(spacing: 2) {
                Text(DateHelper.displayDate(date))
                    .font(.headline)
                if DateHelper.isToday(date) {
                    Text("今日")
                        .font(.caption)
                        .foregroundStyle(ColorTheme.primary)
                        .fontWeight(.bold)
                }
            }
            .onTapGesture {
                date = .now
            }

            Spacer()

            Button {
                onNext()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundStyle(DateHelper.isToday(date) ? .secondary : ColorTheme.primary)
            }
            .disabled(DateHelper.isToday(date))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
