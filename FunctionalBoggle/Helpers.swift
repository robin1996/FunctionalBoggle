//
//  Helpers.swift
//  FunctionalBoggle
//
//  Created by Robin Douglas on 21/05/2020.
//  Copyright © 2020 Robin Douglas. All rights reserved.
//

import Foundation

extension Sequence {

    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }

}

extension Array {
    
    func elementsAdjacentToAndIncluding(index: Int) -> [(Int, Element)] {
        [index - 1, index, index + 1].compactMap { $0 >= 0 && $0 < count ? ($0, self[$0]) : nil }
    }
    
}
