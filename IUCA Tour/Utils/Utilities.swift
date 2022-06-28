//
//  Utilities.swift
//  IUCA Tour
//
//  Created by User on 1/3/22.
//

import UIKit



class Utilities {
    
    let userDefaults = UserDefaults.standard
    
    
    
    func saveLangToTheMemory(lang: String) {
        userDefaults.setValue(lang, forKey: "Language")
        
    }
    
    func createViewForBackground(color: UIColor) -> UIView{
        let view = UIView()
        
        view.backgroundColor = color
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 26
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        return view
    }
    
    func createButton(withTitle title: String, backgroundColor: UIColor, withImageFont: UIColor? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        
        if let withImageFont = withImageFont {
            button.setTitleColor(withImageFont, for: .normal)
        } else {
            button.setTitleColor(.white, for: .normal)
        }
        
        button.backgroundColor = backgroundColor
        
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 17)
        
        return button
    }
    
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        iv.image = image
        
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                  paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor,
                         right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                           right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }
    
    func setupViewToAnimate(shadowView: UIView, controllerView: UIView) {
        shadowView.isHidden = false
        controllerView.addSubview(shadowView)
        shadowView.addConstraintsToFillView(controllerView)
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        shadowView.frame.origin.x = controllerView.frame.height / 2
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0,
                       options: .curveEaseOut, animations: {
                        shadowView.alpha = 1
                       }, completion: {
                        _ in
                        
                       })
    }
    
    func hideShadowView(shadowView: UIView, completionHandler: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0,
                       options: .curveEaseIn, animations: {
                        shadowView.alpha = 0
                       }, completion: {
                        _ in
                        shadowView.isHidden = true
                        completionHandler()
                       })
    }
    
    func descriptionStackView(withText text: String, image: UIImage) -> UIStackView {
        let iv = UIImageView()
        let label = UILabel()
        label.text = text
        
        iv.setDimensions(width: 24, height: 24)
        
        label.font = UIFont(name: "Roboto-Regular", size: 16)
        
        iv.image = image
        let stack = UIStackView(arrangedSubviews: [iv, label])
        
        stack.axis = .vertical
        stack.spacing = 11
//        stack.distribution = .fillEqually
      
        
        return stack
    }
    
    
    func createURLForImage(url: String) -> String {
        let urlString = "http://tour.iuca.kg\(url)"
        
        return urlString
    }
    
    func createButtonWithImage(text: String, image: UIImage, colorOfBackground: UIColor) -> UIButton {
        let button = UIButton()
        let label = UILabel()
        let imageView = UIImageView()
        
        label.text = text
        label.font = .systemFont(ofSize: 17)
        label.textColor = .white
        
        imageView.image = image
        
        button.backgroundColor = colorOfBackground
        
        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        
        stack.spacing = 10
        
        stack.isUserInteractionEnabled = false
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.addSubview(stack)
        stack.center(inView: button)
        
        return button
    }
    
    func chooseLanguageButton(withImage imageForFlag: UIImage, label: String) -> UIButton {
        let button = UIButton(type: .system)
        let imageForArrow = UIImageView()
        let imageView = UIImageView()
        let labelUI = UILabel()
        
        labelUI.text = label
        labelUI.textColor = .black
        
        labelUI.font = UIFont(name: "Roboto-Medium", size: 17)
        
        
        imageView.setDimensions(width: 28, height: 28)
        imageView.image = imageForFlag
        
        button.addSubview(imageView)
        imageView.centerY(inView: button, leftAnchor: button.leftAnchor,
                             paddingLeft: 35)
        
        button.addSubview(labelUI)
        labelUI.centerY(inView: button, leftAnchor: imageView.leftAnchor,
                        paddingLeft: 50)
        
        button.addSubview(imageForArrow)
        imageForArrow.centerY(inView: button, rightAnchor: button.rightAnchor,
                              paddingRight: 20)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 57).isActive = true
        
        
        imageForArrow.image = #imageLiteral(resourceName: "Vector-15")
//        imageForArrow.setDimensions(width: 18, height: 14)
        
        return button
        
        
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        return tf
    }
    
    func createCustomBarButton(buttonType: String) -> UIButton {
        
        let button = UIButton()
        
        if buttonType == "RUS" {
            button.setImage(#imageLiteral(resourceName: "Ellipse 10").withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if buttonType == "ENG" {
            button.setImage(#imageLiteral(resourceName: "flag-4").withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if buttonType == "KGZ" {
            button.setImage(#imageLiteral(resourceName: "flag-2").withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if buttonType == "CHN" {
            button.setImage(#imageLiteral(resourceName: "flag-3").withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        return button
    }
    
    func attributedButton (_ firstPart: String, _ secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }
    
    
    func configureActionSheet(navigationController: UINavigationController) {
        
        let text = """
                Вы действительно хотите
                завершить экскурсию?
            """
        
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        
        
        
        let sendButton = UIAlertAction(title: "Да, завершить", style: .destructive, handler: { (action) -> Void in
            DispatchQueue.main.async {
                print("Finish button tapped")
                navigationController.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            }
            
        })
        
        let cancelButton = UIAlertAction(title: "Нет", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(cancelButton)
        
        navigationController.present(alertController, animated: true, completion: nil)
        
    }
    
    func checkInternetConnectionAndResetData(navigationController: UINavigationController, flag: Bool = false) -> Bool {
        var insideFlag = false
        if !NetworkMonitor.shared.isConnected {
            let alert = UIAlertController(title: "NO Internet", message: "This App Requires wifi/internet connection!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                if NetworkMonitor.shared.isConnected {
                    insideFlag = true
                } else {
                    insideFlag = false
                    
                    self.checkInternetConnection(navigationController: navigationController)
                }
            }))
           
            navigationController.present(alert, animated: true, completion: nil)
            
            
        } else {
        }
        
        return insideFlag
    }
    
    func checkInternetConnection(navigationController: UINavigationController, flag: Bool = true) {
        if !NetworkMonitor.shared.isConnected {
            let alert = UIAlertController(title: "NO Internet", message: "This App Requires wifi/internet connection!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                if NetworkMonitor.shared.isConnected {
                    
                } else {
                    if flag {
                    } else {
                       
                    }
                    self.checkInternetConnection(navigationController: navigationController)
                }
            }))
            
            navigationController.present(alert, animated: true, completion: nil)
            
        } else {
        }
    }
}
