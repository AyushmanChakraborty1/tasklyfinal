// File: tasklyApp.swift
import SwiftUI

@main
struct tasklyApp: App {
    @StateObject private var taskViewModel = TaskViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(taskViewModel)
        }
    }
}

/// Listens for streak-completion notifications and presents a popup
struct RootView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var showPopup = false

    var body: some View {
        ContentView()
            .onReceive(
                NotificationCenter.default.publisher(for: .allTasksForTodayComplete)
            ) { _ in
                showPopup = true
            }
            .sheet(isPresented: $showPopup) {
                CompletionPopup(show: $showPopup)
            }
    }
}

/// Simple modal view with celebration emoji and close button
struct CompletionPopup: View {
    @Binding var show: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("🎉")
                .font(.system(size: 80))
            Text("You earned a streak day!")
                .font(.title2)
                .fontWeight(.semibold)
            Button(action: { show = false }) {
                Text("Great!")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

