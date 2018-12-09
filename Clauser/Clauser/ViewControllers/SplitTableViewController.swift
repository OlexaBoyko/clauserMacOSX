//
//  SplitTableViewController.swift
//  Clauser
//
//  Created by Olexa Boyko on 12/8/18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Cocoa

public enum SplitTableValues: String {
	case addClauseCase = "Додати варіант положення"
	case addClause = "Додати положення"
	case editClause = "Змінити варіант положення"
}

class SplitTableViewController: NSViewController {

	private let tableViewData: [SplitTableValues] = [SplitTableValues.addClauseCase,
													 SplitTableValues.addClause,
													 SplitTableValues.editClause]

	@IBOutlet private weak var tableView: NSTableView!
	@IBOutlet private weak var scrollView: NSScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self
    }
    
}

extension SplitTableViewController: NSTableViewDelegate {
	func tableViewSelectionDidChange(_ notification: Notification) {
		if tableView.selectedRow >= 0 {
			RootViewController.shared?.show(page: tableViewData[tableView.selectedRow])
		}
	}
}

extension SplitTableViewController: NSTableViewDataSource {
	func numberOfRows(in tableView: NSTableView) -> Int {
		return tableViewData.count
	}

	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		var result:NSTableCellView
		result  = tableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
		result.textField?.stringValue = tableViewData[row].rawValue
		return result
	}

	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 45
	}
}
