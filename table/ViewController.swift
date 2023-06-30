import UIKit
import SnapKit
struct Contact {
    let name: String
    init(name: String) {
        self.name = name
    }
}
class ViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let contactCellIdentifier = "contactCell"
    var data: [Contact] = [
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        tableView.allowsMultipleSelectionDuringEditing = true
        makeConstraints()
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: contactCellIdentifier, for: indexPath) as! ContactCell
        cell.configure(data: data[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
private extension ViewController {
    @objc func tap() {
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter task name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let name = alert.textFields?.first?.text else { return }
            let newContact = Contact(name: name)
            self?.data.append(newContact)
            self?.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    func setupScene() {
        title = "Task List"
        let barButton = UIBarButtonItem(title: "Add Task", style: .plain, target: self, action: #selector(tap))
        navigationItem.rightBarButtonItem = barButton
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEditing = false
        tableView.register(ContactCell.self, forCellReuseIdentifier: contactCellIdentifier)
        view.addSubview(tableView)
        tableView.isEditing = false
    }
    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
class ContactCell: UITableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure(data: Contact) {
        nameLabel.text = data.name
    }
}
private extension ContactCell {
    func setupCell() {
        contentView.addSubview(nameLabel)
    }
    func makeConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().inset(12)
        }
    }
}
