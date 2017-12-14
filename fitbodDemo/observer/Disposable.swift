//
//  Observer.swift
//  fitbodDemo
//
//  Created by Cristian Holdunu on 14/12/2017.
//  Copyright © 2017 Hold1. All rights reserved.
//

import Foundation

class Disposable<T> :NSObject{
    var subject: Subject<T>
    var accept: (T?) -> Void
    var error: (Error) -> Void
    
    init(subject: Subject<T>, accept: @escaping (T?) -> Void, error: @escaping (Error) -> Void) {
        self.subject = subject
        self.accept = accept
        self.error = error
    }
    
    init(subject: Subject<T>, accept: @escaping (T?) -> Void) {
        self.subject = subject
        self.accept = accept
        self.error = { error in
            
        }
    }
    
    public func dispose() {
        self.subject.remove(self)
    }
}
