import Foundation
#if canImport(Dispatch)
import Dispatch
#endif

public final class STLRUCache<Key: Hashable, Value> {
    
    private var values: [Key: Container] = [:]
    private var head: Container?
    private var tail: Container?
    private let lock: NSLock = .init()
    
    /// The current total cost of values in the cache
    public private(set) var totalCost: Int = 0
    
    /// The maximum total cost permitted
    public var costLimit: Int {
        didSet { clean() }
    }
    
    /// The maximum number of values permitted
    public var countLimit: Int {
        didSet { clean() }
    }
    
    public init(costLimit: Int = .max,
                countLimit: Int = .max) {
        self.costLimit = costLimit
        self.countLimit = countLimit
    }
    
#if canImport(Dispatch)
    private var memoryPressure: DispatchSourceMemoryPressure?
    public func enableMemoryPressure() {
        let memoryPressure = DispatchSource.makeMemoryPressureSource(eventMask: [.warning, .critical])
        // 设置事件处理程序
        memoryPressure.setEventHandler { [weak self] in
            guard let self = self,
                  memoryPressure.data.contains(.warning) || memoryPressure.data.contains(.critical) else {
                return
            }
            self.removeAllValues()
        }
        memoryPressure.activate()
        self.memoryPressure = memoryPressure
    }
    
    deinit {
        memoryPressure?.cancel()
    }
#endif
}

public extension STLRUCache {
    /// The number of values currently stored in the cache
    var count: Int {
        values.count
    }
    
    /// Is the cache empty?
    var isEmpty: Bool {
        values.isEmpty
    }
    
    /// Returns all values in the cache from oldest to newest
    var allValues: [Value] {
        lock.lock()
        defer { lock.unlock() }
        var values = [Value]()
        var next = head
        while let container = next {
            values.append(container.value)
            next = container.next
        }
        return values
    }
    
    /// Insert a value into the cache with optional `cost`
    func set(key: Key, _ value: Value?, cost: Int = 0) {
        guard let value = value else {
            remove(of: key)
            return
        }
        lock.lock()
        defer { lock.unlock() }
        if let container = values[key] {
            container.value = value
            totalCost -= container.cost
            container.cost = cost
            remove(container)
            append(container)
        } else {
            let container = Container(value: value, cost: cost, key: key)
            values[key] = container
            append(container)
        }
        totalCost += cost
        clean()
    }
    
    /// Remove a value  from the cache and return it
    @discardableResult
    func remove(of key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }
        guard let container = values.removeValue(forKey: key) else {
            return nil
        }
        remove(container)
        totalCost -= container.cost
        return container.value
    }
    
    /// Fetch a value from the cache
    func value(forKey key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }
        if let container = values[key] {
            remove(container)
            append(container)
            return container.value
        }
        return nil
    }
    
    /// Remove all values from the cache
    func removeAllValues() {
        lock.lock()
        defer { lock.unlock() }
        values.removeAll()
        head = nil
        tail = nil
    }
}

private extension STLRUCache {
    final class Container {
        var value: Value
        var cost: Int
        let key: Key
        var prev: Container?
        var next: Container?
        
        init(value: Value, cost: Int, key: Key) {
            self.value = value
            self.cost = cost
            self.key = key
        }
    }
    
    // Remove container from list (must be called inside lock)
    func remove(_ container: Container) {
        if head === container {
            head = container.next
        }
        if tail === container {
            tail = container.prev
        }
        container.next?.prev = container.prev
        container.prev?.next = container.next
        container.next = nil
    }
    
    // Append container to list (must be called inside lock)
    func append(_ container: Container) {
        assert(container.next == nil)
        if head == nil {
            head = container
        }
        container.prev = tail
        tail?.next = container
        tail = container
    }
    
    // Remove expired values (must be called outside lock)
    func clean() {
        lock.lock()
        defer { lock.unlock() }
        while totalCost > costLimit || count > countLimit,
              let container = head {
            remove(container)
            values.removeValue(forKey: container.key)
            totalCost -= container.cost
        }
    }
}
