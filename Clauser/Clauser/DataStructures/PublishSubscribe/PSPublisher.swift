//
//  PSPublisher.swift
//  Clauser
//
//  Created by Olexa Boyko on 12/8/18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Foundation

public typealias PSMessageKey = String

public protocol PSMessage {
    var messageKey: PSMessageKey {get}
}
public protocol PSSubscriber: AnyObject {
    func receive(message: PSMessage)
}

/**
 ## PSPublisher
 
 Implementation of Publish-Subscribe pattern
 
 Call `publish(_:)` function when you want to publish the message

 */

open class PSPublisher {
    
    public static var `default` = PSPublisher()
    
    private var subscribers: Dictionary<PSMessageKey, WeakArray<PSSubscriber>> = [:]
    
    public func subscribe(subscriber: PSSubscriber, messageKey: PSMessageKey) {
        if subscribers[messageKey] == nil
        {
            subscribers[messageKey] = WeakArray()
        }
        subscribers[messageKey]!.addObject(subscriber)
    }
    
    public func publish(_ message: PSMessage) {
        if let subscribers = subscribers[message.messageKey]
        {
            subscribers.forEach { (subscriber) in
                subscriber.receive(message: message)
            }
        }
    }
}
