import CoreImage

public protocol CIFilterContainerProtocol {
    var filter: CIFilter { get }
}

public extension CIFilterContainerProtocol {

    var outputImage: CIImage? {
        return filter.outputImage
    }

    var name: String {
        return filter.name
    }

    func setDefaults() {
        return filter.setDefaults()
    }

    var attributes: [String: Any] {
        return filter.attributes
    }
}

@propertyWrapper
class CIFilterValueBox<Value> {

    weak var filter: CIFilter?

    var name: String = ""
    var defaultValue: Value?

    var wrappedValue: Value {
        set { filter?.setValue(newValue, forKey: name) }
        get {
            if let value = filter?.value(forKey: name) as? Value {
                return value
            }
            return defaultValue!
        }
    }

    init() {}

    func cofig(filter: CIFilter, name: String, default value: Value) {
        self.filter = filter
        self.defaultValue = value
        self.name = name
    }
}
