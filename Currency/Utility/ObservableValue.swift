//
//  ObservableValue.swift
//  Currency
//
//  Created by kuanwei on 2022/5/11.
//

import Foundation

public class ObservableValue<T> {
    public var value: T {
        didSet {
            notify()
        }
    }

    public var observe: (T) -> Void = { _ in }

    private func notify() {
        DispatchQueue.main.async {
            self.observe(self.value)
        }
    }

    public init(value: T) {
        self.value = value
    }
}
