import UIKit

class MainViewController: UIViewController {
    let toDoButton = UIButton()
    let doneButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackground()
        setButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 다른 뷰로 이동 시 버튼색상을 초기값으로 돌려놓음
        toDoButton.backgroundColor = .white
        toDoButton.setTitleColor(UIColor.systemBlue, for: .normal)
        doneButton.backgroundColor = .white
        doneButton.setTitleColor(UIColor.gray, for: .normal)
    }
    
    func setBackground(){
        let backImg = UIImageView(frame: UIScreen.main.bounds)
        let urlString = "https://i.pinimg.com/750x/98/7a/bf/987abf8be9a98bc0fcc2e7c1da80df55.jpg"
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data, let backgroundImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        backImg.image = backgroundImage
                        backImg.contentMode = .scaleAspectFill
                        self.view.insertSubview(backImg, at: 0)
                    }
                } else {
                    print("이미지 로딩 실패")
                }
            }
            task.resume()
        }
    }
    
    func setButton(){
        let safeArea = view.safeAreaLayoutGuide
        
        // Button Style
        toDoButton.backgroundColor = .white
        toDoButton.layer.cornerRadius = 70
        toDoButton.layer.borderColor = UIColor.systemBlue.cgColor
        toDoButton.layer.borderWidth = 2
        toDoButton.setTitle("ToDo", for: .normal)
        toDoButton.setTitleColor(UIColor.systemBlue, for: .normal)
        view.addSubview(toDoButton)
        
        doneButton.backgroundColor = .white
        doneButton.layer.cornerRadius = 70
        doneButton.layer.borderColor = UIColor.gray.cgColor
        doneButton.layer.borderWidth = 2
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.gray, for: .normal)
        view.addSubview(doneButton)
        
        // AutoLayout
        toDoButton.translatesAutoresizingMaskIntoConstraints = false
        toDoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true  // 가로 너비
        toDoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true // 세로 길이
        toDoButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 200).isActive = true
        toDoButton.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 45).isActive = true
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.widthAnchor.constraint(equalToConstant: 140).isActive = true  // 가로 너비
        doneButton.heightAnchor.constraint(equalToConstant: 140).isActive = true // 세로 길이
        doneButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 200).isActive = true
        doneButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -45).isActive = true
        
        // Button Action
        toDoButton.addTarget(self, action: #selector(toDoTapped(_:)), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneTapped(_:)), for: .touchUpInside)
    }
    
    @objc func toDoTapped(_ button: UIButton) {
        // 클릭 시 색상 전환
        toDoButton.backgroundColor = .systemBlue
        toDoButton.setTitleColor(UIColor.white, for: .normal)
        
        // ToDoVC로 화면 전환
        let todoVC = ToDoViewController()
        self.navigationController?.pushViewController(todoVC, animated: true)
    }
    
    @objc func doneTapped(_ button: UIButton) {
        // 클릭 시 색상 전환
        doneButton.backgroundColor = .gray
        doneButton.setTitleColor(UIColor.white, for: .normal)
        
        // DoneVC로 화면 전환
        let doneVC = DoneViewController()
        self.navigationController?.pushViewController(doneVC, animated: true)
    }
}
