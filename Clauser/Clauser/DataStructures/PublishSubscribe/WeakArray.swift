//
//  WeakArray.swift
//  Clauser
//
//  Created by Olexa Boyko on 12/8/18.
//  Copyright © 2018 onestepsolutions. All rights reserved.
//

import Foundation

/**
 ## WeakArray
 
 Array which contains weak references to elements
 */

struct WeakArray<T> {
    
    // MARK: - Private properties
    private var array: NSPointerArray
    
    // MARK: - Public properties
    public var count: Int {
        return array.count
    }
    
    // MARK: - Initializers
    public init() {
        array = NSPointerArray.weakObjects()
    }
    
    // MARK: - Public functiones
    public func addObject(_ templateObject: T?) {
        let anyObject = templateObject as AnyObject?
        guard let strongObject = anyObject else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        array.addPointer(pointer)
    }
    
    public func insertObject(_ templateObject: T?, at index: Int) {
        let anyObject = templateObject as AnyObject?
        guard index < count, let strongObject = anyObject else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        array.insertPointer(pointer, at: index)
    }
    
    public func replaceObject(at index: Int, withObject templateObject: T?) {
        let anyObject = templateObject as AnyObject?
        guard index < count, let strongObject = anyObject else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        array.replacePointer(at: index, withPointer: pointer)
    }
    
    public func object(at index: Int) -> T? {
        guard index < count else {return nil}
        guard let pointer = array.pointer(at: index) else {
            array.compact()
            return nil
        }
        return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue() as? T
    }
    
    public func removeObject(at index: Int) {
        guard index < count else { return }
        
        array.removePointer(at: index)
    }
    
    public func compact() {
        array.compact()
    }
    
    public func forEach(_ clojure: ((T) -> Void)) {
        var containsUnretainedObjects = false
        for i in 0..<count {
            if let object = object(at: i) {
                clojure(object)
            } else {
                containsUnretainedObjects = true
            }
        }
        
        if containsUnretainedObjects {
            compact()
        }
    }
}
