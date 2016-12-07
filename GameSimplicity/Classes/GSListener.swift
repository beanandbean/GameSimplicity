//
//  GSListener.swift
//  Pods
//
//  Created by wangsw on 06/12/2016.
//
//

final public class GSListener {
    
    private let callback: () -> Void
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    public func execute() {
        callback()
    }
    
}
