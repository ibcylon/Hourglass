//
//  Storage.swift
//  Hourglass
//
//  Created by Kanghos on 2022/02/06.
//

import Foundation

class Storage {
    static func isFirstTime() -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "isFirstTime") == nil {
            defaults.set("No", forKey: "isFirstTime")
            return true
        } else {
            return false
        }
    }
}
