//
//  ConteinerController.swift
//  IUCA Tour
//
//  Created by User on 1/17/22.
//

import UIKit

class ConteinerController: UIViewController {

    // MARK: - Properties
    
    var menuController: UIViewController!
    var centerController: UIViewController!
    var isExpended = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureNextDestinationController()
        self.configureMenuController()
        
    }

    // MARK: - Selectors
    
    // MARK: - Helpers

    func configureNextDestinationController() {
//        let nextDestController = GoToNextDestinationController()
//        centerController = UINavigationController(rootViewController: nextDestController)
//        nextDestController.delegate = self
//
//        view.addSubview(centerController.view)
//        addChild(centerController)
//        centerController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        if menuController == nil {
//            menuController = MenuController()
//            view.insertSubview(menuController.view, at: 0)
//            addChild(menuController)
//            menuController.didMove(toParent: self)
////            menuController.
//            menuController.view.leadingAnchor.constraint(equalTo: menuController.view.leadingAnchor, constant: 10).isActive = true
//            view.addSubview(menuController.view)
//            menuController.view.addConstraintsToFillView(view)
            self.view.addSubview(self.menuController.view)
            self.menuController.view.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: -300, width: 300)
//            self.menuController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -240).isActive = true
        }
    }
    
    func showMenuController(shouldExpand: Bool) {
        
        if shouldExpand {
//            UIView.animate(withDuration: 0.5) {
//                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
//            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                
              
                self.menuController.view.anchor(paddingLeft: 0)

            }, completion: nil)

        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }, completion: nil)
        }
    }
}

extension ConteinerController: GoNextDestinationDelegate {
    func handleMenuToggle() {
        
        if !isExpended {
            configureMenuController()
        }
        
        isExpended = !isExpended
        
        showMenuController(shouldExpand: isExpended)
    }
    
}
