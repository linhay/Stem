extension IndexPath: StemValueCompatible {}

extension StemValue where Base == IndexPath {

    static let zero = IndexPath(item: 0, section: 0)
    
}
