//
//  NotesViewController.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 07.05.2024.
//

import UIKit
import SnapKit

// MARK: - Notes ViewController Protocol

protocol NotesViewControllerProtocol: AnyObject {
    func reloadData()
    func updateNotesCounterLabel()
    func deleteRow(at index: Int)
    func showAddNoteView()
}

// MARK: - Notes ViewController

final class NotesViewController: UIViewController {
    
    // MARK: - Public properties

    weak var notesViewControllerCoordinator: NotesViewControllerCoordinator?
    var presenter: NotesPresenterProtocol?
    
    // MARK: - Private properties

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let footerView = UIView()
    private let notesCounterLabel = UILabel()
    private let addNoteButton = UIButton()

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchData()
        updateNotesCounterLabel()
    }
}

// MARK: - Private methods

private extension NotesViewController {
    func setupView() {
        addSubviews()
        disableAutoresizingMask()
        setConstraints()
        
        setupNavigationBar()
        setupTableView()
        setupUI()


        addActions()
    }
}

private extension NotesViewController {

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
    func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        footerView.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.leading.trailing.bottom.equalToSuperview()
        }

        notesCounterLabel.snp.makeConstraints { make in
            make.centerX.equalTo(footerView.snp.centerX)
            make.centerY.equalTo(footerView.snp.top).offset(20)
        }

        addNoteButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(footerView.snp.top).offset(20)
            make.trailing.equalTo(footerView.snp.trailing).offset(-30)
        }
    }

    /// setupTableView method
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.backgroundColor = UIColor(red: 24/255, green: 67/255, blue: 103/255, alpha: 1)

        let attributedTitle = NSAttributedString(
            string: "Refresh",
            attributes: [.foregroundColor: UIColor.white]
        )

        refreshControl.attributedTitle = attributedTitle


        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    /// setupNavigationBar method
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        title = "Notes"
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)
        ]
        
        appearance.backgroundColor = UIColor(red: 24/255, green: 67/255, blue: 103/255, alpha: 1)
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Notes", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }

    /// setupUI method
    func setupUI() {
        tableView.backgroundColor = .systemGray6
        footerView.backgroundColor = .systemGray6

        let config = UIImage.SymbolConfiguration(pointSize: 17)
        let image = UIImage(systemName: "square.and.pencil", withConfiguration: config)
        addNoteButton.setImage(image, for: .normal)
        addNoteButton.tintColor = .black
        let highlightImage = image?.withTintColor(.black.withAlphaComponent(0.5), renderingMode:.alwaysOriginal)
        addNoteButton.setImage(highlightImage, for: .highlighted)
    }
    
    /// addActions method
    func addActions() {
        addNoteButton.addTarget(self, action: #selector(showAddNoteVC), for: .touchUpInside)
    }

    /// showAddNote VC method
    @objc private func showAddNoteVC() {
        notesViewControllerCoordinator?.runAddNotes()
    }

    /// Pull to refresh method
    @objc private func refreshData() {
        presenter?.fetchData()
        tableView.refreshControl?.endRefreshing()
    }

    /// Date to string method
    func formattedDateString(format: String, date: Date?) -> String? {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let stringData = formatter.string (from: date)
        
        return stringData
    }
    
    /// Get Image method
    func getImage(from date: Date?) -> String {
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
            return "1"
        }
    }
}

// MARK: - TableView DataSource

extension NotesViewController: UITableViewDataSource {
    
    /// Number Of Rows In Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfNotes() ?? 0
    }
    
    /// Настраиваем ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let note = presenter?.note(at: indexPath) else { return UITableViewCell() }
        let time = formattedDateString(format: "dd.MM.yyyy", date: note.date)

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .white
        
        var content = cell.defaultContentConfiguration()
        
        content.text = note.title
        content.textProperties.numberOfLines = 1
        content.textProperties.font = .boldSystemFont(ofSize: 17)
        
        content.secondaryText = "\(time ?? "")  \(note.text ?? "")"
        content.secondaryTextProperties.numberOfLines = 1
        content.secondaryTextProperties.color = .gray
        
        let image = getImage(from: note.date)
        content.image = UIImage(named: image)
        
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - TableView Delegate

extension NotesViewController: UITableViewDelegate {
    
    /// Note editing method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddNoteViewController()
        vc.note = presenter?.note(at: indexPath)
        vc.textView.text = presenter?.note(at: indexPath).text
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// Note deleting method with notes count update
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            presenter?.deleteNote(at: indexPath)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            updateNotesCounterLabel()
        }
    }
    
    /// Table View row height method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

// MARK: - Notes ViewController Protocol

extension NotesViewController: NotesViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateNotesCounterLabel() {
        let notesCount = presenter?.numberOfNotes() ?? 0
        notesCounterLabel.text = notesCount <= 1 ? "\(notesCount) note" : "\(notesCount) notes"
    }
    
    func deleteRow(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func showAddNoteView() {
        presenter?.addNoteButtonTapped()
    }
}
