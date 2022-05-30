//
//  ReusableViewCell.swift
//  Currency
//
//  Created by kuanwei on 2022/5/11.
//

import Foundation
import UIKit

public protocol ReusableViewCell: NSObjectProtocol {
    static var reuseIdentifier: String { get }

    init()
}

extension ReusableViewCell {
    public static var reuseIdentifier: String {
        let thisType = type(of: self)
        return String(describing: thisType)
    }
}
