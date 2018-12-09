//
//  UserInfoService.swift
//  Gelo
//
//  Created by Володимр Ільків on 10/22/18.
//  Copyright © 2018 OleksaBoiko. All rights reserved.
//

import Foundation
class ClauseService {
    
    private var factory = RESTRequestFactory()
    private var executor = RESTDefaultRequestExecutor()
    private var baseUrl = "http://104.248.136.56:8080/api/"

	func getClauses(completion: (([Clause]) -> Void)?) {
		DispatchQueue.main.async {
			completion?(MockData.clauses)
		}
	}

	func getClauseCases(completion: (([ClauseCase]) -> Void)?) {
		DispatchQueue.main.async {
			completion?(MockData.clauseCases)
		}
	}

	func postClause() {
		
	}

    func getUserInfo(phone : String,success: RESTRequestSuccess?,
                                    failure: RESTRequestFailure?){
        
        let token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIzODA2Nzc1MTA2OTYiLCJhdXRoIjoiUk9MRV9VU0VSIiwiZXhwIjoxNTQwNTQ2NTU5fQ.gHxQfupV6k-Tivz0v2f92st42jHeVkrsHgKgFXzLzcNBUWu6_OIBI9wL7TJz0oXnO5--Y9brYpYnLZfp4C33ag"
        let request = factory.createRequest(path: baseUrl + "users", type: .get(params: [:], entityId: phone), additionalHeaders: ["Authorization" : "Bearer " + token])
        
        
        request.success = success
        request.failure = failure

        executor.execute(request: request)
    }
}
