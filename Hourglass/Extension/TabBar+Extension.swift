//
//  TabBar+Extension.swift
//  Hourglass
//
//  Created by Kanghos on 2022/02/05.
//

import UIKit

extension  UITabBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height += 100
        return sizeThatFits
    }
}
