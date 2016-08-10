//
//  GCD.swift
//  ServiceKitDemo
//
//  Created by CaiLianfeng on 16/8/10.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation
import Dispatch

extension DispatchQueue {
    
    public class func safeSyncMain(item: DispatchWorkItem) {
        if Thread.isMainThread {
            item.perform()
        }else {
            DispatchQueue.main.sync {
                item.perform()
            }
        }
    }
}



