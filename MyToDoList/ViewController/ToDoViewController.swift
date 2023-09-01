import UIKit

class ToDoViewController: UIViewController {
    let table = UITableView()
    var content = [TodoList]()
    var sections = [ToDoSection] ()
    var textInputHandler: ((String, Date) -> Void)?
    
    var deletedItems: [TodoList] = [] // 삭제항목 저장
    var doneItems: [TodoList] = [] // 완료항목 저장
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        table.delegate = self
        table.dataSource = self
        // 예시 데이터
        content.append(TodoList(title: "산책하기", date: Date()))
        content.append(TodoList(title: "3차 예방접종", date: Date()))
        // 함수 호출
        setNavigationBar()
        attribute()
        setupTableView()
        loadContentFromUserDefaults() // 저장된 내용 로드
        dateSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let savedContentData = UserDefaults.standard.data(forKey: "todoList"),
           let savedContent = try? JSONDecoder().decode([TodoList].self, from: savedContentData) {
            content = savedContent
            table.reloadData() // 데이터 불러오기
        }
    }
    
    func loadContentFromUserDefaults() {
        if let savedContentData = UserDefaults.standard.data(forKey: "todoList"),
           let savedContent = try? JSONDecoder().decode([TodoList].self, from: savedContentData) {
            content = savedContent
        }
    }
    
    func dateSections() {
        let groupedContent = Dictionary(grouping: content, by: { Calendar.current.startOfDay(for: $0.date) })
        sections = groupedContent.map { (date, items) in
            return ToDoSection(date: date, items: items)
        }
        sections.sort { $0.date > $1.date }
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "To Do List"
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBtn
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped(_ button: UIButton) {
        let addToDoVC = AddToDoVC()
        addToDoVC.textInputHandler = { [weak self] text, date in
            self?.content.append(TodoList(title: text, date: date))
            self?.table.reloadData()
            self?.saveContentToUserDefaults()
        }
        self.navigationController?.pushViewController(addToDoVC, animated: true)
    }
    
    func attribute() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupTableView() {
        view.addSubview(table)
        table.rowHeight = 50
        table.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

extension ToDoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count // 섹션 수
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: sections[section].date)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 // title과의 간격 조정
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count // 같은 날짜 다른 내용,,~
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = sections[indexPath.section].items[indexPath.row].title // 섹션 분류 ㅡ 섹션의 타이틀 배열
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // More Btn
        let more = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.showMoreActionSheet(indexPath: indexPath)
            success(true)
        }
        more.image = UIImage(systemName: "ellipsis.circle")
        more.backgroundColor = .systemGray
        
        // Delete Btn
        let delete = UIContextualAction(style: .normal, title: nil) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.showDeleteConfirmationAlert(indexPath: indexPath)
            success(true)
        }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete, more])
    }
    
    func showMoreActionSheet(indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // Edit Action
        let editAction = UIAlertAction(title: "Edit", style: .default) { (_) in
            // Edit 버튼을 눌렀을 때 기능 구현
        }
        actionSheet.addAction(editAction)
        
        // Done Action
        let doneAction = UIAlertAction(title: "Done", style: .default) { (_) in
            self.showDoneConfirmationAlert(indexPath: indexPath)
        }
        actionSheet.addAction(doneAction)
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showDeleteConfirmationAlert(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Delete", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            let deletedItem = self.sections[indexPath.section].items.remove(at: indexPath.row)
            self.deletedItems.append(deletedItem) // 삭제된 항목을 배열에 추가
            
            // 섹션의 내용이 비어있으면 섹션도 함께 제거
            if self.sections[indexPath.section].items.isEmpty {
                self.sections.remove(at: indexPath.section)
                self.table.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            } else {
                self.table.deleteRows(at: [indexPath], with: .fade) // 항목 제거 업데이트
            }
            self.saveContentToUserDefaults()
            self.saveDeletedItemsToUserDefaults() // 삭제항목 저장
            
            // 삭제된 항목이 아니면 Done 확인창 띄우기
            if self.deletedItems.contains(where: { $0.title == deletedItem.title }) == false {
                self.showDoneConfirmationAlert(indexPath: indexPath)
            }
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showDoneConfirmationAlert(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Done", message: "이 항목을 완료하시겠습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let doneAction = UIAlertAction(title: "OK", style: .default) { _ in
            let doneItem = self.sections[indexPath.section].items.remove(at: indexPath.row)
            self.doneItems.append(doneItem) // 완료된 항목을 배열에 추가
            
            // 섹션의 내용이 비어있으면 섹션도 함께 제거
            if self.sections[indexPath.section].items.isEmpty {
                self.sections.remove(at: indexPath.section)
                self.table.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
            } else {
                self.table.deleteRows(at: [indexPath], with: .fade) // 항목 제거 업데이트
            }
            self.saveContentToUserDefaults()
            self.saveDoneItemsToUserDefaults() // 완료항목 저장
        }
        alertController.addAction(doneAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func saveContentToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(content) {
            UserDefaults.standard.set(encoded, forKey: "todoList")
        }
    }
    
    func saveDeletedItemsToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(deletedItems) {
            UserDefaults.standard.set(encoded, forKey: "deletedTodoList")
        }
    }
    
    func saveDoneItemsToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(doneItems) {
            UserDefaults.standard.set(encoded, forKey: "doneTodoList")
        }
    }
    
}

struct TodoList: Codable {
    var title: String
    var date: Date
    
    init(title: String, date: Date) {
        self.title = title
        self.date = date
    }
}

struct ToDoSection {
    var date: Date
    var items: [TodoList]
}

