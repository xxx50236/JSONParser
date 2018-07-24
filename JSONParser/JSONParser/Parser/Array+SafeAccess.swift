//
//  Array+SafeAccess.swift
//  JSONParser
//
//  Created by CB on 2018/7/20.
//  Copyright © 2018 com. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
