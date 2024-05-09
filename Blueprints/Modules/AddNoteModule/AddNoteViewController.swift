//
//  AddNoteViewController.swift
//  Blueprints
//
//  Created by Эльдар Абдуллин on 07.05.2024.
//

import UIKit
import SnapKit

// MARK: - AddNote ViewController Protocol

protocol AddNoteViewControllerProtocol: AnyObject {}

// MARK: - AddNote ViewController

final class AddNoteViewController: UIViewController {

    // MARK: - Public properties

    weak var addNoteViewControllerCoordinator: AddNoteViewControllerCoordinator?
    var presenter: AddNotePresenterProtocol?

    let textView = UITextView()

    var note: Note?

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private methods

private extension AddNoteViewController {
    func setupView() {
        addSubviews()
        disableAutoresizingMask()
        setConstraints()



        setupProperties()
        setupUI()
        setColor()
    }
}

private extension AddNoteViewController {
    func addSubviews() {
        view.addSubviews(textView)
    }

    func disableAutoresizingMask() {
        view.disableAutoresizingMask(textView)
    }

    func setConstraints() {
        textView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
    }


    func setupUI() {
        title = "New note"
        view.backgroundColor = .systemGray6

        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNote))
        navigationItem.rightBarButtonItem = saveButton

        view.addSubview(textView)

        textView.delegate = self

        textView.translatesAutoresizingMaskIntoConstraints = false
    }


    @objc func saveNote() {
        presenter?.save(text: textView.text, ofNote: note)
    }


    ///Метод настройки subview
    func setupProperties() {
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.tintColor = UIColor(red: 24/255, green: 67/255, blue: 103/255, alpha: 1)
        textView.backgroundColor = .systemGray6
    }



    func setColor() {
        guard let saveButton = navigationItem.rightBarButtonItem else { return }
        saveButton.tintColor = !textView.text.isEmpty ? .white : .white.withAlphaComponent(0.5)
        saveButton.isEnabled = !textView.text.isEmpty ? true : false
    }
}

// MARK: - Text ViewDelegate

extension AddNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        setColor()
    }
}

extension AddNoteViewController: AddNoteViewControllerProtocol {}
