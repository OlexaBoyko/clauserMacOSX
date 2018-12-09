//
//  ClauseProvider.swift
//  Clauser
//
//  Created by Olexa Boyko on 12/8/18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Foundation

class Clause: Codable {
	var id: Int?
	var name: String
	var info: String

	init(id: Int, name: String, info: String) {
		self.id = id
		self.name = name
		self.info = info
	}
}

class ClauseProvider {
	public static var shared = ClauseProvider()
	private var service = ClauseService()
	private(set) var currentClauses: [Clause] = []

	public func subscribeForUpdates(_ subscriber: PSSubscriber) {
		PSPublisher.default.subscribe(subscriber: subscriber, messageKey: messageKey)
	}

	public func loadClauses() {
		service.getClauses {(clauses) in
			self.currentClauses = clauses
			PSPublisher.default.publish(self)
		}
	}

	public func addClause(_ clause: Clause) {
		currentClauses.append(clause)
		PSPublisher.default.publish(self)
	}
}

extension ClauseProvider: PSMessage {
	var messageKey: PSMessageKey {
		return "ClauseProviderDidUpdate"
	}
}
