//
//  SelectLanguageController.swift
//  IUCA Tour
//
//  Created by User on 1/7/22.
//

import UIKit

protocol SelectLanguageDelegate: AnyObject {
    func selectLang(lang: String)
}

class SelectLanguageController: UIViewController {
    //MARK: - Properties
    
    weak var delegate: SelectLanguageDelegate?
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.backgroundColor = .iucaBlue
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 26
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
      
        
        return view
    }()
    
    private lazy var pictureContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
//        view.layer.cornerRadius = 10
//        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        view.addSubview(illustration)
        illustration.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: -5)
        view.setDimensions(width: 288, height: 288)
        
        
        return view
    }()
    
    private let chooseLanguageLabel: UILabel = {
        let label = UILabel()
        
        label.text = """
        Select language
        Тилди танданыз
        Выберите язык
        选择语言
        """
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Regular", size: 23)
        label.textColor = .white
        return label
    }()
    
    private let illustration: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 288, height: 288)
        iv.image = #imageLiteral(resourceName: "Location--5ec7b83701d0360016d48ba6")
        return iv
    }()
    
    private let personImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "Aza 1-1")
        return iv
    }()
    
    private let englishLanguageButton: UIButton = {
        
        let button = Utilities().chooseLanguageButton(withImage: #imageLiteral(resourceName: "flag-1"), label: "ENGLISH LANGUAGE")
        
        button.addTarget(self, action: #selector(handleChooseLanguageEng), for: .touchUpInside)
        
        return button
    }()
    
    private let kyrgyzLanguageButton: UIButton = {
        
        let button = Utilities().chooseLanguageButton(withImage: #imageLiteral(resourceName: "kyr"), label: "КЫРГЫЗ ТИЛИ")
        
        button.addTarget(self, action: #selector(handleChooseLanguageKyr), for: .touchUpInside)
        
        return button
    }()
    
    private let russianLanguageButton: UIButton = {
        
        let button = Utilities().chooseLanguageButton(withImage: #imageLiteral(resourceName: "rus"), label: "РУССКИЙ ЯЗЫК")
        
        button.addTarget(self, action: #selector(handleChooseLanguageRus), for: .touchUpInside)
        
        return button
    }()
    
    private let chineseLanguageButton: UIButton = {
        
        let button = Utilities().chooseLanguageButton(withImage: #imageLiteral(resourceName: "chin-1"), label: "中文")
        
        button.addTarget(self, action: #selector(handleChooseLanguageChin), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        Utilities().checkInternetConnection(navigationController: self.navigationController!)

        
        
    }
    
    //MARK: - Selectors
    
    @objc func handleChooseLanguageEng() {
        updateMainTabController(lang: "ENG")
    }
    
    @objc func handleChooseLanguageKyr() {
        updateMainTabController(lang: "KGZ")
    }
    
    @objc func handleChooseLanguageRus() {
        updateMainTabController(lang: "RUS")
    }
    
    @objc func handleChooseLanguageChin() {
        updateMainTabController(lang: "CHN")
    }
    
    //MARK: - Helpers
    
    func updateMainTabController(lang: String) {
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        guard let tab = window.rootViewController as? MainTabController else { return }
        
        if tab.checkIfLanguageIsSelected(lang: lang) {
            print("DEBUG: select lang is fired1")

            delegate?.selectLang(lang: lang)
            dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: {
                print("DEBUG: select lang is fired")
            })
        }
        
        
        
    }
    
    func configureUI() {
        if #available(iOS 15.0, *) { // For compatibility with earlier iOS.
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .iucaBlue
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.isHidden = true
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
//        navigationController?.navigationBar.barStyle = .black
       
        view.backgroundColor = .white
        
        view.addSubview(pictureContainerView)
        
        pictureContainerView.anchor(top: view.topAnchor, left: view.leftAnchor,
                                    right: view.rightAnchor, height: 300)
        
        
        let stack = UIStackView(arrangedSubviews: [englishLanguageButton, kyrgyzLanguageButton,
                                                   russianLanguageButton, chineseLanguageButton])
        

        stack.axis = .vertical
        stack.spacing = 22
        
        stack.distribution = .fillEqually
        
        let stackWrapperVertical = UIStackView(arrangedSubviews: [UIView(), stack, UIView()])
        stackWrapperVertical.axis = .vertical
        stackWrapperVertical.distribution = .equalCentering
        
        
        let viewOne = UIView()
        viewOne.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        let viewTwo = UIView()
        viewTwo.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        let stackWrapper = UIStackView(arrangedSubviews: [viewOne, stackWrapperVertical, viewTwo])
        stackWrapper.axis = .horizontal
        
        
        
        view.addSubview(conteinerView)
        conteinerView.anchor(top: pictureContainerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        conteinerView.addSubview(stackWrapper)

        stackWrapper.addConstraintsToFillView(conteinerView)
        
        
        navigationItem.title = "Экскурсия"
        
    }
}
