//
//  RootViewController.swift
//  Clauser
//
//  Created by Olexa Boyko on 12/8/18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Cocoa

class RootViewController: NSViewController {

	@IBOutlet weak var addClauseCaseContainerView: NSView!
	@IBOutlet weak var addClauseContainerView: NSView!
	@IBOutlet weak var editClauseContainerView: NSView!
	
	public static var shared: RootViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

		RootViewController.shared = self
		hideAll()
    }

	public func show(page: SplitTableValues) {
		hideAll()
		switch page {
		case .addClause:
			addClauseContainerView.isHidden = false
		case .addClauseCase:
			addClauseCaseContainerView.isHidden = false
		case .editClause:
			editClauseContainerView.isHidden = false
		}
	}

	private func hideAll() {
		addClauseContainerView.isHidden = true
		addClauseCaseContainerView.isHidden = true
		editClauseContainerView.isHidden = true
	}
}
