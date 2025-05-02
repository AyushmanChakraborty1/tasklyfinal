// File: HomeView.swift
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(taskViewModel.tasks) { task in
                    TaskRow(task: task)
                }
                .onDelete(perform: taskViewModel.deleteTask)
            }
            .navigationTitle("My Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(spacing: 4) {
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        EditButton()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("⭐️ \(taskViewModel.totalCompletedCount)")
                            .font(.headline)
                        Text("🔥 \(taskViewModel.currentStreak)-day streak")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
