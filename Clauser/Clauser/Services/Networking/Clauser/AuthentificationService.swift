//
//  AuthentificationService.swift
//  NetworkingCore
//
//  Created by Olexa Boyko on 21.10.18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Foundation

class AuthentificationService {

	enum AuthentificationServiceError: Error {
		case authentificationServiceDoesNotExist
	}

	private var factory = RESTRequestFactory()
	private var executor = RESTDefaultRequestExecutor()
	private var baseUrl = "http://104.248.136.56:8080/api/"
    
    public func logIn(phone: String,
                      password: String,
                      success: RESTRequestSuccess?,
                      failure: RESTRequestFailure?){
        struct Body: Codable {
            let phone: String
            let password: String
        }
        
        let body = Body(phone: phone,
                        password: password)
        
        let httpBody = try! JSONEncoder().encode(body)
        
        let request = factory.createRequest(path: baseUrl + "login",
                                            type: RESTRequestType.post(body: httpBody))
        
        
        request.success = success
        request.failure = failure
        
        executor.execute(request: request)
    }
	public func sendCode(phone: String,
						 success: RESTRequestSuccess?,
						 failure: RESTRequestFailure?) {

		register(with: phone) { [weak self] in
			guard let strongSelf = self else {
				failure?(AuthentificationServiceError.authentificationServiceDoesNotExist)
				return
			}

			strongSelf.sendOtp(phone: phone,
							   success: success,
							   failure: failure)

		}

	}

	private func sendOtp(phone: String,
						 success: RESTRequestSuccess?,
						 failure: RESTRequestFailure?) {
		struct Body: Codable {
			let phone: String
		}

		let body = Body(phone: phone)

		let httpBody = try! JSONEncoder().encode(body)

		let request = factory.createRequest(path: baseUrl + "send_code",
											type: RESTRequestType.post(body: httpBody))

		request.success = success
		request.failure = failure

		executor.execute(request: request)
	}

	private func register(with phone: String,
						  completion: @escaping () -> Void) {

		struct Body: Codable {
			let phone: String
			let email: String
			let password: String
			let langKey: String
		}

		let body = Body(phone: phone,
						email: phone + "@gelo.com",
						password: "default",
						langKey: "en")

		let httpBody = try! JSONEncoder().encode(body)

		let request = factory.createRequest(path: baseUrl + "register",
											type: RESTRequestType.post(body: httpBody))

		request.success = {data in
			completion()
		}

		request.failure = {error in
			completion()
		}

		executor.execute(request: request)
	}
}
