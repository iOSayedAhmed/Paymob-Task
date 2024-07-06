//
//  NSObject+Extension.swift
//  Paymob-Task
//
//  Created by iOSAYed on 06/07/2024.
//

import Foundation

public extension NSObject {
    var className: String {
        String(describing: type(of: self))
    }

    class var className: String {
        String(describing: self)
    }
}
