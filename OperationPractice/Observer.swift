//
//  Observer.swift
//  OperationPractice
//
//  Created by 鈴木孝宏 on 2023/01/19.
//

import Foundation

class QueueStatus: NSObject, ObservableObject {
    @Published var operationCount = 0
    @Published var operations = [Operation]()

    private var countKVO: NSKeyValueObservation?
    private var opsKVO: NSKeyValueObservation?

    func startObserve() {
        countKVO = ExecutionQueue.queue.observe(\.operationCount, options: [.new], changeHandler: { q, change in
            DispatchQueue.main.async { [unowned self] in
                operationCount = change.newValue ?? 0
            }
        })

        opsKVO = ExecutionQueue.queue.observe(\.operations, options: [.new], changeHandler: { q, change in
            DispatchQueue.main.async { [unowned self] in
                operations = change.newValue ?? []
            }
        })
    }
}
