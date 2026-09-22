import SwiftUI

struct PlanView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.largeTitle)
                    .foregroundStyle(Theme.secondaryText)
                Text("Der Wochenplan folgt, sobald der KI-Coach angebunden ist (Phase 5).")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.secondaryText)
                    .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
            .navigationTitle("Plan")
        }
    }
}
