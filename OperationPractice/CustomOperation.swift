//
//  CustomOperation.swift
//  OperationPractice
//
//  Created by 鈴木孝宏 on 2023/01/19.
//

import Foundation
import UniformTypeIdentifiers

class AfterOperation: CustomOperation {
    let delay: TimeInterval
    let isSuccess: Bool
    let completion: ((Bool) -> Void)

    init(delay: TimeInterval, isSuccess: Bool, completion: @escaping (Bool) -> Void) {
        self.delay = delay
        self.isSuccess = isSuccess
        self.completion = completion
    }

    deinit {
        print("deinit.")
    }

    override func start() {
        print("start")
        state = .executing

        guard !isCancelled else {
            state = .finished
            return
        }

        print("sleeping")
        Thread.sleep(forTimeInterval: delay)

        completion(isSuccess)
        state = .finished
    }
}

class CustomOperation: Operation {
    enum State {
        case ready
        case executing
        case finished
    }

    fileprivate var state = State.ready {
        didSet {
            switch state {
            case .ready: break
            case .executing:
                isExecuting = true
            case .finished:
                isExecuting = false
                isFinished = true
            }
        }
    }

    fileprivate var _executing: Bool = false
    override var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            if _executing != newValue {
                willChangeValue(for: \Self.isExecuting)
                _executing = newValue
                didChangeValue(for: \Self.isExecuting)
            }
        }
    }

    fileprivate var _finished: Bool = false;
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValue(for: \Self.isFinished)
                _finished = newValue
                didChangeValue(for: \Self.isFinished)
            }
        }
    }
}
