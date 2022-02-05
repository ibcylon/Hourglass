//
//  String+Extension.swift
//  Hourglass
//
//  Created by Kanghos on 2021/11/29.
//

import Foundation

extension String {

     var localized: String {
           return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
        }
}
