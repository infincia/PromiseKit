@inline(__always)
private func _race<U: Thenable>(_ thenables: [U]) -> Promise<U.T> {
    let result = Promise<U.T>(.pending)
    for thenable in thenables {
        thenable.pipe{ result.schrödinger = .resolved($0) }
    }
    return result
}

public func race<U: Thenable>(_ thenables: U...) -> Promise<U.T> {
    return _race(thenables)
}

public func race<U: Thenable>(_ thenables: [U]) -> Promise<U.T> {
    guard !thenables.isEmpty else {
        return Promise(error: PMKError.badInput)
    }
    return _race(thenables)
}

public func race<T>(_ guarantees: Guarantee<T>...) -> Guarantee<T> {
    let (result, seal) = Guarantee<T>.pending()
    for guarantee in guarantees {
        guarantee.pipe(to: seal)
    }
    return result
}
