//
//  Subject.swift
//  fitbodDemo
//
//  Created by Cristian Holdunu on 14/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import Foundation

class Subject<T> :NSObject{
  
    fileprivate var subscribtions = [Disposable<T>]()
    fileprivate var repeatLastValue = true
    
    fileprivate var observedValue: T? {
        didSet {
            for observer in subscribtions {
                DispatchQueue.main.async {
                    observer.accept(self.observedValue!)
                }
            }
        }
    }
    
    public func publish(newValue: T) {
        observedValue = newValue
    }
    
    func subscribe(_ consumer: @escaping (T) -> Void) -> Disposable<T> {
        let disposable = Disposable(subject: self, accept: consumer)
        subscribtions.append(disposable)
        if repeatLastValue, let value = observedValue {
            DispatchQueue.main.async {
                consumer(value)
            }
        }
        return disposable
    }
    
    func remove(_ disposable: Disposable<T>) {
        if let index = subscribtions.index(of: disposable) {
            subscribtions.remove(at: index)
        }
    }
}
