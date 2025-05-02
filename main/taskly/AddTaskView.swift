
import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                Section {
                    Button("Add Task") {
                        guard !title.isEmpty else { return }
                        taskViewModel.addTask(title: title, description: description, date: date)
                        title = ""; description = ""; date = Date()
                        showAlert = true
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("Add Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
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
            .alert("Task Added", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your task has been added successfully.")
            }
        }
    }
}

