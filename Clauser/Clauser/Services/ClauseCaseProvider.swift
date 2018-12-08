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

	init() {
		id = 1
		clauseId = 1
		name = "Тестовий кейс"
		info = "тестова інформація"
	}
}

class ClauseCaseProvider {

	public static var shared = ClauseCaseProvider()
	private let service = ClauseService()

	var currentClausesCases: [ClauseCase] = []

	public func subscribeForUpdates(_ subscriber: PSSubscriber) {
		PSPublisher.default.subscribe(subscriber: subscriber, messageKey: messageKey)
	}

	public func loadClauseCases() {

		service.getClauseCases { (clauseCases) in
			self.currentClausesCases = clauseCases
			PSPublisher.default.publish(self)
		}
	}

}

extension ClauseCaseProvider: PSMessage {
	var messageKey: PSMessageKey {
		return "ClauseCaseProviderDidUpdate"
	}
}
