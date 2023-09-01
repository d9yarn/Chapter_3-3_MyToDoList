import UIKit

class AddToDoVC: UIViewController {
    let dateLabel = UILabel()
    let titleLabel = UILabel()
    let dateTextView = UITextView()
    let listTextView = UITextView()
    let datePickerPlaceholder = "날짜를 입력해주세요."
    let textViewPlaceholder = "할일을 입력해주세요."
    let addButton = UIButton()
    
    var delegate: AddToDoDelegate?
    var selectedDate: Date?
    var textInputHandler: ((String, Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemGray6
        setNavigationBar()
        addDate()
        addContent()
        datePicker()
        textViewClickEvent()
    }
    
    func setNavigationBar() {
        // 네비게이션 타이틀
        self.navigationItem.title = "Add To Do"
        let backBtn = UIBarButtonItem()
        // 뒤로가기 버튼 "Back" 문구 삭제
        backBtn.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBtn
    }
    
    func addDate() {
        let safeArea = view.safeAreaLayoutGuide
        // dateLabel Style
        dateLabel.text = "Date"
        dateLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        view.addSubview(dateLabel)
        // dateLabel Layout
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 35).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        
        // dateTextView Style
        dateTextView.backgroundColor = .white
        dateTextView.layer.cornerRadius = 10
        dateTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        dateTextView.text = datePickerPlaceholder
        dateTextView.font = UIFont.systemFont(ofSize: 15)
        dateTextView.textColor = .lightGray
        dateTextView.textContainerInset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
        dateTextView.delegate = self
        view.addSubview(dateTextView)
        // dateTextView Layout
        dateTextView.translatesAutoresizingMaskIntoConstraints = false
        dateTextView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        dateTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dateTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20).isActive = true
        dateTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
    }
    
    func datePicker() {
        let pickerView = UIDatePicker()
        pickerView.preferredDatePickerStyle = .inline
        pickerView.backgroundColor = .white
        pickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        dateTextView.tintColor = .clear
        dateTextView.inputView = pickerView
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        selectedDate = sender.date
        updateDateTextView()
        dateTextView.resignFirstResponder()
    }
    
    func updateDateTextView() {
        if let date = selectedDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateTextView.text = dateFormatter.string(from: date)
            dateTextView.textColor = .black
        } else {
            dateTextView.text = datePickerPlaceholder
            dateTextView.textColor = .lightGray
        }
    }
    
    func addContent() {
        let safeArea = view.safeAreaLayoutGuide
        // titleLable Style
        titleLabel.text = "ToDo"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        view.addSubview(titleLabel)
        // titleLable Layout // titleLable Style
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 105).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        
        // listTextView Style
        listTextView.backgroundColor = .white
        listTextView.layer.cornerRadius = 10
        listTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
        listTextView.text = textViewPlaceholder
        listTextView.font = UIFont.systemFont(ofSize: 15)
        listTextView.textColor = .lightGray
        listTextView.textContainerInset = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
        listTextView.delegate = self
        view.addSubview(listTextView)
        // listTextView Layout
        listTextView.translatesAutoresizingMaskIntoConstraints = false
        listTextView.widthAnchor.constraint(equalToConstant: 270).isActive = true
        listTextView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        listTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 90).isActive = true
        listTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        
        // listTextView Style
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(UIColor.blue, for: .normal)
        addButton.backgroundColor = .white
        addButton.layer.cornerRadius = 10
        addButton.layer.borderWidth = 0.8
        addButton.layer.borderColor = UIColor.blue.cgColor
        view.addSubview(addButton)
        // addButton Layout
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.widthAnchor.constraint(equalToConstant: 330).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.topAnchor.constraint(equalTo: listTextView.topAnchor, constant: 70).isActive = true
        addButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc func addButtonTapped() {
        // 날짜와 할일을 입력하지 않았을 때 띄우는 알림창
        if let text = listTextView.text, !text.isEmpty, let date = selectedDate {
            textInputHandler?(text, date) // ToDoVC로 데이터 전달
            navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "Error", message: "할일과 날짜를 입력하세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func textViewClickEvent() {
        // 텍스트뷰 클릭 시 발생하는 이벤트
        let dateTapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTextViewTapped))
        dateTextView.addGestureRecognizer(dateTapGesture)
        
        let listTapGesture = UITapGestureRecognizer(target: self, action: #selector(listTextViewTapped))
        listTextView.addGestureRecognizer(listTapGesture)
        
        dateTextView.inputAccessoryView = UIView()
        listTextView.inputAccessoryView = UIView()
        updateDateTextView()
    }
    
    @objc func dateTextViewTapped() {
        dateTextView.layer.borderWidth = 1
        dateTextView.layer.borderColor = UIColor.gray.cgColor
        if dateTextView.text == datePickerPlaceholder {
            dateTextView.text = nil
            dateTextView.textColor = .black
        }
        dateTextView.becomeFirstResponder()
    }
    
    @objc func listTextViewTapped() {
        listTextView.layer.borderWidth = 1
        listTextView.layer.borderColor = UIColor.gray.cgColor
        if listTextView.text == textViewPlaceholder {
            listTextView.text = nil
            listTextView.textColor = .black
        }
        listTextView.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 입력 완료 시 키보드 내려감
        self.view.endEditing(true)
    }
}

extension AddToDoVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == dateTextView && textView.text.isEmpty {
            textView.text = datePickerPlaceholder
            textView.textColor = .lightGray
        } else if textView == listTextView && textView.text.isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = .lightGray
        }
        textView.layer.borderWidth = 0.8
        textView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.7).cgColor
    }
}

protocol AddToDoDelegate: AnyObject {
    func didAddNewToDoItem(_ item: ToDoItem)
}

