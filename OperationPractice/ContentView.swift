//
//  ContentView.swift
//  OperationPractice
//
//  Created by 鈴木孝宏 on 2023/01/19.
//

import SwiftUI

struct ContentView: View {
    @State private var maxOperationCount = 2
    @State private var delay: TimeInterval = 3
    @State private var isSuccess = true
    @StateObject private var queueStatus = QueueStatus()

    var body: some View {
        List(queueStatus.operations, id: \.self) { operation in
            if let op = operation as? AfterOperation {
                HStack {
                    Text("\(op.delay)s")

                    Text("\(op.isExecuting ? "Executing" : "Waiting")")

                    if !op.isSuccess {
                        Text("Failed")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                    }

                    if op.isCancelled {
                        Text("Cancelled")
                            .foregroundColor(.teal)
                            .fontWeight(.bold)
                    }
                }
            }
        }

        VStack {
            Text("Operation Count: \(queueStatus.operationCount)")

            Stepper("Max Operation Count", value: $maxOperationCount)
            Text("\(maxOperationCount)")

            Stepper("Delay", value: $delay)
            Text("\(delay.description)")

            Toggle("Success", isOn: $isSuccess)

            HStack {
                Button("Cancel All") {
                    ExecutionQueue.queue.cancelAllOperations()
                }
                .buttonStyle(.bordered)
                
                Button("Add Queue") {
                    ExecutionQueue.addQueue(delay, isSuccess)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .onAppear {
            queueStatus.startObserve()
        }
        .onChange(of: maxOperationCount) { newValue in
            ExecutionQueue.queue.maxConcurrentOperationCount = newValue
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
