# ``SwiftConcurrency``

This project contains detailed explanation of Swift Concurrency which was introduced in Swift 5.5

## Overview

Async await is safer to write asynchronous programming

## Async Properties
Properties can be async for that we need an explicit getter. As of Swift 5.5 property getters can also throw
Properties should not have setters only read only properties can be async.
```swift
extension UIImage {
    var thumbnail: UIImage? {
        get async {
            let size = CGSize(width: 50, height: 50)
            return await self.PreparingThumbnail(ofSize: size)
        }
    }
}
```
- `async` enables a function to suspend
- when a function suspends itself it suspends its callers too so its callers must be async as well
- async function might suspend one or many times the `await` keyword is used.
- while an async function is suspended the thread is not blocked. so the system is free to schedule other work
- while an async function is suspended it gives control of the thread to the system and asks the system to schedule the work for the async method. But at this point the system is in control and that work may not be started immediately. The thread can be used for other things instead. 
- Async functions omit leading words like "get" while naming functions

## Async alternatives and Continuations
- Continuation can be used with completion blocks and delegate call backs 
- withCheckedThrowingContinuation is a method that take completion blocks and awaits for the result
- withCheckedContinuation can be used in places where a function will never throw an error
- continuation.resume(result from completion handler), this function unsuspends the call
- continuations must be resumed exactly once on every path
- Discarding continuation without resuming is not allowed
