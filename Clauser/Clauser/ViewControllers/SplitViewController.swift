//
//  SplitViewController.swift
//  Clauser
//
//  Created by Olexa Boyko on 12/8/18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Cocoa

class SplitViewController: NSSplitViewController {

	public static var shared = SplitViewController()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
//			self.present(<#T##viewController: NSViewController##NSViewController#>, animator: <#T##NSViewControllerPresentationAnimator#>)
		}
	}


}

