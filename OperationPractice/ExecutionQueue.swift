//
//  ExecutionQueue.swift
//  OperationPractice
//
//  Created by 鈴木孝宏 on 2023/01/19.
//

import Foundation

class ExecutionQueue {
    static let queue = {
        let q = OperationQueue()
        q.qualityOfService = .userInitiated
        q.maxConcurrentOperationCount = 2
        return q
    }()

    static func addQueue(_ delay: TimeInterval, _ isSuccess: Bool) {
        let op = AfterOperation(delay: delay, isSuccess: isSuccess) { success in
            print("complete: \(success ? "true" : "false")")
            guard success else {
                ExecutionQueue.queue.cancelAllOperations()
                return
            }
        }
        ExecutionQueue.queue.addOperation(op)
    }
}
