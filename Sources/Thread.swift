//
//  Thread.swift
//  ServiceKitDemo
//
//  Created by CaiLianfeng on 16/8/10.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation

import Dispatch

public class RunLoopThread: NSObject {
    var thread: Thread
    
    private class TaskHandler: NSObject {
        var task: DispatchWorkItem?
        
        @objc func performTask() {
            task?.perform()
        }
    }
    
    
    public init(threadName: String? = nil, _ threadPriority: Double? = nil, _ runLoopMode: String? = nil) {
        thread = Thread(block: {
            autoreleasepool {
                let runLoop = RunLoop.current
                if let mode = runLoopMode {
                    runLoop.add(NSMachPort(), forMode:RunLoopMode(rawValue: mode))
                }else {
                    runLoop.add(NSMachPort(), forMode:RunLoopMode.commonModes)
                }
                runLoop.run()
            }
        })
        if let name = threadName {
            thread.name = name
        }
        if let tp = threadPriority {
            thread.threadPriority = tp
        }
        thread.start()
    }
    
    public func async(task: DispatchWorkItem) {
        
        autoreleasepool { () -> Void in
            if thread.isMainThread {
                DispatchQueue.main.async {
                    task.perform()
                }
            }else {
                let taskHandler = TaskHandler()
                taskHandler.task = task
                taskHandler.perform(#selector(TaskHandler.performTask), on: thread, with: nil, waitUntilDone:false)
            }
        }
    }
    
    public func sync(task: DispatchWorkItem) {
        autoreleasepool { () -> Void in
            if thread.isMainThread {
                DispatchQueue.safeSyncMain(item: task)
            }else {
                let taskHandler = TaskHandler()
                taskHandler.task = task
                taskHandler.perform(#selector(TaskHandler.performTask), on: thread, with: nil, waitUntilDone:true)
            }
        }
    }
}

