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

public struct Device { }

public extension Device {
    
    struct Battery { }
    
}


#if canImport(UIKit)
import UIKit

public extension Device.Battery {
    
    /// 电量比例
    var level: Double {
        let device = UIDevice.current
        let isBatteryMonitoringEnabled = device.isBatteryMonitoringEnabled
        defer { device.isBatteryMonitoringEnabled = isBatteryMonitoringEnabled }
        device.isBatteryMonitoringEnabled = true
        return Double(device.batteryLevel)
    }
    
    
    /// 是否正在充电
    var isCharging: Bool {
        let device = UIDevice.current
        let isBatteryMonitoringEnabled = device.isBatteryMonitoringEnabled
        defer { device.isBatteryMonitoringEnabled = isBatteryMonitoringEnabled }
        device.isBatteryMonitoringEnabled = true
        return device.batteryState == .charging
    }
    
    
    /// 是否是满电
    var isFull: Bool {
        let device = UIDevice.current
        let isBatteryMonitoringEnabled = device.isBatteryMonitoringEnabled
        defer { device.isBatteryMonitoringEnabled = isBatteryMonitoringEnabled }
        device.isBatteryMonitoringEnabled = true
        return device.batteryState == .full
    }
    
}

#endif
