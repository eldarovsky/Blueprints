//
//  NotesViewController.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 07.05.2024.
//

import UIKit

// MARK: - Notes ViewController

final class NotesViewController: UIViewController {

    // MARK: - Private properties

    private let storageManager = StorageManager.shared

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let footerView = UIView()
    private let notesCounterLabel = UILabel()
    private let addNoteButton = UIButton()

    private var notes: [Note] = []

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        notesCounterLabel.text = notes.count <= 1 ? "\(notes.count) note" : "\(notes.count) notes"
        tableView.reloadData()
    }
}

// MARK: - Notes ViewController extension

private extension NotesViewController {
    func setupView() {
        addSubviews()
        disableAutoresizingMask()
        setConstraints()

        setupNavigationBar()
        setupTableView()
        setupUI()
        addActions()
        fetchData()
    }
}

private extension NotesViewController {

    // MARK: - Private methods

    /// addSubviews method
    func addSubviews() {
        view.addSubviews(
            tableView,
            footerView,
            notesCounterLabel,
            addNoteButton
        )
    }

    /// disableAutoresizingMask method
    func disableAutoresizingMask() {
        view.disableAutoresizingMask(
            tableView,
            footerView,
            notesCounterLabel,
            addNoteButton
        )
    }

    /// setConstraints method
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            footerView.heightAnchor.constraint(equalToConstant: 80),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            notesCounterLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            notesCounterLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),

            addNoteButton.heightAnchor.constraint(equalToConstant: 30),
            addNoteButton.widthAnchor.constraint(equalToConstant: 30),
            addNoteButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -30),
            addNoteButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
    }

    /// setupTableView method
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    /// setupNavigationBar method
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)
        ]
        appearance.backgroundColor = UIColor(red: 24/255, green: 67/255, blue: 103/255, alpha: 1)

        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance

        title = "Notes"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }

    /// setupUI method
    private func setupUI() {
        tableView.backgroundColor = .systemGray6
        footerView.backgroundColor = .systemGray6

        notesCounterLabel.font = UIFont(name: "system", size: 17)

        addNoteButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        addNoteButton.tintColor = .black
    }

    /// addActions method
    private func addActions() {
        addNoteButton.addTarget(self, action: #selector(showAddNoteVC), for: .touchUpInside)
    }

    /// showAddNoteVC method
    @objc private func showAddNoteVC() {
        navigationController?.pushViewController(AddNoteViewController(), animated: true)
    }







    ///Метод получения данных из СoreData
    private func fetchData() {
        storageManager.fetch { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let notes):
                self.notes = notes
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        notes.sort { $0.date ?? Date() > $1.date ?? Date() }
    }

    ///Метод форматирования даты и времени
    private func dateToString(format: String, date: Date?) -> String? {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let stringData = formatter.string (from: date)
        return stringData
    }

    private func getImage(from date: Date?) -> String {
        if let noteDate = date {
            let hour = Calendar.current.component(.hour, from: noteDate)
            switch hour {
            case 0..<3:
                return "1"
            case 3..<6:
                return "2"
            case 6..<9:
                return "3"
            case 9..<12:
                return "4"
            case 12..<15:
                return "5"
            case 15..<18:
                return "6"
            case 18..<21:
                return "7"
            default:
                return "8"
            }
        } else {
            return ""
        }
    }
}

// MARK: - Methods Protocols

extension NotesViewController: UITableViewDataSource {

    // MARK: Table View Data Sourse

    /// Количество строк в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    /// Настраиваем ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let note = notes[indexPath.row]
        let time = dateToString(format: "dd.MM.yy", date: note.date)

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white

        var content = cell.defaultContentConfiguration()

        content.text = note.title
        content.textProperties.numberOfLines = 1
        content.textProperties.font = .boldSystemFont(ofSize: 17)

        content.secondaryText = "\(time ?? "") \(note.text ?? "")"
        content.secondaryTextProperties.numberOfLines = 1
        content.secondaryTextProperties.color = .gray

        let image = getImage(from: note.date)
        content.image = UIImage(named: image)
        content.image = content.image?.withTintColor(.black)

        cell.contentConfiguration = content

        return cell
    }
}

extension NotesViewController: UITableViewDelegate {

    // MARK: Table View Delegate

    ///При нажатии на ячейку переходим на экран редактирования и переносим данные
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddNoteViewController()
        vc.note = notes[indexPath.row]
        vc.textView.text = notes[indexPath.row].text

        navigationController?.pushViewController(vc, animated: true)
    }

    ///Метод удаления ячейки свайпом влево
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.delete(note: note)
            //            notesCounterLabel.text = notes.count <= 1 ? "\(notes.count) note" : "\(notes.count) notes"
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}



private enum TimeOfDay: String {
    case morning = "утро"
    case afternoon = "день"
    case evening = "вечер"
    case night = "ночь"

    static func getTimeOfDay() -> TimeOfDay {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        switch hour {
        case 6..<12:
            return .morning
        case 12..<18:
            return .afternoon
        case 18..<22:
            return .evening
        default:
            return .night
        }
    }
}



