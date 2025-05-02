
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home",   systemImage: "house") }
            CalendarView()
                .tabItem { Label("Calendar", systemImage: "calendar") }
            AddTaskView()
                .tabItem { Label("Add Task", systemImage: "plus.circle") }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TaskViewModel.preview)
}
