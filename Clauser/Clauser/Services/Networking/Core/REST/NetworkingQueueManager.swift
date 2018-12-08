//
//  NetworkingQueueManager.swift
//  NetworkingCore
//
//  Created by Olexa Boyko on 21.10.18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Foundation

enum NetworkingQueue {
	case concurrent, serial
}

enum QueueExecutionType {
	case async, sync
}

class NetworkingQueueManager {
	private let concurrentQueue = DispatchQueue(label: "concurrent.queue", qos: .background, attributes: .concurrent)
	private let serialQueue = DispatchQueue(label: "serial.queue")

	public func dispatch(request: RESTRequest,
						on queue: NetworkingQueue = .concurrent,
						executionType: QueueExecutionType = .async,
						executiongBlock: @escaping (RESTRequest) -> Void) {
		switch queue {
		case .concurrent:
			switch executionType {
			case .async:
				//                print("-----> Starting \(request.description) request on concurrent queue async")
				concurrentQueue.async {
					executiongBlock(request)
				}
			case .sync:
				//                print("-----> Starting \(request.description) request on concurrent queue sync")
				concurrentQueue.sync {
					executiongBlock(request)
				}
			}
		case .serial:
			switch executionType {
			case .async:
				//                print("-----> Starting \(request.description) request on serial queue async")
				serialQueue.async {
					executiongBlock(request)
				}
			case .sync:
				//                print("-----> Starting \(request.description) request on serial queue sync")
				serialQueue.sync {
					executiongBlock(request)
				}
			}
		}
	}
}
