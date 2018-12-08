//
//  AddClauseViewController.swift
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

class AddClauseCaseViewController: NSViewController {
	@IBOutlet weak var clauseSelectionButton: NSPopUpButton!
	@IBOutlet weak var authorTextField: NSTextField!
	@IBOutlet weak var clauseTextView: NSTextField!
	@IBOutlet weak var commentTextView: NSTextField!

	private var clauses: [Clause] {
		return ClauseProvider.shared.currentClauses
	}

	override func viewDidLoad() {
        super.viewDidLoad()

		ClauseProvider.shared.subscribeForUpdates(self)
		ClauseProvider.shared.loadClauses()
    }

	@IBAction func addClauseButtonPressed(_ sender: NSButton) {
		do {
			try validateData()
			print("success")
		} catch {
			showAlert(forError: error)
		}
	}

	private func validateData() throws {
		if clauseTextView.stringValue.isEmpty {throw ValidationError.noClauseCase}
		if authorTextField.stringValue.isEmpty {throw ValidationError.noAuthor}
		if commentTextView.stringValue.isEmpty {throw ValidationError.noComment}

		if clauseSelectionButton.indexOfSelectedItem == 0 {throw ValidationError.incorrectClauseSelected}
	}

	private func showAlert(forError error: Error) {
		let alert = NSAlert.init()
		alert.messageText = (error as? ValidationError)?.userInfo ?? error.localizedDescription
		alert.addButton(withTitle: "Ok")
		alert.alertStyle = .warning
		alert.beginSheetModal(for: NSApplication.shared.windows.first!, completionHandler: { (_) in

		})
	}
}

extension AddClauseCaseViewController: PSSubscriber {
	func receive(message: PSMessage) {
		clauseSelectionButton.removeAllItems()
		clauseSelectionButton.addItems(withTitles: clauses.map{$0.name})
	}
}
