import Foundation

struct ToDoItem {
    var title: String
    var dueDate: Date?
    var isComplete: Bool
}

class ToDoListManager {
    static var shared = ToDoListManager() // 싱글톤 인스턴스
    var todoItems: [ToDoItem] = [] // 할일 목록
    private init() {}
}
