public extension Collection {

    func value(at index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }

    var random: Iterator.Element? {
        return randomElement()
    }

}

[1,2,3,4,5,6].random
["1": 1, "2": 2].value(at: 1)
