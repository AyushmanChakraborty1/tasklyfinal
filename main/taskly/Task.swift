

import Foundation

struct Task: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var date: Date
    var isCompleted: Bool = false
}
