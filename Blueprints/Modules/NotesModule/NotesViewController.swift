//
//  NotesViewController.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 07.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Notes view controller protocol

/// Protocol defining methods to be implemented by the notes view controller.
protocol NotesViewControllerProtocol: AnyObject {
    
    /// Reloads data in the table view.
    func reloadData()
    
    /// Updates the label displaying the count of notes.
    func updateNotesCounterLabel()
    
    /// Deletes a row at the specified index path.
    /// - Parameter indexPath: The index path of the row to delete.
    func deleteRow(at indexPath: IndexPath)
}

// MARK: - Notes view controller

/// View controller responsible for displaying notes.
final class NotesViewController: UIViewController {
    
    // MARK: - Public properties
    
    /// Coordinator responsible for navigation from the notes view controller.
    weak var notesViewControllerCoordinator: NotesViewControllerCoordinator?
    
    /// Presenter for the notes view controller.
    var presenter: NotesPresenterProtocol?
    
    // MARK: - Private properties
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let refreshControl = UIRefreshControl()
    private let footerView = UIView()
    private let notesCounterLabel = UILabel()
    private let noteButton = UIButton()
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.fetchNotes()
        updateNotesCounterLabel()
    }
    
    // MARK: - Private methods
    
    /// Sets up the views hierarchy and appearance.
    func setupViews() {
        addSubviews()
        disableAutoresizingMask()
        setConstraints()
        
        setupView()
        setupNavigationBar()
        setupTableView()
        setupRefreshControl()
        setupNoteButton()
        
        addActions()
    }
    
    /// Shows the add note view controller.
    @objc private func showNoteVC() {
        notesViewControllerCoordinator?.runNote()
    }
    
    /// Refreshes data by fetching notes from the presenter.
    @objc private func refreshData() {
        presenter?.fetchNotes()
        tableView.refreshControl?.endRefreshing()
    }
    
    /// Formats date to a string.
    /// - Parameters:
    ///   - format: The format string for the date.
    ///   - date: The date to format.
    /// - Returns: The formatted date string.
    func formattedDateString(format: String, date: Date?) -> String? {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let stringData = formatter.string (from: date)
        
        return stringData
    }
    
    /// Determines image name based on the hour of the day.
    /// - Parameter date: The date for which to determine the image.
    /// - Returns: The image name.
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

// MARK: Setup layout methods

private extension NotesViewController {
    
    /// Adds subviews to the view hierarchy.
    func addSubviews() {
        view.addSubviews(
            tableView,
            footerView,
            notesCounterLabel,
            noteButton
        )
    }
    
    /// Disables autoresizing mask translation for subviews.
    func disableAutoresizingMask() {
        view.disableAutoresizingMask(
            tableView,
            footerView,
            notesCounterLabel,
            noteButton
        )
    }
    
    /// Sets up constraints for subviews.
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
        
        noteButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(footerView.snp.top).offset(20)
            make.trailing.equalTo(footerView.snp.trailing).offset(-30)
        }
    }
}

// MARK: Setup views methods

private extension NotesViewController {
    
    /// Sets up appearance of the view.
    func setupView() {
        tableView.backgroundColor = .systemGray6
        footerView.backgroundColor = .systemGray6
    }
    
    /// Sets up appearance of the navigation bar.
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        title = TextConstants.notesTitle
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)
        ]
        
        appearance.backgroundColor = .customBlue
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: TextConstants.backButtonTitle, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    /// Sets up the table view.
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.refreshControl = refreshControl
    }
    
    /// Sets up the refresh control.
    func setupRefreshControl() {
        refreshControl.tintColor = .white
        refreshControl.backgroundColor = .customBlue
        
        let attributedTitle = NSAttributedString(
            string: TextConstants.refreshTitle,
            attributes: [.foregroundColor: UIColor.white]
        )
        
        refreshControl.attributedTitle = attributedTitle
    }
    
    /// Sets up the add note button appearance and actions.
    func setupNoteButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 17)
        let image = UIImage(systemName: TextConstants.noteButtonImageName, withConfiguration: config)
        noteButton.setImage(image, for: .normal)
        noteButton.tintColor = .black
        let highlightImage = image?.withTintColor(.black.withAlphaComponent(0.5), renderingMode:.alwaysOriginal)
        noteButton.setImage(highlightImage, for: .highlighted)
    }
    
    /// Adds actions for buttons.
    func addActions() {
        noteButton.addTarget(self, action: #selector(showNoteVC), for: .touchUpInside)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
}

// MARK: - TableView data source methods

extension NotesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfNotes() ?? 0
    }
    
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

// MARK: - TableView delegate methods

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let note = presenter?.note(at: indexPath) else { return }
        let vc = NoteViewController(note: note)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteNote(at: indexPath)
            updateNotesCounterLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

// MARK: - Notes view controller protocol methods

extension NotesViewController: NotesViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }
    
    func updateNotesCounterLabel() {
        notesCounterLabel.text = presenter?.updateNotesCounterLabel()
    }
    
    func deleteRow(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
