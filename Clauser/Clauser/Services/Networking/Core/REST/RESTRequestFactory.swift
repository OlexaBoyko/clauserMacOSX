//
//  RESTRequestFactory.swift
//  NetworkingCore
//
//  Created by Olexa Boyko on 21.10.18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Foundation

final class RESTRequestFactory {

	internal var defaultRequestHeaders: [String: String] {
		return ["Content-Type": "application/json"]
	}

	public func createRequest(path: String,
							  type: RESTRequestType,
							  additionalHeaders: RESTAdditionalHeaders? = nil) -> RESTRequest {

		var headers = defaultRequestHeaders
		if let additionalHeaders = additionalHeaders {
			headers.update(additionalHeaders)
		}

		switch type {
		case .get(let params, let entityId):
			return RESTGetRequest(path: path,
								  headers: headers,
								  parameters: params,
                                  entityId: entityId)
		case .post(let body):
			return RESTPostRequest(path: path,
								   headers: headers,
								   body: body)
        case .put(let body):
            return RESTPutRequest(path: path,
                                   headers: headers,
                                   body: body)
        }
	}
}

fileprivate extension Dictionary {
	mutating func update(_ other: Dictionary) {
		for (key,value) in other {
			self.updateValue(value, forKey: key)
		}
	}
}
