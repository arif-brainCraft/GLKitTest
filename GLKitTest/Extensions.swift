//
//  Extensions.swift
//  GLKitTest
//
//  Created by BCL Device7 on 15/9/22.
//

import Foundation


extension Array{
    func size() -> Int {
        return MemoryLayout<Element>.stride * self.count
    }
}
