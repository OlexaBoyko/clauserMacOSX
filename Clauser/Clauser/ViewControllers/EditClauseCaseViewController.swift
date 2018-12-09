//
//  EditClauseCaseViewController.swift
//  Clauser
//
//  Created by Olexa Boyko on 12/8/18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Cocoa

fileprivate enum ValidationError: Error {
	case incorrectClauseSelected
	case noClauseCase
	case noComment
	case noAuthor

	var userInfo: String {
		switch self {
		case .incorrectClauseSelected:
			return "You have not selected theme"
		case .noClauseCase:
			return "Enter your clause case!"
		case .noAuthor:
			return "Enter author name"
		case .noComment:
			return "Enter your comment"
		}
	}
}

class EditClauseCaseViewController: NSViewController {
	@IBOutlet weak var clauseSelectionButton: NSPopUpButton!
	@IBOutlet weak var clauseCaseSelectionButton: NSPopUpButton!
	@IBOutlet weak var authorTextField: NSTextField!
	@IBOutlet var clauseTextView: NSTextView!
	@IBOutlet var commentTextView: NSTextView!

	private var clauses: [Clause] {
		return ClauseProvider.shared.currentClauses
	}

	private var clauseCases: [ClauseCase] {
		return ClauseCaseProvider.shared.currentClausesCases
	}

	private var filteredClauseCases: [ClauseCase] = []

	private var currentClauseCase: ClauseCase?

	override func viewDidLoad() {
		super.viewDidLoad()

		ClauseProvider.shared.subscribeForUpdates(self)
		ClauseCaseProvider.shared.subscribeForUpdates(self)

		ClauseProvider.shared.loadClauses()
		ClauseCaseProvider.shared.loadClauseCases()
	}

	@IBAction func editClauseCaseButtonPressed(_ sender: NSButton) {
		do {
			try validateData()
			currentClauseCase?.author = authorTextField.stringValue
			currentClauseCase?.info = commentTextView.string
			currentClauseCase?.name = clauseTextView.string
			print("success")
		} catch {
			showAlert(forError: error)
		}
	}

	private func validateData() throws {
		if clauseTextView.string.isEmpty {throw ValidationError.noClauseCase}
		if authorTextField.stringValue.isEmpty {throw ValidationError.noAuthor}
		if commentTextView.string.isEmpty {throw ValidationError.noComment}
	}

	private func showAlert(forError error: Error) {
		let alert = NSAlert.init()
		alert.messageText = (error as? ValidationError)?.userInfo ?? error.localizedDescription
		alert.addButton(withTitle: "Ok")
		alert.alertStyle = .warning
		alert.beginSheetModal(for: NSApplication.shared.windows.first!, completionHandler: { (_) in

		})
	}

	private func reloadClauseCases() {
		clauseCaseSelectionButton.removeAllItems()
		if clauseSelectionButton.indexOfSelectedItem >= 0 {
			let selectedClause = clauses[clauseSelectionButton.indexOfSelectedItem]
			self.filteredClauseCases = clauseCases.filter({$0.clauseId == selectedClause.id})
			clauseCaseSelectionButton.addItems(withTitles: filteredClauseCases.map {"\($0.id!) \($0.name)"})
			updateViewDueToSelectedClauseCase()
		}
	}

	private func updateViewDueToSelectedClauseCase() {
		if clauseCaseSelectionButton.indexOfSelectedItem >= 0 {
			let selectedClauseCase = filteredClauseCases[clauseCaseSelectionButton.indexOfSelectedItem]
			authorTextField.stringValue = selectedClauseCase.author
			clauseTextView.string = selectedClauseCase.name
			commentTextView.string = selectedClauseCase.info
			self.currentClauseCase = selectedClauseCase
		}
	}

	@IBAction func didUpdateClauseSelection(_ sender: NSPopUpButton) {
		reloadClauseCases()
	}

	@IBAction func didUpdateClauseCaseSelection(_ sender: Any) {
		updateViewDueToSelectedClauseCase()
	}
}

extension EditClauseCaseViewController: PSSubscriber {
	func receive(message: PSMessage) {
		if message.messageKey == ClauseProvider.shared.messageKey {
			clauseSelectionButton.removeAllItems()
			clauseSelectionButton.addItems(withTitles: clauses.map{"\($0.id!) \($0.name)"})
		} else if message.messageKey == ClauseCaseProvider.shared.messageKey {
			reloadClauseCases()
		}
	}
}
