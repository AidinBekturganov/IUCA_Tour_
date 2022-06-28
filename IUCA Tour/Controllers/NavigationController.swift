//
//  NavigationController.swift
//  IUCA Tour
//
//  Created by User on 16/3/22.
//

import UIKit

class NavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return topViewController?.preferredStatusBarStyle ?? .default
    }
}
