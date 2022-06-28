//
//  CustomTabBar.swift
//  IUCA Tour
//
//  Created by User on 1/9/22.
//

import UIKit


class CustomTabBar: UITabBar {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
          var size = super.sizeThatFits(size)
          size.height = 88
          return size
     }
}
