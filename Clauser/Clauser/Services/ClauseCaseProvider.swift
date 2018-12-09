//
//  ClauseCaseProvider.swift
//  Clauser
//
//  Created by Olexa Boyko on 12/8/18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Foundation

class ClauseCase: Codable {
	var id: Int?
	var clauseId: Int
	var name: String
	var info: String
	var author: String

	init(id: Int, clauseId: Int, name: String, info: String, author: String) {
		self.id = id
		self.clauseId = clauseId
		self.name = name
		self.info = info
		self.author = author
	}
}

class ClauseCaseProvider {

	public static var shared = ClauseCaseProvider()
	private let service = ClauseService()

	private(set) var currentClausesCases: [ClauseCase] = []

	public func subscribeForUpdates(_ subscriber: PSSubscriber) {
		PSPublisher.default.subscribe(subscriber: subscriber, messageKey: messageKey)
	}

	public func loadClauseCases() {

		service.getClauseCases { (clauseCases) in
			self.currentClausesCases = clauseCases
			PSPublisher.default.publish(self)
		}
	}

	public func addClauseCase(_ clauseCase: ClauseCase) {
		currentClausesCases.append(clauseCase)
		PSPublisher.default.publish(self)
	}

}

extension ClauseCaseProvider: PSMessage {
	var messageKey: PSMessageKey {
		return "ClauseCaseProviderDidUpdate"
	}
}
