//
//  SubclassNavigationController.swift
//  IUCA Tour
//
//  Created by User on 26/4/22.
//

import UIKit

class SubclassNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
      visibleViewController
    }
}
