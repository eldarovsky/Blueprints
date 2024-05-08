//
//  AddNoteViewController.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 07.05.2024.
//

import UIKit
import SnapKit

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
        setColor()
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
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
        navigationItem.rightBarButtonItem = saveButton
        
        view.addSubview(textView)
        
        textView.delegate = self
        
        textView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    ///Метод настройки subview
    private func setupProperties() {
        
        ///Выставляем размер шрифта
        textView.font = UIFont.systemFont(ofSize: 17)
        
        ///Меняем цвет курсора
        textView.tintColor = UIColor(red: 24/255, green: 67/255, blue: 103/255, alpha: 1)

        textView.backgroundColor = .systemGray6
    }
    
    ///Метод установки констрейнтов
    private func setupConstraints() {
        textView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
    }
    
    private func setColor() {
        guard let saveButton = navigationItem.rightBarButtonItem else { return }
        saveButton.tintColor = !textView.text.isEmpty ? .white : .white.withAlphaComponent(0.5)
        saveButton.isEnabled = !textView.text.isEmpty ? true : false
    }
}

// MARK: - UITextViewDelegate - Placeholder

extension AddNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        setColor()
    }
}
