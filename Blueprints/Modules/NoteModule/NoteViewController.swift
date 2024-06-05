//
//  NoteViewController.swift
//  Blueprints
//
//  Created by Eldar Abdullin on 07.05.2024.
//  Copyright © 2024 Eldar Abdullin. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Note view controller protocol

/// Protocol defining methods to be implemented by the note view controller.
protocol NoteViewControllerProtocol: AnyObject {

    /// Saves current new note.
    func save(note: Note)
}

// MARK: - Note view controller

/// View controller responsible for displaying and editing a single note.
final class NoteViewController: UIViewController {
    
    // MARK: - Public properties
    
    /// Coordinator responsible for navigation from the note view controller.
    weak var noteViewControllerCoordinator: NoteViewControllerCoordinator?
    
    /// Presenter for the note view controller.
    var presenter: NotePresenterProtocol?

    // MARK: - Private properties
    
    /// Text view for displaying/editing the note text.
    private let textView = UITextView()

    /// The note to display/edit.
    private var note: Note?

    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidDisappear(_ animated: Bool) {
        finish()
    }

    // MARK: - Initializers
    
    /// Initializes the note view controller with a note.
    /// - Parameter note: The note to display/edit.
    init(note: Note?) {
        self.note = note
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    /// Sets up the view hierarchy and appearance.
    private func setupViews() {
        addSubviews()
        disableAutoresizingMask()
        setConstraints()
        
        setupView()
        setupTextView()
        setupSaveButton()
        setupSaveButtonState()
    }
    
    /// Saves the note when the save button is tapped.
    @objc private func saveNote() {
        presenter?.save(text: textView.text, ofNote: note)
    }

    /// Removes map coordinator from array of coordinators
    private func finish() {
        noteViewControllerCoordinator?.finish()
    }
}

// MARK: Setup layout methods

private extension NoteViewController {
    
    /// Adds subviews to the view hierarchy.
    func addSubviews() {
        view.addSubviews(textView)
    }
    
    /// Disables autoresizing mask translation for subviews.
    func disableAutoresizingMask() {
        view.disableAutoresizingMask(textView)
    }
    
    /// Sets up constraints for subviews.
    func setConstraints() {
        textView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
    }
}

// MARK: Setup views methods

private extension NoteViewController {
    
    /// Sets up appearance of the view.
    func setupView() {
        title = TextConstants.noteTitle
        view.backgroundColor = .systemGray6
    }
    
    /// Sets up appearance and behavior of the text view.
    func setupTextView() {
        textView.text = note?.text
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.tintColor = .customBlue
        textView.backgroundColor = .systemGray6
        
        textView.delegate = self
    }
    
    /// Sets up the save button in the navigation bar.
    func setupSaveButton() {
        let saveButton = UIBarButtonItem(
            title: TextConstants.saveButtonTitle,
            style: .done,
            target: self,
            action: #selector(
                saveNote
            )
        )
        navigationItem.rightBarButtonItem = saveButton
    }
    
    /// Sets up the state of the save button based on text input.
    func setupSaveButtonState() {
        guard let saveButton = navigationItem.rightBarButtonItem else { return }
        saveButton.tintColor = !textView.text.isEmpty ? .white : .white.withAlphaComponent(0.5)
        saveButton.isEnabled = !textView.text.isEmpty ? true : false
    }
}

// MARK: - TextView delegate methods

extension NoteViewController: UITextViewDelegate {
    
    /// Notifies the view controller when the text in the text view is changed.
    func textViewDidChange(_ textView: UITextView) {
        setupSaveButtonState()
    }
}

// MARK: - Note view controller protocol methods

extension NoteViewController: NoteViewControllerProtocol {
    func save(note: Note) {
        self.note = note
    }
}
