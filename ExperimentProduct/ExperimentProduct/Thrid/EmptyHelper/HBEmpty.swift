//
//  HBEmpty.swift
//  EmptyKit-Demo
//
//  Created by hubin on 2021/10/21.
//  Copyright © 2021 archerzz. All rights reserved.
//

import Foundation
import UIKit
/// Empty
public final class HBEmpty<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

/**
A type that has Empty extensions.
*/
public protocol HBEmptyCompatible {
    associatedtype HBCompatibleType
    var hb_ept: HBCompatibleType { get }
}

// MARK: - EmptyCompatible
public extension HBEmptyCompatible {
    var hb_ept: HBEmpty<Self> {
        get { return HBEmpty(self) }
    }
}

// MARK: - UIScrollView EmptyCompatible
extension UIScrollView: HBEmptyCompatible {}
