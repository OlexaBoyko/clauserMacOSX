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

	public static var shared: RootViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

		RootViewController.shared = self
    }

	public func show(page: SplitTableValues) {
		switch page {
		case .addClause:
			addClauseContainerView.isHidden = false
			addClauseCaseContainerView.isHidden = true
		case .addClauseCase:
			addClauseCaseContainerView.isHidden = false
			addClauseContainerView.isHidden = true
		}
	}
}
