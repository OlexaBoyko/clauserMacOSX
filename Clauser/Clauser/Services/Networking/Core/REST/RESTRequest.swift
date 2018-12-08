//
//  RESTRequest.swift
//  NetworkingCore
//
//  Created by Olexa Boyko on 21.10.18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//
import Foundation

/// Abstract successfull response from API Services.
/// - parameter result: Could be specific model or nil, depends on needs.
typealias RESTRequestSuccess = (_ result: Data?)->()
/// Abstract failure response from API Services.
/// - parameter result: Could be specific model or nil, depends on needs.
typealias RESTRequestFailure = (_ error: Error)->()

public enum RESTRequestType {
    case get(params: [String: String] , entityId: String?)
	case post(body: Data)
    case put(body: Data)
}

public enum RESTRequestError: Error {
	case incorrectPath
}

typealias RESTAdditionalHeaders = [String: String]

class RESTRequest {
    internal let path: String
	var headers: [String: String]
    
    var success: RESTRequestSuccess?
    var failure: RESTRequestFailure?
    
    init(path: String,
		 headers: [String: String]) {
        self.path = path
        self.headers = headers
    }

	func urlRequest() throws -> URLRequest {
		guard let url = URL(string: path) else {
			throw RESTRequestError.incorrectPath
		}

		var request = URLRequest(url: url)
		request.allHTTPHeaderFields = headers

		return request
	}
}

class RESTGetRequest: RESTRequest {

	init(path: String,
		 headers: [String: String],
		 parameters: [String: String],
         entityId: String? = nil) {
        
        var finalPath = path
        
        if !parameters.isEmpty {
            var parametersString = ""
            
            for (key, value) in parameters {
                parametersString += "&\(key)=\(value)"
            }
            
            parametersString = String(parametersString.dropFirst())
            
            finalPath = path + "/\(parametersString)"
        }

        
        if let entityId = entityId {
            finalPath += "/\(entityId)"
        }

		super.init(path: finalPath,
				   headers: headers)
	}
    

	override func urlRequest() throws -> URLRequest {
		var request = try super.urlRequest()

		request.httpMethod = "GET"

		return request
	}
}

class RESTPostRequest: RESTRequest {
	var body: Data

	init(path: String,
		 headers: [String: String],
		 body: Data) {

		self.body = body

		super.init(path: path,
				   headers: headers)
	}

	override func urlRequest() throws -> URLRequest {
		var request = try super.urlRequest()

		request.httpMethod = "POST"
		request.httpBody = body

		return request
	}
}

class RESTPutRequest: RESTRequest {
    var body: Data
    
    init(path: String,
         headers: [String: String],
         body: Data) {
        
        self.body = body
        
        super.init(path: path,
                   headers: headers)
    }
    
    override func urlRequest() throws -> URLRequest {
        var request = try super.urlRequest()
        
        request.httpMethod = "PUT"
        request.httpBody = body
        
        return request
    }
}
