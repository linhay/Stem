
import CoreImage

public protocol CIFilterInputRadiusProtocol {
    var filter: CIFilter { get }
}

public extension CIFilterInputRadiusProtocol {

    var radius: NSNumber {
        set { filter.setValue(newValue, forKey: "inputRadius") }
        get { return filter.value(forKey: "inputRadius") as? NSNumber ?? NSNumber(value: -1) }
    }

}

public protocol CIFilterInputImageProtocol {
    var filter: CIFilter { get }
}

public extension CIFilterInputImageProtocol {

    var image: CIImage? {
        set { filter.setValue(newValue, forKey: "inputImage") }
        get { return filter.value(forKey: "inputImage") as? CIImage }
    }

}

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


protocol CIFilterValueProtocol {
    var filter: CIFilter { get }
}

extension CIFilterValueProtocol {

    func set(image: CIImage, for key: String) {
        filter.setValue(image, forKey: key)
    }

    func number(for key: String) -> CIImage? {
        return filter.value(forKey: key) as? CIImage
    }

    func set(number: NSNumber, for key: String) {
        filter.setValue(number, forKey: key)
    }

    func number(for key: String) -> NSNumber {
        return filter.value(forKey: key) as? NSNumber ?? NSNumber(value: -1)
    }

    func set(vector: CIVector, for key: String) {
        filter.setValue(vector, forKey: key)
    }

    func vector1(for key: String) -> CIVector {
        return filter.value(forKey: key) as? CIVector ?? CIVector(x: 0)
    }

    func vector2(for key: String) -> CIVector {
        return filter.value(forKey: key) as? CIVector ?? CIVector(x: 0, y: 0)
    }

    func vector3(for key: String) -> CIVector {
        return filter.value(forKey: key) as? CIVector ?? CIVector(x: 0, y: 0, z: 0)
    }

    func vector4(for key: String) -> CIVector {
        return filter.value(forKey: key) as? CIVector ?? CIVector(x: 0, y: 0, z: 0, w: 0)
    }

    func vector10(for key: String) -> CIVector {
        return filter.value(forKey: key) as? CIVector ?? CIVector(string: "[1 0 0 0 0 0 0 0 0 0]")
    }

}
