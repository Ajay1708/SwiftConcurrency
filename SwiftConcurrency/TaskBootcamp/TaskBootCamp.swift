//
//  TaskBootCamp.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 12/02/24.
//

import SwiftUI

struct TaskBootCamp: View {
    @StateObject var vm = TaskBootCampViewModel()
    @State private var fetchImage1Task: Task<(), Never>? = nil
    @State private var fetchImage2Task: Task<(), Never>? = nil
    var body: some View {
        VStack {
            if let image1 = vm.image1 {
                Image(uiImage: image1)
            }
            if let image2 = vm.image2 {
                Image(uiImage: image2)
            }
        }
        .onAppear {
            // To execute multiple async functions parallely you can multiple Tasks
            fetchImage1Task = Task {
                await vm.fetchImage1()
            }
            fetchImage2Task = Task {
                await vm.fetchImage2()
            }
            
            // Tasks have different priorities
            // userInitiated is the highest priority
            // background is the least priority
            // The order of execution of tasks is not guaranteed based on priority
            
            Task(priority: .high) {
                // It suspends current task and allows other tasks to execute
                // A task can voluntarily suspend itself in the middle of a long-running operation that doesn’t contain any suspension points, to let other tasks run for a while before execution returns to this task.
                await Task.yield()
                print("Task 1 : \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .userInitiated) {
                print("Task 2 : \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .medium) {
                print("Task 3 : \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .low) {
                print("Task 4 : \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .utility) {
                print("Task 5 : \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .background) {
                print("Task 6 : \(Thread.current) : \(Task.currentPriority)")
            }
             
            // If you use nested task. Child task will inherit basically all of the meta data from parent task
            Task(priority: .low) {
                // If you don't want the child task to inherit parent task priority then you can either explicitly mention the priority or use detached
                // Don't use detached
                Task.detached {
                    
                }
                Task {
                    // Inner task will also have the same low priority
                }
            }
        }
        .onDisappear {
            // Just because you cancel a task doesn't mean that it immediately stops running the async operations inside task
            fetchImage1Task?.cancel()
            fetchImage2Task?.cancel()
        }
        .task {
            // task opens us into an asynchronous context while onappears opens us into a synchronous context
            // .task modifier is introduced in iOS 15
            // Adds an async task to perform before this view appears
            // Default priority is userInitiated
            // SwiftUI will automatically cancels the task if the view disappears before the action completes.
            // If you have a long task that is gonna take a long time to complete it might still continue doing some of those processes before it actually cancels
            // For example i have an async sequence inside an async function. Although the task could be cancelled the work in this task is still continuing. So the solution is occasionally in your code check for cancellation using Task.checkCancellation() which is a throwable function so if the task is cancelled it will throw an error
            await vm.fetchImage1()
        }
    }
}

#Preview {
    TaskBootCamp()
}

