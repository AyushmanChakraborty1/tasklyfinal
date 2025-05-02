// File: TaskViewModel.swift
import Foundation
import SwiftUI

extension Notification.Name {
    /// Fired when the user completes every task for today
    static let allTasksForTodayComplete = Self("allTasksForTodayComplete")
}

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet { saveTasks() }
    }
    private let tasksKey = "tasks_key"
    private let totalKey = "taskly_totalCompleted"
    private let streakKey = "taskly_currentStreak"
    private let lastStreakKey = "taskly_lastStreakDate"

    @Published private(set) var totalCompletedCount: Int
    @Published private(set) var currentStreak: Int
    private var lastStreakDate: Date?

    init() {
        self.totalCompletedCount = UserDefaults.standard.integer(forKey: totalKey)
        self.currentStreak = UserDefaults.standard.integer(forKey: streakKey)
        if let savedDate = UserDefaults.standard.object(forKey: lastStreakKey) as? Date {
            self.lastStreakDate = savedDate
        }
        loadTasks()
    }

    func addTask(title: String, description: String, date: Date) {
        tasks.append(Task(title: title, description: description, date: date))
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    func toggleTaskCompletion(task: Task) {
        guard let i = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        let wasCompleted = tasks[i].isCompleted
        tasks[i].isCompleted.toggle()
        if tasks[i].isCompleted && !wasCompleted {
            totalCompletedCount += 1
            UserDefaults.standard.set(totalCompletedCount, forKey: totalKey)
        }

        let today = Calendar.current.startOfDay(for: Date())
        let todayTasks = getTasks(for: today)
        let allDone = todayTasks.allSatisfy { $0.isCompleted }

        if allDone {
            let lastDate = lastStreakDate.map { Calendar.current.startOfDay(for: $0) }
            if lastDate == nil || lastDate! < today {
                currentStreak += 1
                UserDefaults.standard.set(currentStreak, forKey: streakKey)
                lastStreakDate = today
                UserDefaults.standard.set(today, forKey: lastStreakKey)
                NotificationCenter.default.post(
                    name: .allTasksForTodayComplete,
                    object: nil
                )
            }
        }
    }

    private func saveTasks() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: tasksKey)
        }
    }

    private func loadTasks() {
        guard
          let data = UserDefaults.standard.data(forKey: tasksKey),
          let saved = try? JSONDecoder().decode([Task].self, from: data)
        else { return }
        tasks = saved
    }

    func getTasks(for date: Date) -> [Task] {
        let cal = Calendar.current
        return tasks.filter { cal.isDate($0.date, inSameDayAs: date) }
    }
}

extension TaskViewModel {
    static var preview: TaskViewModel {
        let vm = TaskViewModel()
        vm.tasks = [
            Task(title: "Finish Homework", description: "Math 104", date: Date()),
            Task(title: "Buy Groceries",   description: "Milk, Eggs", date: Date()),
            Task(title: "Call Mom",        description: "Weekly catch-up", date: Date())
        ]
        vm.totalCompletedCount = vm.tasks.filter { $0.isCompleted }.count
        vm.currentStreak = UserDefaults.standard.integer(forKey: vm.streakKey)
        return vm
    }
}


