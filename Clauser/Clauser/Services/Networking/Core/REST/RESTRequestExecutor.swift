//
//  RESTRequestExecutor.swift
//  NetworkingCore
//
//  Created by Olexa Boyko on 21.10.18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Foundation

protocol RESTRequestExecutor {
	func execute(request: RESTRequest)
}

class RESTDefaultRequestExecutor: RESTRequestExecutor {

	private var networkingQueueManager = NetworkingQueueManager()
	private var configuration: URLSessionConfiguration {
		return URLSessionConfiguration.default
	}
	private lazy var session = URLSession(configuration: configuration)

	func execute(request: RESTRequest) {

		networkingQueueManager.dispatch(request: request) { request in
			do {
				let urlRequest = try request.urlRequest()
				self.session.dataTask(with: urlRequest) { (data, urlResponse, error) in
					if let error = error {
						request.failure?(error)
						return
					}

					request.success?(data)
				}.resume()
			} catch {
				request.failure?(error)
			}
		}

	}
}
