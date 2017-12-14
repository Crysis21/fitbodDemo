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
    var accept: (T) -> Void
    
    init(subject: Subject<T>, accept: @escaping (T) -> Void) {
        self.subject = subject
        self.accept = accept
    }
    
    public func dispose() {
        self.subject.remove(self)
    }
}
