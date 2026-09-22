import SwiftUI

struct AppShell: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Heute", systemImage: "sun.max") }
            PlanView()
                .tabItem { Label("Plan", systemImage: "calendar") }
            TrainingView()
                .tabItem { Label("Training", systemImage: "dumbbell") }
            ProgressTabView()
                .tabItem { Label("Fortschritt", systemImage: "chart.line.uptrend.xyaxis") }
        }
        .tint(Theme.accent)
        .preferredColorScheme(.dark)
    }
}
