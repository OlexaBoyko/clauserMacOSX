//
//  AddClauseViewController.swift
//  Clauser
//
//  Created by Olexa Boyko on 12/8/18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Cocoa

fileprivate enum ValidationError: Error {
	case noClause
	case noComment

	var userInfo: String {
		switch self {
		case .noClause:
			return "Enter your clause!"
		case .noComment:
			return "Enter your comment"
		}
	}
}

class AddClauseViewController: NSViewController {

	@IBOutlet weak var clauseName: NSTextField!
	@IBOutlet var clauseTextView: NSTextView!

	override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
	@IBAction func addClauseButtonPressed(_ sender: NSButton) {
		do {
			try validateData()
			let clause = Clause.init(id: ClauseProvider.shared.currentClauses.count + 1,
									 name: clauseName.stringValue,
									 info: clauseTextView.string)
			ClauseProvider.shared.addClause(clause)
			print("success")
		} catch {
			showAlert(forError: error)
		}
	}

	private func validateData() throws {
		if clauseName.stringValue.isEmpty {throw ValidationError.noClause}
		if clauseTextView.textStorage?.string.isEmpty ?? true {throw ValidationError.noComment}
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
