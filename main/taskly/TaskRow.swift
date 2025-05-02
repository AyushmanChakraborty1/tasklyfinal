

import Foundation
import SwiftUI

struct TaskRow: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    var task: Task

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                Text(task.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(task.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            Spacer()
            Button {
                taskViewModel.toggleTaskCompletion(task: task)
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
        }
        .padding(.vertical, 4)
    }
}
