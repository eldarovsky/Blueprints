//
//  AddNoteViewController.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 07.05.2024.
//

import UIKit

final class AddNoteViewController: UIViewController {

    // MARK: - Properties

    let textView = UITextView()
    var note: Note?
    weak var addNoteViewControllerCoordinator: AddNoteViewControllerCoordinator?


    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupUI()
        setupConstraints()
    }

    // MARK: - Private methods

    @objc private func saveNote() {
        let text = textView.text ?? ""
        let lines = text.components(separatedBy: "\n")
        guard let title = lines.first else { return }
        let fullText = lines.joined(separator: " ")
        guard !fullText.isEmpty else { return }

        if let existingNote = note {
            StorageManager.shared.update(note: existingNote, title: title, text: fullText)
        } else {
            StorageManager.shared.create(title: title, text: fullText)
        }
    }



    /// Метод настройки view
    private func setupUI() {

        title = "New note"
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.backgroundColor = .systemGray6

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
        navigationItem.rightBarButtonItem?.tintColor = .white

        view.addSubview(textView)

        textView.delegate = self

        textView.translatesAutoresizingMaskIntoConstraints = false
    }

    ///Метод настройки subview
    private func setupProperties() {

        ///Выставляем размер шрифта
        textView.font = UIFont.systemFont(ofSize: 17)

        ///Меняем цвет курсора
        textView.tintColor = .black

        textView.backgroundColor = .systemGray6
    }

    ///Метод установки констрейнтов
    private func setupConstraints() {
        NSLayoutConstraint.activate([

            ///TextView
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITextViewDelegate - Placeholder

extension AddNoteViewController: UITextViewDelegate {}
