
import UIKit

class DoneViewController: UIViewController {
    let list = UITableView()
    var doneItems = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        list.delegate = self
        list.dataSource = self
        // 함수 호출
        setNavigationBar()
        attribute()
        setupTableView()
        loadContentFromUserDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContentFromUserDefaults() // 저장된 내용 로드 및 업데이트
    }
    
    func saveContentToUserDefaults() {
        UserDefaults.standard.set(doneItems, forKey: "doneTodoList")
    }
    
    func loadContentFromUserDefaults() {
        if let savedContentData = UserDefaults.standard.data(forKey: "doneTodoList"),
           let savedContent = try? JSONDecoder().decode([String].self, from: savedContentData) {
            doneItems = savedContent // doneItems 배열에 저장된 내용 업데이트
            list.reloadData() // 테이블 데이터 다시 불러오기
        }
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "Done"
        // back 글씨 없애기
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBtn
    }
    
    func attribute() {
        list.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    func setupTableView() {
        view.addSubview(list)
        list.rowHeight = 60
        list.translatesAutoresizingMaskIntoConstraints = false
        
        // AutoLayout
        NSLayoutConstraint.activate([
            list.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            list.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            list.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            list.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    }
}


extension DoneViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = list.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = doneItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        list.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 좌측으로 스와이프 시 삭제 기능 구현
        if editingStyle == .delete {
            showDeleteConfirmationAlert(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        // 스와이프 시 나타낼 문구
        return "Delete"
    }
    
    func showDeleteConfirmationAlert(indexPath: IndexPath){
        let alertController = UIAlertController(title: "Delete", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            self.doneItems.remove(at: indexPath.row)
            self.list.deleteRows(at: [indexPath], with: .fade)
            self.saveContentToUserDefaults() // 데이터 저장
        }
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
}

