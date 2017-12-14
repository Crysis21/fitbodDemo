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
    
    fileprivate var error: Error?
    
    public func publish(_ newValue: T) {
        observedValue = newValue
    }
    
    public func error(_ error: Error) {
        self.observedValue = nil
        self.error = error
        for observer in subscribtions {
            DispatchQueue.main.async {
                observer.error(error)
            }
        }
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
    
    func subscribe(_ consumer: @escaping (T) -> Void, _ error: @escaping (Error) -> Void) -> Disposable<T> {
        let disposable = Disposable(subject: self, accept: consumer, error: error)
        subscribtions.append(disposable)
        if repeatLastValue {
            if let value = observedValue {
                DispatchQueue.main.async {
                    consumer(value)
                }
            } else if let er = self.error {
                error(er)
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
