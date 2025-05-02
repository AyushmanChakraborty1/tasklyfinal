// File: CalendarView.swift
import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var selectedDate = Date()

    var body: some View {
        NavigationView {
            List {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .listRowInsets(EdgeInsets())
                .padding(.vertical, 8)

                Section {
                    let tasksForDate = taskViewModel.getTasks(for: selectedDate)
                    if tasksForDate.isEmpty {
                        Text("No tasks for this date")
                            .italic()
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(tasksForDate) { task in
                            TaskRow(task: task)
                        }
                        .onDelete { offsets in
                            taskViewModel.deleteTask(at: offsets)
                        }
                    }
                }
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(spacing: 4) {
                        Image("AppLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
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
