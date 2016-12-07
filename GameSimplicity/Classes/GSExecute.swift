//
//  GSExecute.swift
//  Pods
//
//  Created by wangsw on 07/12/2016.
//
//

public class GSExecute: GSAnimation {
    
    let action: () -> Void
    
    public init(block: @escaping () -> Void) {
        action = block
    }
    
    public override func execute() {
        super.execute()
        action()
        completion()
    }
    
    public override func copy() -> GSAnimation {
        return GSExecute(block: action)
    }
    
}
