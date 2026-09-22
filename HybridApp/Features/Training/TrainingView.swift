import SwiftUI

struct TrainingView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "dumbbell")
                    .font(.largeTitle)
                    .foregroundStyle(Theme.secondaryText)
                Text("Krafttraining erfassen folgt in Phase 3.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.secondaryText)
                    .padding(.horizontal, 32)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
            .navigationTitle("Training")
        }
    }
}
