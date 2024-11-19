//
//  Array+Duplicates.swift
//  Scanner
//
//  Created by Adilkhan Medeuyev on 19.11.2024.
//

import Foundation

extension Array {
    func removingDuplicates(by predicate: (Element, Element) -> Bool) -> [Element] {
        var result = [Element]()
        for value in self {
            if !result.contains(where: { predicate(value, $0) }) {
                result.append(value)
            }
        }
        return result
    }
}
