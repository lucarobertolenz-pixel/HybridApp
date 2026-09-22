import SwiftUI

struct ProgressTabView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.largeTitle)
                    .foregroundStyle(Theme.secondaryText)
                Text("Zonen und Trends erscheinen hier, sobald die Analyse-Engine steht (Phase 2).")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.secondaryText)
                    .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
            .navigationTitle("Fortschritt")
        }
    }
}
