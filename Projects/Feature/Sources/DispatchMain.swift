//
//  DispatchMain.swift
//  Feature
//
//  Created by 이범준 on 4/19/24.
//

import Foundation

final class DispatchMain {
    static func async(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }
}
