// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

public struct Gcd {
    
    public enum QueueType {
        case main
        case global(DispatchQoS.QoSClass)
        case custom(String)
        
        var queue: DispatchQueue {
            switch self {
            case .main:
                return DispatchQueue.main
            case .global(let qos):
                return DispatchQueue.global(qos: qos)
            case .custom(let label):
                return DispatchQueue(label: label)
            }
        }
        
    }
    
    /// 原子锁
    ///
    /// - Parameters:
    ///   - lock: 被锁元素
    ///   - closure: 闭包
    public func synchronzed(_ lock: Any, closure: () -> Void) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    /// 子线程线程异步延时
    ///
    /// - Parameters:
    ///   - label: 标识
    ///   - time: 时间 (秒)
    ///   - event: 延时事件
    public static func delay(_ queueType: QueueType = .main, seconds: TimeInterval = 0, event: @escaping () -> Void) {
        let time = DispatchTime.now() + .milliseconds(Int(seconds * 1000))
        queueType.queue.asyncAfter(deadline: time) {
            event()
        }
    }
    
    /// 耗时(秒)
    /// - Parameter block: 需要测试执行的代码
    public static func duration(unit: Double = 1e-9, _ closure: (_ finished: @escaping () throws -> Double) async throws -> Void) async rethrows {
        // 获取转换因子
        var info = mach_timebase_info_data_t()
        mach_timebase_info(&info)
        // 获取开始时间
        let t0 = mach_absolute_time()
        try await closure({
            // 获取结束时间
            let t1 = mach_absolute_time()
            return TimeInterval(Int(t1 - t0) * Int(info.numer) / Int(info.denom)) * unit
        })
    }
    
    /// 耗时(秒)
    /// - Parameter block: 需要测试执行的代码
    public static func duration(unit: Double = 1e-9, _ closure: (_ finished: @escaping () throws -> Double) throws -> Void) rethrows {
        // 获取转换因子
        var info = mach_timebase_info_data_t()
        mach_timebase_info(&info)
        // 获取开始时间
        let t0 = mach_absolute_time()
        try closure({
            // 获取结束时间
            let t1 = mach_absolute_time()
            return TimeInterval(Int(t1 - t0) * Int(info.numer) / Int(info.denom)) * unit
        })
    }
    
    /// 异步线程组
    ///
    /// - Parameters:
    ///   - asyncs: 异步线程组
    ///   - notify: 全部完成回调
    public static func group(asyncs: (() -> Void)..., notify: @escaping () -> Void) {
        let group = DispatchGroup()
        let randromLabel = "stem.gcd.group.\(Int.random(in: 0...10000))"
        var flag = 0
        
        for item in asyncs {
            let queue = DispatchQueue(label: randromLabel + ".\(flag)")
            queue.async(group: group) {
                item()
            }
            flag += 1
        }
        group.notify(queue: DispatchQueue.main) {
            notify()
        }
        
    }
    
    /// 定时
    ///
    /// - Parameters:
    ///   - interval: 间隔(s)
    ///   - event: 定时事件
    ///   - completion: 完成回调
    /// - Returns: DispatchSourceTimer
    @discardableResult
    public static func `repeat`(interval: TimeInterval,
                                event: @escaping ((_: DispatchSourceTimer) -> Void),
                                completion: (() -> Void)? = nil) -> DispatchSourceTimer {
        return self.repeat(interval: interval, keep: 0, leeway: 0.1, event: event, completion: completion)
    }
    
    /// 定时
    ///
    /// - Parameters:
    ///   - interval: 间隔(s)
    ///   - keep: 持续时间, 小于 0 则会一直执行
    ///   - event: 定时事件
    ///   - completion: 完成回调
    /// - Returns: DispatchSourceTimer
    @discardableResult
    public static func `repeat`(interval: TimeInterval,
                                keep: TimeInterval,
                                event: @escaping (_: DispatchSourceTimer) -> Void,
                                completion: (() -> Void)? = nil) -> DispatchSourceTimer {
        return self.repeat(interval: interval, keep: keep, leeway: 0.1, event: event, completion: completion)
    }
    
    /// 定时
    ///
    /// - Parameters:
    ///   - interval: 间隔(s)
    ///   - keep: 持续时间, 小于 0 则会一直执行
    ///   - leeway: 精度, 默认 0.1
    ///   - event: 定时事件
    ///   - completion: 完成回调
    /// - Returns: DispatchSourceTimer
    @discardableResult
    public static func `repeat`(interval: TimeInterval,
                                keep: TimeInterval,
                                leeway: Double = 0.1,
                                event: @escaping ((_: DispatchSourceTimer) -> Void),
                                completion: (() -> Void)? = nil) -> DispatchSourceTimer {
        let intervalTime = DispatchTimeInterval.milliseconds(Int(interval * 1000))
        let leewayTime = DispatchTimeInterval.milliseconds(Int(leeway * 1000))
        
        let queue = DispatchQueue.global()
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        
        if keep > 0 {
            let keepTime = DispatchTime.now() + .milliseconds(Int(keep * 1000))
            queue.asyncAfter(deadline: keepTime) {
                if timer.isCancelled { return }
                timer.cancel()
                completion?()
            }
        }
        
        timer.schedule(deadline: .now(), repeating: intervalTime, leeway: leewayTime)
        timer.setCancelHandler {
            DispatchQueue.main.async { completion?() }
        }
        
        timer.setEventHandler {
            DispatchQueue.main.async { event(timer) }
        }
        
        timer.resume()
        return timer
    }
    
}
